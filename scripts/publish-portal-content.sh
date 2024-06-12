#!/bin/bash

# This script is part of a workflow that publishes content to the a SwaggerHub Portal instance.

# SwaggerHub Portal API Ref: https://app.swaggerhub.com/apis-docs/smartbear-public/swaggerhub-portal-api/0.2.0-beta
# Tested against SwaggerHub Portal API v0.2.0-beta

# Required environment variables:
# - SWAGGERHUB_API_KEY: SwaggerHub API Key
# - SWAGGERHUB_PORTAL_SUBDOMAIN: SwaggerHub Portal subdomain

PORTAL_SUBDOMAIN="${SWAGGERHUB_PORTAL_SUBDOMAIN}"
SWAGGERHUB_API_KEY="${SWAGGERHUB_API_KEY}"
PORTAL_URL="https://api.portal.swaggerhub.com/v1"

## HELPER FUNCTIONS
function response_check() {
  local response=$1
  # Note: for whatever reason, a 200 response produces an empty response, so we assume its a success,
  #       but we also check for 200 in the block either way
  if [ -n "$response" ]; then

    # lets check for Internal Error, which follows a different structure
    local status=$(echo $response | jq -r .status)
    if [ -n "$status" ]; then
      echo "Failed! with response code $status: $response (contact SwaggerHub Team)"
      exit 1
    fi

    local code=$(echo $response | jq -r .code)
    local message=$(echo $response | jq -r .message)

    if [ $code == "200" ]; then
      echo "Done."
      return
    fi

    echo "Failed! with response $code: $message"
    exit 1
  fi
}

function load_product_manifest_content_metadata() {
    local file=$1
    local product_name=$2

    echo "loading product manifest: $file ..."

    if [ ! -f "$file" ]; then
        echo "File not found: $file"
        exit 1
    fi

    local length=$(jq '.contentMetadata | length' "$file")
    if [ $length -eq 0 ]; then
        echo "No content metadata found in manifest file."
        exit 1
    fi

    for (( i=0; i<$length; i++ )); do
        echo "Item $i:"

        # check type of contentMetadata
        local type=$(jq -r ".contentMetadata[$i].type" "$file")
        local order=$(jq -r ".contentMetadata[$i].order" "$file")
        local parent=$(jq -r ".contentMetadata[$i].parent" "$file")
        local name=$(jq -r ".contentMetadata[$i].name" "$file")
        local slug=$(jq -r ".contentMetadata[$i].slug" "$file")
        local contentUrl=$(jq -r ".contentMetadata[$i].contentUrl" "$file")                

        if [ "$type" == "apiUrl" ]; then
            
            portal_product_toc_api_referece_upsert \
                "$name" \
                "$slug" \
                $order \
                "$contentUrl"
        fi
        else
            portal_product_toc_markdown_upsert "$name" "$slug" $order

            # load markdown content
            markdown_file="../products/$product_name/$contentUrl"
            if [ ! -f "$markdown_file" ]; then
                echo "Markdown file not found: $file"
                exit 1
            fi

            portal_product_document_markdown_patch "$markdown_file"
        fi
        
        #TODO - check if toc exists for this item based on parent      

    done    

    echo "done processing contentMetada from manifest for $product_name."
}

function portal_portal_get_id() {
    
    local response=$(curl -s --request GET \
        --url "$PORTAL_URL/portals?sumdomain=$PORTAL_SUBDOMAIN" \
        --header "Authorization: Bearer $SWAGGERHUB_API_KEY" \
        --header "Content-Type: application/json")

    portal_id=$(echo "$response" | jq -r '.items[0].id')
    echo "${portal_id}"
}

function portal_product_get_id() { 
    local product_name=$1
    local encoded_product_name=$(printf '%s' "$product_name" | od -An -tx1 | tr ' ' % | tr -d '\n')
    
    echo "searching for product: $product_name in portal $portal_id ..."

    local response=$(curl -s --request GET \
        --url "$PORTAL_URL/portals/$portal_id/products?name=$encoded_product_name" \
        --header "Authorization: Bearer $SWAGGERHUB_API_KEY" \
        --header "Content-Type: application/json")

    echo "$PORTAL_URL/portals/$portal_id/products?name=$product_name"

    product_id=$(echo "$response" | jq -r '.items[0].id')
    echo "${product_id}"
}

function portal_product_post() {
    local product_name=$1
    local product_description=$2
    local product_slug=$3
    local product_public=$4
    local product_hidden=$5

    echo "creating product: $product_name in portal $portal_id ..."

    local response=$(curl -s --request POST \
        --url "$PORTAL_URL/portals/$portal_id/products" \
        --header "Authorization: Bearer $SWAGGERHUB_API_KEY" \
        --header "Content-Type: application/json" \
        --data "{
            \"name\": \"$product_name\",
            \"description\": \"$product_description\",
            \"slug\": \"$product_slug\",
            \"public\": $product_public,
            \"hidden\": $product_hidden
        }")

    response_check "$response"
    echo "done creating product."
}

function portal_product_patch() {
    local product_id=$1
    local product_name=$2
    local product_description=$3
    local product_slug=$4
    local product_public=$5
    local product_hidden=$6

    echo "updating product: $product_name in portal $portal_id ..."

    local response=$(curl -s --request PATCH \
        --url "$PORTAL_URL/portals/$portal_id/products/$product_id" \
        --header "Authorization: Bearer $SWAGGERHUB_API_KEY" \
        --header "Content-Type: application/json" \
        --data "{
            \"name\": \"$product_name\",
            \"description\": \"$product_description\",
            \"slug\": \"$product_slug\",
            \"public\": $product_public,
            \"hidden\": $product_hidden
        }")

    response_check "$response"
    echo "done updating product."
}

function portal_product_get_default_section_id() {
    local product_id=$1

    echo "searching for default section in product $product_id ..."

    local response=$(curl -s --request GET \
        --url "$PORTAL_URL/portals/$portal_id/products/$product_id/sections" \
        --header "Authorization: Bearer $SWAGGERHUB_API_KEY" \
        --header "Content-Type: application/json")

    section_id=$(echo "$response" | jq -r '.items[0].id')
    echo "${section_id}"
}

function portal_product_toc_get_id() {
    local section_id=$1
    local title=$2

    echo "searching for API reference: $title in product $product_id ..."

    local response=$(curl -s --request GET \
        --url "$PORTAL_URL/sections/$section_id/table-of-contents" \
        --header "Authorization: Bearer $SWAGGERHUB_API_KEY" \
        --header "Content-Type: application/json")

    product_toc_id=$(echo "$response" | jq -r ".items[] | select(.title == \"$title\") | .id")
    echo "${product_toc_id}"
}

function portal_product_toc_api_referece_upsert() {
    local api_title=$1
    local api_slug=$2
    local content_order=$3
    local api_url=$4

    echo "upserting API reference: $api_title in product $product_id ..."

    product_toc_id= portal_product_toc_get_id "$section_id" "$api_title"

    if [ -z "$product_toc_id" ]; then
        portal_product_toc_api_reference_post "$api_title" "$api_slug" "$content_order" "$api_url"
    else
        portal_product_toc_api_reference_patch "$api_title" "$api_slug" "$content_order" "$api_url"
    fi

    echo "done upserting API reference."
}

function portal_product_toc_api_reference_post() {
    local api_title=$1
    local api_slug=$2
    local content_order=$3
    local api_url=$4

    echo "creating API reference: $api_title in product $product_id ..."

    local response=$(curl -s --request POST \
        --url "$PORTAL_URL/sections/$section_id/table-of-contents" \
        --header "Authorization: Bearer $SWAGGERHUB_API_KEY" \
        --header "Content-Type: application/json" \
        --data "{
            \"title\": \"$api_title\",
            \"slug\": \"$api_slug\",
            \"order\": $content_order,
            \"content\": {
                \"type\": \"apiUrl\",
                \"url\": \"$api_url\"
            }
        }")

    response_check "$response"
    echo "done creating API reference."
}

function portal_product_toc_api_reference_patch() {
    local api_title=$2
    local api_slug=$3
    local content_order=$4
    local api_url=$5

    echo "updating API reference: $api_title in product $product_id ..."

    local response=$(curl -s --request PATCH \
        --url "$PORTAL_URL/sections/$section_id/table-of-contents/$api_reference_toc" \
        --header "Authorization: Bearer $SWAGGERHUB_API_KEY" \
        --header "Content-Type: application/json" \
        --data "{
            \"title\": \"$api_title\",
            \"slug\": \"$api_slug\",
            \"order\": $content_order,
            \"content\": {
                \"type\": \"apiUrl\",
                \"url\": \"$api_url\"
            }
        }")

    response_check "$response"
    echo "done updating API reference."
}

function portal_product_toc_markdown_upsert() {
    local markdown_title=$1
    local markdown_slug=$2
    local content_order=$3
    local contents=$4

    echo "upserting markdown: $markdown_title in product $product_id ..."

    product_toc_id= portal_product_toc_get_id "$section_id" "$markdown_title"

    if [ -z "$product_toc_id" ]; then
        portal_product_toc_markdown_post "$markdown_title" "$markdown_slug" "$content_order"
    else
        portal_product_toc_markdown_patch "$markdown_title" "$markdown_slug" "$content_order"
    fi

    portal_product_document_markdown_patch "$contents"

    echo "done upserting markdown."

}

function portal_product_toc_markdown_post() {
    local markdown_title=$1
    local markdown_slug=$2
    local content_order=$3

    echo "creating markdown: $markdown_title in product $product_id ..."

    local response=$(curl -s --request POST \
        --url "$PORTAL_URL/sections/$section_id/table-of-contents" \
        --header "Authorization: Bearer $SWAGGERHUB_API_KEY" \
        --header "Content-Type: application/json" \
        --data "{
            \"title\": \"$markdown_title\",
            \"slug\": \"$markdown_slug\",
            \"order\": $content_order,
            \"content\": {
                \"type\": \"markdown\"
            }
        }")

    response_check "$response"
    document_id=$(echo "$response" | jq -r .documentId)

    echo "done creating markdown."
}

function portal_product_toc_markdown_patch() {
    local markdown_title=$2
    local markdown_slug=$3
    local content_order=$4

    echo "updating markdown: $markdown_title in product $product_id ..."

    local response=$(curl -s --request PATCH \
        --url "$PORTAL_URL/sections/$section_id/table-of-contents/$markdown_toc" \
        --header "Authorization: Bearer $SWAGGERHUB_API_KEY" \
        --header "Content-Type: application/json" \
        --data "{
            \"title\": \"$markdown_title\",
            \"slug\": \"$markdown_slug\",
            \"order\": $content_order,
            \"content\": {
                \"type\": \"markdown\"
            }
        }")

    response_check "$response"

    # get document id from toc details
    local toc_response=$(curl -s --request GET \
        --url "$PORTAL_URL/sections/$section_id/table-of-contents" \
        --header "Authorization: Bearer $SWAGGERHUB_API_KEY" \
        --header "Content-Type: application/json")

    document_id=$(echo "$toc_response" | jq -r ".items[] | select(.title == \"$markdown_title\") | .content.documentId")
    echo "done updating markdown toc."
}

function portal_product_document_markdown_patch() {
    local contents=$1

    echo "updating markdown document in product $product_id for document $document_id..."

    local response=$(curl -s --request PATCH \
        --url "$PORTAL_URL/documents/$document_id" \
        --header "Authorization: Bearer $SWAGGERHUB_API_KEY" \
        --header "Content-Type: application/json" \
        --data "{
            \"content\": \"$contents\"
        }")
    
    response_check "$response"
    echo "done updating markdown content."
}




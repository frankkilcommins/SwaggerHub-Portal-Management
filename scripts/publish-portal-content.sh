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

portalsResponse=$(curl -s --request GET \
    --url "$PORTAL_URL/portals?sumdomain=$PORTAL_SUBDOMAIN" \
    --header "Authorization: Bearer $SWAGGERHUB_API_KEY" \
    --header "Content-Type: application/json")

portal_id=$(echo "$portalsResponse" | jq -r '.items[0].id')

section_id=""
product_id=""

portal_product_upsert "../products/SwaggerHub Portal APIs/manifest.json" "SwaggerHub Portal APIs"


## HELPER FUNCTIONS
function response_check() {
  local response=$1
  # Note: for whatever reason, a 200 response produces an empty response, so we assume its a success,
  #       but we also check for 200 in the block either way
  if [ -n "$response" ]; then

    # lets check for Internal Error, which follows a different structure
    local status=$(echo $response | jq -r .status)
    if [ -n "$status" ] && [ "$status" != "null" ]; then
      echo "Failed! with response code $status: $response (contact SwaggerHub Team)"
      # exit 1
    fi

    local code=$(echo $response | jq -r .code)
    local message=$(echo $response | jq -r .message)

    if [[ $code =~ ^2 ]]; then
      echo "Done."
      return
    fi

    echo "Failed! with response $code: $message"
    # exit 1
  fi
}

function load_and_process_product_manifest_content_metadata() {
    local file=$1
    local product_name=$2

    echo " >> loading product manifest: $file ..."

    if [ ! -f "$file" ]; then
        echo ">> File not found: $file"
        exit 1
    fi

    local length=$(jq '.contentMetadata | length' "$file")
    if [ $length -eq 0 ]; then
        echo " >> No content metadata found in manifest file."
        exit 1
    fi

    for (( i=0; i<$length; i++ )); do
        echo " >> Processing content item $i of $length ..."

        # check type of contentMetadata
        local type=$(jq -r ".contentMetadata[$i].type" "$file")
        local order=$(jq -r ".contentMetadata[$i].order" "$file")
        local parent=$(jq -r ".contentMetadata[$i].parent" "$file")
        local name=$(jq -r ".contentMetadata[$i].name" "$file")
        local slug=$(jq -r ".contentMetadata[$i].slug" "$file")
        local contentUrl=$(jq -r ".contentMetadata[$i].contentUrl" "$file")                

        if [ "$type" == "apiUrl" ]; then
            
            portal_product_toc_api_reference_upsert \
                "$name" \
                "$slug" \
                $order \
                "$contentUrl"
        else
            portal_product_toc_markdown_upsert "$name" "$slug" $order

            # load markdown content
            markdown_file="../products/$product_name/$contentUrl"
            if [ ! -f "$markdown_file" ]; then
                echo " >> Markdown file not found: $markdown_file"
                exit 1
            fi

            local markdownContent="$(cat "$markdown_file")"
            portal_product_document_markdown_patch "$markdownContent"
        fi
        
        #TODO - check if toc exists for this item based on parent      

    done    

    echo " >> done processing contentMetada from manifest for $product_name."
}

function portal_portal_get_id() {
    
    local response=$(curl -s --request GET \
        --url "$PORTAL_URL/portals?sumdomain=$PORTAL_SUBDOMAIN" \
        --header "Authorization: Bearer $SWAGGERHUB_API_KEY" \
        --header "Content-Type: application/json")

    portal_id=$(echo "$response" | jq -r '.items[0].id')
    #echo "${portal_id}"
}

function portal_product_get_id() { 
    local product_name=$1
    local encoded_product_name=$(printf '%s' "$product_name" | od -An -tx1 | tr ' ' % | tr -d '\n')
    
    echo "searching for product: $product_name in portal $portal_id ..."

    local response=$(curl -s --request GET \
        --url "$PORTAL_URL/portals/$portal_id/products?name=$encoded_product_name" \
        --header "Authorization: Bearer $SWAGGERHUB_API_KEY" \
        --header "Content-Type: application/json")

    product_id=$(echo "$response" | jq -r '.items[0].id')
    #echo "${product_id}"
}

function portal_product_upsert() {
    local file=$1
    local product_name=$2    
    product_id=""
    section_id=""

    echo " ##########################################"
    echo " ## Processing product: $product_name"
    echo " ##########################################"
    echo " >> loading product manifest: $file ..."

    if [ ! -f "$file" ]; then
        echo " >> File not found: $file"
        exit 1
    fi

    local length=$(jq '.productMetadata | length' "$file")
    if [ $length -eq 0 ]; then
        echo " >> No product metadata found in manifest file."
        exit 1
    fi

    local product_description=$(jq -r ".productMetadata.description" "$file")
    local product_slug=$(jq -r ".productMetadata.slug" "$file")
    local product_public=$(jq -r ".productMetadata.public" "$file")
    local product_hidden=$(jq -r ".productMetadata.hidden" "$file")

    echo " >> upserting product: $product_name in portal $portal_id ..."

    portal_product_get_id "$product_name"

    if [ -z "$product_id" ] || [ "$product_id" == "null" ]; then
        portal_product_post "$product_name" "$product_description" "$product_slug" $product_public $product_hidden
    else
        portal_product_patch "$product_id" "$product_name" "$product_description" "$product_slug" $product_public $product_hidden
    fi

    # get default section id
    portal_product_get_default_section_id "$product_id"

    echo " >> done upserting product and retrieving default section."
}

function portal_product_post() {
    local product_name=$1
    local product_description=$2
    local product_slug=$3
    local product_public=$4
    local product_hidden=$5

    echo " >> >> creating product: $product_name in portal $portal_id ..."

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

    #echo "POST Products Response: $response"

    product_id=$(echo "$response" | jq -r .id)

    echo " >> >> done creating product."
}

function portal_product_patch() {
    local product_id=$1
    local product_name=$2
    local product_description=$3
    local product_slug=$4
    local product_public=$5
    local product_hidden=$6

    echo " >> >> updating product: $product_name in portal $portal_id ..."

    local response=$(curl -s --request PATCH \
        --url "$PORTAL_URL/products/$product_id" \
        --header "Authorization: Bearer $SWAGGERHUB_API_KEY" \
        --header "Content-Type: application/json" \
        --data "{
            \"name\": \"$product_name\",
            \"description\": \"$product_description\",
            \"slug\": \"$product_slug\",
            \"public\": $product_public,
            \"hidden\": $product_hidden
        }")

    #echo "PATCH Products Response: $response"
    echo " >> >> done updating product."
}

function portal_product_get_default_section_id() {
    local product_id=$1

    echo " >> >> searching for default section in product $product_id ..."

    local response=$(curl -s --request GET \
        --url "$PORTAL_URL/products/$product_id/sections" \
        --header "Authorization: Bearer $SWAGGERHUB_API_KEY" \
        --header "Content-Type: application/json")

    section_id=$(echo "$response" | jq -r '.items[0].id')

    # if no default section, create one
    if [ -z "$section_id" ] || [ "$section_id" == "null" ]; then
        portal_product_section_post "$product_id"
    fi

    echo " >> >> Default section_id: ${section_id}"
}

function portal_product_section_post() {
    local product_id=$1

    echo " >> >> creating default section in product $product_id ..."

    local response=$(curl -s --request POST \
        --url "$PORTAL_URL/products/$product_id/sections" \
        --header "Authorization: Bearer $SWAGGERHUB_API_KEY" \
        --header "Content-Type: application/json" \
        --data "{
            \"title\": \"default\",
            \"slug\": \"default\",
            \"order\": 0
        }")

    section_id=$(echo "$response" | jq -r .id)

    #echo "POST Sections Response: $response"
    echo " >> >> done creating default section."
    #echo "${section_id}"
}

function portal_product_toc_get_id() {
    local product_section_id=$1
    local title=$2

    echo " >> >> searching for API reference: $title in product $product_id and section $product_section_id ..."

    local response=$(curl -s --request GET \
        --url "$PORTAL_URL/sections/$product_section_id/table-of-contents" \
        --header "Authorization: Bearer $SWAGGERHUB_API_KEY" \
        --header "Content-Type: application/json")

    if [ $(echo "$response" | jq '.items | length') -gt 0 ]; then
        product_toc_id=$(echo "$response" | jq -r ".items[] | select(.title == \"$title\") | .id")
        product_toc_slug=$(echo "$response" | jq -r ".items[] | select(.title == \"$title\") | .slug")
        echo " >> >> product_toc_id: ${product_toc_id} and product_toc_slug: ${product_toc_slug}"
    else
        product_toc_id=""
        product_toc_slug=""
        echo " >> >> no product_toc_id found."
    fi  
    
}

function portal_product_toc_api_reference_upsert() {
    local api_title=$1
    local api_slug=$2
    local content_order=$3
    local api_url=$4

    echo " >> upserting API reference: $api_title in product $product_id ..."
    #echo "section_id: $section_id"

    portal_product_toc_get_id "$section_id" "$api_title"

    if [ -z "$product_toc_id" ] || [ "$product_toc_id" == "null" ]; then
        portal_product_toc_api_reference_post "$section_id" "$api_title" "$api_slug" "$content_order" "$api_url"
    else
        portal_product_toc_api_reference_patch "$api_title" "$api_slug" "$content_order" "$api_url" "$product_toc_slug"
    fi

    echo " >> done upserting API reference."
}

function portal_product_toc_api_reference_post() {
    local product_section_id=$1
    local api_title=$2
    local api_slug=$3
    local content_order=$4
    local api_url=$5

    echo " >> >> creating API reference: $api_title in product $product_id and section $product_section_id..."

    local response=$(curl -s --request POST \
        --url "$PORTAL_URL/sections/$product_section_id/table-of-contents" \
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

    #echo "POST ToC Response: $response"
    echo " >> >> done creating API reference."
}

function portal_product_toc_api_reference_patch() {
    local api_title=$1
    local api_slug=$2
    local content_order=$3
    local api_url=$4
    local existing_slug=$5

    echo " >> >> updating API reference: $api_title in product $product_id ..."

    # currently, the API returns a 409 if updating the slug to the value it already has
    # First we need to get the current slug value and only include if different
    if [ "$api_slug" == "$existing_slug" ]; then
        echo " >> >> slug is the same, not updating slug."
        local response=$(curl -s --request PATCH \
            --url "$PORTAL_URL/table-of-contents/$product_toc_id" \
            --header "Authorization: Bearer $SWAGGERHUB_API_KEY" \
            --header "Content-Type: application/json" \
            --data "{
                \"title\": \"$api_title\",
                \"order\": $content_order,
                \"content\": {
                    \"type\": \"apiUrl\",
                    \"url\": \"$api_url\"
                }
            }")
    else
        local response=$(curl -s --request PATCH \
            --url "$PORTAL_URL/table-of-contents/$product_toc_id" \
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
    fi

    echo " >> >> done updating API reference."
}

function portal_product_toc_markdown_upsert() {
    local markdown_title=$1
    local markdown_slug=$2
    local content_order=$3
    #local contents=$4

    echo " >> upserting markdown toc: $markdown_title in product $product_id ..."

    portal_product_toc_get_id "$section_id" "$markdown_title"

    if [ -z "$product_toc_id" ] || ["$product_toc_id" == "null" ]; then
        portal_product_toc_markdown_post "$section_id" "$markdown_title" "$markdown_slug" "$content_order"
    else
        portal_product_toc_markdown_patch "$section_id" "$product_toc_id" "$markdown_title" "$markdown_slug" "$content_order" "$product_toc_slug"
    fi

    #portal_product_document_markdown_patch "$contents"

    echo " >> done upserting markdown toc."

}

function portal_product_toc_markdown_post() {
    local product_section_id=$1
    local markdown_title=$2
    local markdown_slug=$3
    local content_order=$4

    echo " >> >> creating markdown: $markdown_title in product $product_id ..."

    local response=$(curl -s --request POST \
        --url "$PORTAL_URL/sections/$product_section_id/table-of-contents" \
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

    #echo "POST ToC (markdown) Response: $response"
    document_id=$(echo "$response" | jq -r .documentId)

    echo " >> >> done creating markdown."
}

function portal_product_toc_markdown_patch() {
    local product_section_id=$1
    local markdown_toc=$2
    local markdown_title=$3
    local markdown_slug=$4
    local content_order=$5
    local product_toc_slug=$6

    echo " >> >> updating markdown: $markdown_title in product $product_id ..."

    # currently, the API returns a 409 if updating the slug to the value it already has
    # First we need to get the current slug value and only include if different

    if [ "$markdown_slug" == "$product_toc_slug" ]; then
        echo " >> >> slug is the same, not updating slug."
        local response=$(curl -s --request PATCH \
            --url "$PORTAL_URL/table-of-contents/$markdown_toc" \
            --header "Authorization: Bearer $SWAGGERHUB_API_KEY" \
            --header "Content-Type: application/json" \
            --data "{
                \"title\": \"$markdown_title\",
                \"order\": $content_order,
                \"content\": {
                    \"type\": \"markdown\"
                }
            }")
    else

        local response=$(curl -s --request PATCH \
            --url "$PORTAL_URL/table-of-contents/$markdown_toc" \
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
    fi

    # get document id from toc details
    local toc_response=$(curl -s --request GET \
        --url "$PORTAL_URL/sections/$product_section_id/table-of-contents" \
        --header "Authorization: Bearer $SWAGGERHUB_API_KEY" \
        --header "Content-Type: application/json")

    document_id=$(echo "$toc_response" | jq -r ".items[] | select(.title == \"$markdown_title\") | .content.documentId")
    echo " >> >> done updating markdown toc."
}

function portal_product_document_markdown_patch() {
    local contents=$1

    echo " >> >> updating markdown document in product $product_id for document $document_id..."

    #local escaped_contents=$(echo "$contents" | sed ':a;N;$!ba;s/\n/\\n/g')
    local escaped_contents=$(jq -Rs . <<< "$contents")

    #echo " >> >> escaped_contents: $escaped_contents"

    local response=$(curl -s --request PATCH \
        --url "$PORTAL_URL/documents/$document_id" \
        --header "Authorization: Bearer $SWAGGERHUB_API_KEY" \
        --header "Content-Type: application/json" \
        --data "{
            \"content\": $escaped_contents
        }")
    
    echo " >> >> done updating markdown content."
}




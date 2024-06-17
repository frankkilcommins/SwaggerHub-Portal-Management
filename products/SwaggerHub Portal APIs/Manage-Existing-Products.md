 It's very natural to want to manage an existing API product. The administrative APIs support editing the product settings, as well as the ability to add, edit, or delete API references and markdown documents. Should the need arise to delete a product completely, the APIs also cater for this use case.

## Edit Product Settings

A product's settings can be updated via a `PATCH` request to the [`/products/{productId}`](https://frankkilcommins.portal.swaggerhub.com/swaggerhub-portal/default/swaggerhub-portal-api#/Products/patchProduct) endpoint.

Sample cURL request to update product settings:

```
curl --location --request PATCH 'https://api.portal.swaggerhub.com/v1/products/<PRODUCT-ID>' \
--header 'Authorization: Bearer <YOUR-SWAGGERHUB-APIKEY>' \
--header 'Content-Type: application/json' \

--data '{
  "name": "Pet Adoptions",
  "slug": "pet-adoptions",
  "description": "API documentation, tutorials, and guides enabling programmatic adoption of pets",
  "public": true,
  "hidden": false
}'
```

## Edit API Reference, Documentation, or Table of Contents Order

A product's API references, markdown document references, or table-of-contents orders can be updated via a `PATCH` request to the [`/table-of-contents/{id}`](https://frankkilcommins.portal.swaggerhub.com/swaggerhub-portal/default/swaggerhub-portal-api#/Content-Table-of-Contents/patchTableOfContents) endpoint.

Sample cURL request to update a product API reference:

```
curl --location --request PATCH 'https://api.portal.swaggerhub.com/v1/table-of-contents/<ID>' \
--header 'Authorization: Bearer <YOUR-SWAGGERHUB-APIKEY>' \
--header 'Content-Type: application/json' \

--data '{
  "slug": "pets-and-adoptions-api-1.0.0",
  "title": "Pets and Adoptions API",
  "order": 3,
  "content": {
    "type": "apiUrl",
    "url": "https://api.swaggerhub.com/apis/frank-kilcommins/Pets-and-Adoptions-API/1.0.0/swagger.json"
  } 
}'
```

> It's possible to have multiple API references and documents as part of a product. To add additional content to the *table-of-contents* follow the guides in [Add APIs and Docs to Product](https://frankkilcommins.portal.swaggerhub.com/swaggerhub-portal/default/add-apis-and-docs-to-product)
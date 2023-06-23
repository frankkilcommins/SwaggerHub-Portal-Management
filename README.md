# SwaggerHub-Portal-Management

This ReadMe demonstrates how to automate the configuration and manage products to be published and displayed within a SwaggerHub portal instance.


A sample product configuration for the _SwaggerHub Portal API_ exists in this [folder](./products/SwaggerHub%20Portal%20APIs/)

The product contains documents to cover:
- [Getting Started with the SwaggerHub Portal APIs](./products/SwaggerHub%20Portal%20APIs/Getting-Started.md)
- [Why you would automate your portal](./products/SwaggerHub%20Portal%20APIs/Automate-Your-Portal.md)

Additional, they following functional use-cases are covered:

 1. [Manage Portal Settings (appearance, logos, fonts, etc.)](./products/SwaggerHub%20Portal%20APIs/Manage-Portal-Settings.md)
 2. [Create and publish new Product](./products/SwaggerHub%20Portal%20APIs/Create-New-Product.md)
 3. [Add APIs and Documents to Product](./products/SwaggerHub%20Portal%20APIs/Add-Product-Content.md)
 4. [Manage existing Products](./products/SwaggerHub%20Portal%20APIs/Manage-Existing-Products.md)
 

### File structure (todo)

- images - all images for the portal configuration
- manifest - contains metadata for the portal settings
- products - contains all products to be configured
  - product_1 - contains all data relevant to Product1
    - *.md files - contains the markdown documents to be published
    - images folder - all images relevant to the Product (or referenced from the md files)
    - manifest - links to the APIs that will be added to the Product 1
  - product_2 ...
  - product_N

### Other ToDos
 
 - Harden the Portal API OpenAPI document

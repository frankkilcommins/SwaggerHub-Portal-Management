# SwaggerHub-Portal-Management

This repository demonstrates how to automate the deployment of products and product content to be published to a [SwaggerHub Portal](https://swagger.io/tools/swaggerhub/features/swaggerhub-portal/?utm_medium=product&utm_source=GitHub&utm_campaign=devrel-portal&utm_content=automation-reference) instance 🚀

[![Docs-As-Code-Automation-APIHub](https://img.youtube.com/vi/7D5bbaj60Cc/0.jpg)](https://www.youtube.com/watch?v=7D5bbaj60Cc)

This bootstrapped repository is setup with 3 sample products which will be deployed and optionally auto-published.

- A sample "_Adopt a Pet_" product exists in this [folder](./products/Adopt-a-Pet/)
- A sample "_SwaggerHub Portal APIs_" product exists in this [folder](./products/SwaggerHub%20Portal%20APIs/)
- A sample "_Zephyr Squad APIs_" product exists in this [folder](./products/Zephyr%20Squad%20APIs/)

 Each product has varying number of pages, images, content nesting etc.

## Getting Started

To leverage this automation process for your own SwaggerHub Portal, the recommended process is as follows:

- Fork this repo to your local GitHub profile/organization
- Create the appropriate folders and content underneath the [products folder](./products/) following the [conventions](#conventions) laid out below.
- Setup the required repository secrets, environment(s), and environment variables needed by the configured [GitHub Actions](#github-actions).
- Delete the boilerplate products folders: "_Adopt a Pet_",  "_SwaggerHub Portal APIs_", and "_Zephyr Squad APIs_".
- Run the GitHub Actions to validate and publish your content.

## Conventions

The automation works by uploading content structured in accordance with the following conventions.

### Folder / File Structure Conventions

The following product structure must be adhered to allow for the automation to process the products and content:

- products _folder_- a folder containing all products to be uploaded and published. Each product _sub-folder_ name will be used as the `product name` created/modified within the portal
  - product One _folder_ - contains all data relevant to "Product One"
    - `*.md / *.html` _files_ - contains the markdown and/or HTML documents to be published within "Product One". The file name is used as the table-of-contents entry name.
    - images _folder_ - a folder to house the product logo and _embedded_ sub-folder
      - `*.png / *.jpeg` - a root level image to be used as the product logo (needs to be reference from the `manifest.json`)
      - embedded _folder_ - a folder to storing all images to be embedded within the product markdown (or HTML) pages. See the image embedding conventions ([markdown](#image-embedding-convention-markdown) or [html](#image-embedding-convention-html)) for more info on how to reference.
    - manifest.json - stores product metadata (like description, slug, logo url, visibility, etc.) and content metadata (like table of contents order, page nesting, etc.)
  - product Two _folder_ ...
  - product N _folder_ ...

### Image Embedding Convention (Markdown)

The automation process will first publish all product images and then use the published metadata to replace image link placeholders within the markdown content.

The convention is as follows:

`![image-filename-including-file-extension](relative path to image in the ./images/embedded folder)`

An example of how an image should be referenced in the markdown is as follows:

```markdown
![Sample-Portal-Landing-With-Product.png](./images/embedded/Sample-Portal-Landing-With-Product.png)
```

### Image Embedding Convention (HTML)

The automation process will first publish all product images and then use the published metadata to replace image link placeholders within the html content.

The convention is as follows (within an `<img>` element):

`src="relative path to image in the ./images/embedded folder"`

An example of how an image should be referenced in the html is as follows (you can choose appropriate dimensions and styles):

```html
<img height="256" src="./images/embedded/arazzo_horizontal_color.png" style="aspect-ratio:993/256;" width="993"/>
```

### OpenAPI References Convention (Markdown)

The OpenAPI references are predictable based on your known SwaggerHub Portal sub-domain.

The convention for embedding a link to a specific OpenAPI operation within a markdown page is as follows:

`[link text of your choice](https://<YOUR-SWAGGERHUB-SUBDOMAIN>.portal.swaggerhub.com/<PRODUCT-SLUG>/docs/<API-SLUG>#/<OPENAPI-TAG-CONTAINING-OPERATIONAL-IF-APPLICABLE>/<OPENAPI-OPERATION-ID>)`.

So you will replace the following parameters which are all known up front:

- `YOUR-SWAGGERHUB-SUBDOMAIN` - the sub-domain used by your portal instance
- `PRODUCT-SLUG` - the slug defined for your product (defined in the relevant manifest.json within `productMetadata`)
- `API-SLUG` - the slug defined for your API content (defined in the relevant manifest.json)
- `OPENAPI-TAG-CONTAINING-OPERATIONAL-IF-APPLICABLE` - if your operation is nested under a tag then you should define the link with the appropriate tag name
- `OPENAPI-OPERATION-ID` - the `operationId` of the path item object within the API you want to reference from the markdown

An example of how an operation reference should be embedded in the markdown is as follows:

```markdown
Check out the products operation at [`/products`](https://frankkilcommins.portal.swaggerhub.com/swaggerhub-portal/docs/swaggerhub-portal-api#/Products/createProduct).
```

### OpenAPI References Convention (HTML)

The OpenAPI references are predictable based on your known SwaggerHub Portal sub-domain.

The convention for embedding a link to a specific OpenAPI operation within a html page is as follows:
`<a href="/<PRODUCT-SLUG>/docs/<API-SLUG>#/<OPENAPI-TAG-CONTAINING-OPERATIONAL-IF-APPLICABLE>/<OPENAPI-OPERATION-ID>">`

So you will replace the following parameters which are all known up front:

- `PRODUCT-SLUG` - the slug defined for your product (defined in the relevant manifest.json within `productMetadata`)
- `API-SLUG` - the slug defined for your API content (defined in the relevant manifest.json)
- `OPENAPI-TAG-CONTAINING-OPERATIONAL-IF-APPLICABLE` - if your operation is nested under a tag then you should define the link with the appropriate tag name
- `OPENAPI-OPERATION-ID` - the `operationId` of the path item object within the API you want to reference from the markdown

An example of how an operation reference should be embedded in the HTML is as follows:

```html
Check out the <a href="/pet-adoptions/docs/adoptions#/adoptions/postAdoption">docs</a>
```

### Relative Page Links Convention (Markdown)

Linking between pages that are part of your product also follow a predictable convention. The convention for embedding a link to a specific another product page within a markdown page is as follows:

`[link text of your choice](https://<YOUR-SWAGGERHUB-SUBDOMAIN>.portal.swaggerhub.com/<PRODUCT-SLUG>/docs/<CONTENTMETADATA-SLUG>)`.

So you will replace the following parameters which are all known up front:

- `YOUR-SWAGGERHUB-SUBDOMAIN` - the sub-domain used by your portal instance
- `PRODUCT-SLUG` - the slug defined for your product (defined in the relevant manifest.json within `productMetadata`)
- `CONTENTMETADATA-SLUG` - the slug defined for page you want to link to (defined in the relevant manifest.json)

Here is an example of how a relative page link should be inserted into the markdown:

```markdown
Check out our [csharp](https://frankkilcommins.portal.swaggerhub.com/pet-adoptions/docs/client-code-csharp) client implementation.
```

You can link to a specific anchor using normal anchor referencing (e.g. `/#someanchor` being appended to your link URL). Links to external pages and sources operation as normal (e.g. `[link text of your choice](full URL to external source)`).

### Relative Page Links Convention (HTML)

Linking between pages that are part of your product also follow a predictable convention. The convention for embedding a link to a specific another product page within a html page is as follows:

`<a href="CONTENTMETADATA-SLUG">`.

So you will replace the following parameters which are all known up front:

- `CONTENTMETADATA-SLUG` - the slug defined for page you want to link to (defined in the relevant manifest.json)

Here is an example of how a relative page link should be inserted into the HTML:

```html
<p>Check out <a href="authentication">auth docs</a>.</p>
```

You can link to a specific anchor using normal anchor referencing (e.g. `/#someanchor` being appended to your link URL). Links to external pages and sources operation as normal (e.g. `[link text of your choice](full URL to external source)`).

### General HTML Page Information

When creating a HTML page, you just create a HTML snippet. All this means is that you omit the HTML, head, and body wrapper elements (`<html><head>...</head><body>...</body></html>`).

The safest approach is to follow the guidelines from [CKEditor Docs](https://ckeditor.com/docs/ckeditor5/latest) as that is the WYSIWYG editor we use for HTML pages.

#### Supported Code Block Languages

| Language    | css class               |
|------------ |-------------------------|
| plain text  | language-plaintext      |
| C           | language-c              |
| C#          | language-cs             |
| C++         | language-cpp            |
| CSS         | language-css            |
| Diff        | language-diff           |
| HTML        | language-html           |
| Java        | language-java           |
| JavaScript  | language-javascript     |
| PHP         | language-php            |
| Python      | language-python         |
| Ruby        | language-ruby           |
| TypeScript  | language-typescript     |
| XML         | language-xml            |

An embedded snippet example for C#:

```html
<pre><code class="language-cs">
    using System.Net.Http.Headers;
    var client = new HttpClient();
    var request = new HttpRequestMessage
    {
        Method = HttpMethod.Get,
        RequestUri = new Uri("https://virtserver.swaggerhub.com/frank-kilcommins/Portal-API-Copy/0.2.0-beta/portals"),
        Headers =
        {
            { "Accept", "application/json, application/problem+json" },
            { "Authorization", "Bearer <INSERT TOKEN HERE>" },
        },
    };
    using (var response = await client.SendAsync(request))
    {
        response.EnsureSuccessStatusCode();
        var body = await response.Content.ReadAsStringAsync();
        Console.WriteLine(body);
    }
</code></pre>
```

### Table of Contents Conventions

The table of contents is completely driven by the `manifest.json` file contained within each Product folder. The specified manifest file MUST validate against [mainfest.schema.json](./schemas/manifest.schema.json).

A sample manifest is as follows:

```json
{
    "productMetadata": {
        "description": "This product gives the ability to programmatically embedded a Pet adoption workflow into your application 🐶",
        "slug": "pet-adoptions",
        "public": true,
        "hidden": false,
        "logo": "images/AdoptionsAPI.png",
        "logoDark": "",
        "autoPublish": true,
        "validateAPIs": true
    },
    "contentMetadata": [
        {
            "order": 0,
            "parent": "",
            "name": "Getting Started with Pet Adoptions",
            "slug": "getting-started-with-pet-adoptions",
            "type": "markdown",
            "contentUrl": "Getting-Started-With-Pet-Adoptions.md"
        },
        {
            "order": 1,
            "parent": "getting-started-with-pet-adoptions",
            "name": "Client Code (C#)",
            "slug": "client-code-csharp",
            "type": "markdown",
            "contentUrl": "Client-Code-Csharp.md"
        },
        {
            "order": 2,
            "parent": "getting-started-with-pet-adoptions",
            "name": "Client Code (Typescript)",
            "slug": "client-code-typescript",
            "type": "markdown",
            "contentUrl": "Client-Code-Typescript.md"
        },
        {
            "order": 5,
            "parent": "",
            "name": "Pets API",
            "type": "apiUrl",
            "slug": "pets-api",
            "contentUrl": "https://api.swaggerhub.com/apis/frank-kilcommins/Pets/1.0.0/swagger.json"
        },
        {
            "order": 6,
            "parent": "",
            "name": "Adoptions API",
            "type": "apiUrl",
            "slug": "adoptions-api",
            "contentUrl": "https://api.swaggerhub.com/apis/frank-kilcommins/Adoptions/1.0.0/swagger.json"
        }
    ]
}
```

The `productMetadata` defines the following properties:

| Property | Description |
|----------|-------------|
| description | This property provides a description of the product. It explains what the product does and its purpose. |
| slug | The slug is a unique identifier for the product. It is used in the URL and helps to identify the product in the portal. |
| public | This property determines whether the product is publicly accessible or not. If set to true, the product can be accessed by anyone. If set to false, only authorized users can access the product. |
| hidden | The hidden property determines whether the product is visible in the portal or not. If set to true, the product will be hidden from the portal. If set to false, the product will be visible. |
| logo | The logo property specifies the path to the product logo image file. It is used to display the logo in the portal. |
| logoDark | The logoDark property specifies the path to an alternative version of the product logo image file. It is used when a dark version of the logo is needed. |
| autoPublish | This property determines whether the product should be automatically published after deployment or not. If set to true, the product will be published automatically. If set to false, the product will not be published automatically. |
| validateAPIs | This property determines whether API standardization rules should be ran against the API to determine conformance with organizational rules. |


The `contentMetadata` defines the following properties:

| Property | Description |
|----------|-------------|
| order | The order in which the content should appear in the table of contents. |
| parent | The slug of the parent content, if the current item is to be nested under a parent item. |
| name | The name of the content page. |
| slug | The slug is a unique identifier for the content. It is used in the URL and helps to identify the content in the portal. |
| type | The type of the content. It can be either "markdown", "html", or "apiUrl". |
| contentUrl | The URL or file path of the content. For markdown/html content, it is the path to the markdown/html file. For API content, it is the URL of the Swagger/OpenAPI specification as published in SwaggerHub |

## GitHub Actions

This repo comes with a simple boilerplate action that can be triggered manually or upon merge into the `main` branch.

The action requires the following **repository secrets** to be configured:

- `SWAGGERHUB-API-KEY` - an API key associated to a user with the appropriate permission to be able to publish Portal content. See [Portal User Management](https://support.smartbear.com/swaggerhub-portal/docs/en/user-management.html) for more info.

The action requires the following **repository environment** to be configured:

- `Production` - the default environment. Feel free to configure additional environment and adjust the action as required if applicable for your use case.

The action requires the following **repository environment variables** to be configured:

- `SWAGGERHUB_PORTAL_SUBDOMAIN` - the sub-domain used by your portal
- `SWAGGERHUB_ORG_NAME` - the SwaggerHub organization housing the APIs and standardization rules

### Docs as Code PR Commit Validation Action

This action runs on every commit and every PR to validate the contents and structure of the content to be published to the portal

The action performs the following jobs:

1. `spell-check`: Performs spell checking on all of the markdown files under the _products_ folder (**note** to add a list of known good custom words update the ./custom-words.txt file)
2. `validate-manifests`: Performs a JSON Schema validation check against the defined product manifest.json files to ensure they are correctly specified.
3. `lint-api`: Performs API standardization checks against each API referenced by a product manifest.json file. There is the ability to skip API validation for a specific API product via the productMetadata in the manifest.json.

### Docs as Code Action

This action runs on upon merging into `main`. It performs all the checks as per above and assuming all validations pass, it then runs then publishes the content to the appropriate SwaggerHub Portal instance.

The action performs the following jobs:

1. `spell-check`: Performs spell checking on all of the markdown files under the _products_ folder (**note** to add a list of known good custom words update the ./custom-words.txt file)
2. `validate-manifests`: Performs a JSON Schema validation check against the defined product manifest.json files to ensure they are correctly specified.
3. `lint-api`: Performs API standardization checks against each API referenced by a product manifest.json file. There is the ability to skip API validation for a specific API product via the productMetadata in the manifest.json.
4. `publish`: Publishes all of configured products into the referenced SwaggerHub Portal instance.
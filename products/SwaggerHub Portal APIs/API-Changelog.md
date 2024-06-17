 This page contains a log of all changes to the API and the versions that are related to each new addition.



| Version |Release date  |Change notes  |
| --- | --- | --- |
| 0.1.0-beta |2023-08-18  | [view notes](https://frankkilcommins.portal.swaggerhub.com/portal/default/api-changelog#v0-1-0-beta) |


## v0.1.0-beta

Initial launch of the SwaggerHub Portal API.

> 🚧This version is classified as being in **beta** and is subject to _breaking changes_ over the coming period. That being said, we do encourage consumption and experimentation of the API.

The API provides the ability to access, manage, and update the following resources:
| Resource | Description |
| -------- | ----------- |
| Portals | A collection representing portal instances and allowing management on portal instances settings. The portal settings control the branding, name, domain url, and availability of a portal. These settings are split into three levels: `general`, `branding`, and `landingPage`. |
| Products | A collection of metadata (a.k.a. **product settings**), API reference documents (e.g., an OpenAPI document), and Markdown documents which are bundled and presented to a consumer as a product. |
| Documents | A resource for storing document content (specifically for Markdown files). |
| Sections | A section is a resource used to hold API references as well as API document references and organize them into tables of contents. |

Great to be live!

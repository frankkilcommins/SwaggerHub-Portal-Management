Welcome to the SwaggerHub Portal API! 👋

The SwaggerHub Portal is an API developer portal designed to provide a seamless and comprehensive experience for teams and companies to showcase their APIs. This guide will help you get started and understand the business value of the SwaggerHub Portal API. 🚀

**What's this API used for?**
This API allows you to manage your SwaggerHub Portal instance and automate many activities which can become very useful as more of your teams publish content into your developer portal.

> **Note:** The APIs enable direct configuration and content management of a SwaggerHub Portal instance.

Here's why the SwaggerHub Portal API is valuable:

* **Effortless API Productization:** The SwaggerHub Portal API enables you to effortlessly productize your APIs. You can create a centralized platform for developers and consumers to explore, understand, and consume your APIs. Showcase the value and capabilities of your APIs with rich documentation, tutorials, and guides.
* **Superior Developer Experience:** With the SwaggerHub Portal API, you can provide developers with a best-in-class Developer Experience (DX). They'll benefit from a user-friendly interface, interactive documentation, SDKs, and other tools that accelerate API adoption and empower them to build innovative

## Prerequisites

* A software as a service (SaaS) enterprise plan with SwaggerHub. If required, obtain a trial license from [https://try.smartbear.com/](https://try.smartbear.com/).
* A `designer` or `owner` role within the SwaggerHub organization.
* SwaggerHub Portal `MUST` be enabled for the SwaggerHub organization (from above).

## Management Resources & Capabilities

The SwaggerHub Portal API provides the management APIs for the following resources:

| Resource | Description | Permissions |
| -------- | ----------- | ----------- |
| Portals | A collection representing portal instances and allowing management on portal instances settings. The portal settings control the branding, name, domain url, and availability of a portal. These settings are split into three levels: `general`, `branding`, and `landingPage`. | Read, Modify, Delete |
| Documents | A resource for storing document content (specifically for Markdown files/attachments) | Read, Modify, Delete |
| Sections | A section is a resource used to hold API references as well as API document references and organize them into tables of contents. | Create, Modify, Delete |
| Products | A collection of metadata (a.k.a. *product settings*), API reference documents (e.g., an OpenAPI document), and Markdown documents which are bundled and presented to a consumer as a product. | Create, Modify, Delete |

## Base Info

**Base URL Endpoint:** The SwaggerHub Portal API base endpoint is `https://api.portal.swaggerhub.com/v1`.

## Authentication

See the [authentication](./authentication) guide.
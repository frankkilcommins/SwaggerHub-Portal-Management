 All management calls to the SwaggerHub Portal APIs require `ApiKey` authentication.

Include the API key in the `Authorization` HTTP header of each request with the value `Bearer {API_KEY}`, replacing `{API_Key}` with the actual value of your ApiKey from SwaggerHub.

API Keys `MUST` be retrieved from the SwaggerHub organization linked to the portal instance. See [here](https://support.smartbear.com/swaggerhub/docs/account/sbid-account-settings.html) for information on how to retrieve an API Key from SwaggerHub.

> **Note:** For administrative endpoints, the user associated with the API Key `MUST` have a `designer` or `owner` role within the organization, in order for an API request to be authorized.

> **Note:** Certain non-administrative endpoints support anonymous access when a portal product is `public`. For `private` products , the user associated with the API Key `MUST` have at least a `consumer` role within the organization, in order for an API request to be authorized. 
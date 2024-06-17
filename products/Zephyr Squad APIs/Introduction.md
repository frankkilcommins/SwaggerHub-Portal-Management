This is the **Zephyr Squad Cloud** API. If you are looking for the Server API, please refer to the [documentation](https://support.smartbear.com/zephyr-squad-server/docs/api/index.html) for more information.

This API uses the [OpenAPI Specification](https://swagger.io/specification/v3/). If you want to generate clients for different languages, please use the link above to download the API specification and use it with your preferred tools.

For feature requests or general support, please head to our [support site](https://support.smartbear.com/zephyr-squad-cloud).

## Representing Users

🚧 Previous API definitions used Atlassian User Keys to identify users. This method has deprecated because of privacy changes. Please use an **Atlassian account ID** instead.

Atlassian account IDs are globally unique opaque identifiers for identifying a user. Every Atlassian account has a identifier which is assigned when the account is created and is immutable. Account IDs contain no personally identifiable (PII) information and are only used to retrieve user information on demand. This API does not return any user information other than the account ID (with the exception of the deprecated user keys during the deprecation period).

[Smartbear - Zephyr Squad Support - Website](https://support.smartbear.com/zephyr-squad-cloud/docs/)

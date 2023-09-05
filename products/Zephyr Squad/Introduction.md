This is the **Zephyr Squad Cloud** API. If you are looking for the Server API, please refer to the documentation for more information.
This API uses the OpenAPI specification. If you want to generate clients for different languages, please use the link above to download the API specification and use it with your preferred tools.
For feature requests or general support, please head to our support site.

## Representing Users

Previous API definitions used Atlassian User Keys to identify users. This parameter is deprecated because of privacy changes. Use Atlassian Account ID instead.
Atlassian Account IDs are globally unique opaque identifiers for identifying a user. Every Atlassian Account has a ID which is assigned when the account is created and is immutable. Account IDs contain no personally identifiable information and are only used to retrieve user information on demand. This API does not return any user information other than the Account ID (with the exception of the deprecated user keys during the deprecation period).
[Smartbear - Zephyr Squad Support - Website](https://support.smartbear.com/zephyr-squad-cloud/docs/)
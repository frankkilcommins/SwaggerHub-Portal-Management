The API authentication is based on JSON Web Token (JWT), which is a key for accessing the API. Authenticating using JWT requires the following steps:

- Generate a key
- Make authenticated requests

## Generate a Key

For accessing the API, you must generate an access key in Jira. To generate an access token, click on your Atlassian profile picture at the page top right, and choose the option `Zephyr Squad API keys`. For more information, please check out the documentation.

## Making Authenticated Requests

To authenticate subsequent API requests, you must provide a valid token in an HTTP header, which is the key generated on the previous step:

```
Authorization: Bearer {bearer_token}
```

## Accessing the API

The API is available at the following base URL:

```
https://prod-api.zephyr4jiracloud.com/v2
```

For example, the final URL for retrieving test cases would be:

```
https://prod-api.zephyr4jiracloud.com/v2/testcases
```

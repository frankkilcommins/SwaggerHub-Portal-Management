# Getting Started

To get started with the SCIM Users Experience API, you will need to obtain an API key by registering your application. Once you have the API key, you can make requests to the API endpoints using the appropriate HTTP methods.

## API Endpoints

The SCIM Users Experience API provides the following endpoints:

- `/users`: This endpoint allows you to retrieve user details.

- `/users?filter={filter_expression}`: This endpoint allows you to filter users based on specific criteria.
- `/users?limit={number}`: This endpoint allows you to limit the number of users returned in the response.

## Error Handling

In case of any errors, the SCIM Users Experience API returns appropriate HTTP status codes along with error messages in the response body. Make sure to handle these errors gracefully in your application.

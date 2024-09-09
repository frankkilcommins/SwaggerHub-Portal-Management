# Getting Started

To get started with the CRM APIs, you will need to obtain an API key by registering your application. Once you have the API key, you can make requests to the API endpoints using the appropriate HTTP methods.

## API Endpoints

The CRM APIs provide the following endpoints:

- `/customers`: This endpoint allows you to retrieve customer details.

- `/customers?filter={filter_expression}`: This endpoint allows you to filter customers based on specific criteria.
- `/customers?limit={number}`: This endpoint allows you to limit the number of customers returned in the response.

## Error Handling

In case of any errors, the CRM APIs return appropriate HTTP status codes along with error messages in the response body. Make sure to handle these errors gracefully in your application.

![image](images/crm.png)

# History Of Changes

<table>
<colgroup>
<col style="width: 11%" />
<col style="width: 22%" />
<col style="width: 49%" />
<col style="width: 16%" />
</colgroup>
<thead>
<tr>
<th><strong>Version</strong></th>
<th><strong>Author</strong></th>
<th><strong>Reason for change</strong></th>
<th><strong>Date</strong></th>
</tr>
</thead>
<tbody>
<tr>
<td>1.0</td>
<td>J Sack</td>
<td>Initial</td>
<td>06/07/2024</td>
</tr>
<tr>
<td></td>
<td></td>
<td>Add the Get by id endpoint</td>
<td>06/11/2024</td>
</tr>
<tr>
<td></td>
<td></td>
<td>Add the Put by id endpoint</td>
<td>06/17/2024</td>
</tr>
<tr>
<td></td>
<td></td>
<td>Add the Patch by id endpoint</td>
<td>06/18/2024</td>
</tr>
<tr>
<td></td>
<td></td>
<td>Add the Post user endpoint</td>
<td>06/20/2024</td>
</tr>
<tr>
<td></td>
<td></td>
<td>Add the Get users endpoint</td>
<td>07/14/2024</td>
</tr>
<tr>
<td>1.1</td>
<td></td>
<td>Add the Service Configuration endpoint</td>
<td>07/16/2024</td>
</tr>
<tr>
<td></td>
<td></td>
<td>Updated SCIM User response definition</td>
<td>07/16/2024</td>
</tr>
<tr>
<td></td>
<td></td>
<td>Updated SCIM User request definition for Post &amp; Put</td>
<td>07/17/2024</td>
</tr>
<tr>
<td></td>
<td></td>
<td><p>Update endpoints to Users</p>
<p>change flsaRegionalCode to flsaCode</p>
<p>change status to employmentStatusCode</p></td>
<td>07/23/2024</td>
</tr>
<tr>
<td></td>
<td></td>
<td>Update incoming requests and responses based on where OKTA expects
the middleName element</td>
<td>08/29/2024</td>
</tr>
</tbody>
</table>

# Purpose 

This document provides specifics that describes the API application that
is to be built to support the interactions related to supporting McLane
users managed and the synchronization of that data via OKTA.

# Taxonomy

**OKTA**: An application that distributes updated employee data

**Workday**: McLane’s HCM system of record

**SCIM**: Standard protocol for provisioning and managing users identity
data 

# Solution Overview

People that work for McLane are are managed in the enterprise HCM
system. Many other enterprise systems require some portion of the data
related to those workers. The cloud application from OKTA will assist
McLane in disseminating employee related information in a consistent
manner. OKTA will essentially assist in the synchronizing of this data
for use in peripheral systems.

This API will support iterations with OKTA in support of employee data
synchronization.

## Process Context

![](media/image2.png)

## Logical Viewpoint

## Deployment Viewpoint

![](media/image3.png)

# Experience API

This experience API will expose endpoints to be used to facilitate the
dissemination of employee details to the McLane application landscape.

## Functional Design

### Resources

#### Employees

Employee data is consumed by many systems in the McLane application
landscape, and having accurate employee data is imperative for the
successful operation of those applications. Currently, employee data is
acquired in many different ways, and this api is to support a standard
way of disseminating employee data to support the accurate and timely
deliver of detailed employee data.

##### Project Names:

OAS Model Project: scim-users-exp-api

Development Project: scim-users-exp-api

OpenShift Project: employee-events-dev, employee-events-test,
employee-events

##### Policies

- Client Id Enforcement

***Experience API Http Listener Connector Configuration**: (externalize
into a property file)*

- CONNECT TIMEOUT (in MS): 30

##### Get Service Configuration

Get service configuration to identify what the API’s will support

###### Resource Locators

- To retrieve configuration details of the API:

GET {BASE_URI}/v1/serviceproviderconfigs

Type of Data Consumed:

application/json

###### Path Parameters: Does Not Apply

| Name | Assignment/Description | Example |
| ---- | ---------------------- | ------- |
|      |                        |         |

###### Query Parameters: Does Not Apply

| Name | Assignment/Description | Example |
| ---- | ---------------------- | ------- |
|      |                        |         |

###### Http Header Parameters: 

| Name             | Assignment/Description                                                                                                  | Example                              |
| ---------------- | ----------------------------------------------------------------------------------------------------------------------- | ------------------------------------ |
| tracing_id       | Optionally sent in on request                                                                                           | ASY7748901                           |
| X-Correlation-Id | If this element is present, assign it to correlationId variable, otherwise create a uuid and assign it to correlationId | 23d10540-e316-11ed-8a7a-0205dd115db9 |

###### Request Payload: Does Not Apply

| Element Name | Required | Notes |
| ------------ | :------: | ----- |
|              |          |       |

Example:

GET https://\<hostName\>/scim-users-exp-api/v1/serviceproviderconfigs

Example request:

Does Not Apply

###### Processing Summary

- Validation

- Generate a value for the correlationId

- Prepare Response

####### Validation

- Validate using the API model to insure the presence of required fields
  and valid values

####### Prepare Response 

The response can be created without any assistance from the system api.

######## Response Payload: 

\*\*See OAS model in the repository for more details

Response Payload description:

<table>
<colgroup>
<col style="width: 30%" />
<col style="width: 36%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr>
<th>Element Name</th>
<th>Assignment</th>
<th>Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td>authenticationSchemes</td>
<td>Empty array</td>
<td>Ex. []</td>
</tr>
<tr>
<td>bulk</td>
<td></td>
<td>object</td>
</tr>
<tr>
<td>supported</td>
<td>false</td>
<td>Ex. false</td>
</tr>
<tr>
<td>changePassword</td>
<td></td>
<td>object</td>
</tr>
<tr>
<td>supported</td>
<td>false</td>
<td>Ex. false</td>
</tr>
<tr>
<td>documentationUrl</td>
<td>https://support.okta.com/scim-fake-page.html</td>
<td>Ex. https://support.okta.com/scim-fake-page.html</td>
</tr>
<tr>
<td>etag</td>
<td></td>
<td>object</td>
</tr>
<tr>
<td>supported</td>
<td>false</td>
<td>Ex. false</td>
</tr>
<tr>
<td>filter</td>
<td></td>
<td>object</td>
</tr>
<tr>
<td>maxResults</td>
<td>100</td>
<td>Ex. 100</td>
</tr>
<tr>
<td>supported</td>
<td>true</td>
<td>Ex. true</td>
</tr>
<tr>
<td>patch</td>
<td></td>
<td>object</td>
</tr>
<tr>
<td>supported</td>
<td>false</td>
<td>Ex. false</td>
</tr>
<tr>
<td>schemas</td>
<td>"urn:scim:schemas:core:1.0",<br />
"urn:okta:schemas:scim:providerconfig:1.0"</td>
<td>Ex. "urn:scim:schemas:core:1.0",
"urn:okta:schemas:scim:providerconfig:1.0"</td>
</tr>
<tr>
<td>sort</td>
<td></td>
<td>object</td>
</tr>
<tr>
<td>supported</td>
<td>false</td>
<td>Ex. false</td>
</tr>
<tr>
<td>urn:okta:schemas:scim:providerconfig:1.0</td>
<td></td>
<td>object</td>
</tr>
<tr>
<td>userManagementCapabilities</td>
<td>"PUSH_NEW_USERS",<br />
"PUSH_PROFILE_UPDATES",<br />
"PUSH_USER_DEACTIVATION",<br />
"REACTIVATE_USERS"</td>
<td>Ex. "PUSH_NEW_USERS",<br />
"PUSH_PROFILE_UPDATES",<br />
"PUSH_USER_DEACTIVATION",<br />
"REACTIVATE_USERS"</td>
</tr>
</tbody>
</table>

Example:

```json
{  
  "authenticationSchemes": [],  
  "bulk": {  
    "supported": false  
  },  
  "changePassword": {  
    "supported": false  
  },  
  "documentationUrl": "https://support.okta.com/scim-fake-page.html",  
  "etag": {  
    "supported": false  
  },  
  "filter": {  
    "maxResults": 100,  
    "supported": true  
  },  
  "patch": {  
    "supported": false  
  },  
  "schemas": [  
    "urn:scim:schemas:core:1.0",  
    "urn:okta:schemas:scim:providerconfig:1.0"  
  ],  
  "sort": {  
    "supported": false  
  },  
  "urn:okta:schemas:scim:providerconfig:1.0": {  
    "userManagementCapabilities": [  
      "PUSH_NEW_USERS",  
      "PUSH_PROFILE_UPDATES",  
      "PUSH_USER_DEACTIVATION",  
      "REACTIVATE_USERS"  
    ]  
  }  
}
```

HTTP Status Codes

Possible HTTP status codes for the response include:

- 200 OK - for success

- 400 Bad Request – for errors in the request data

- 401 Unauthorized - for errors in API authentication

- 403 Forbidden - for errors in API authorization

- 404 Resource Not found - for errors in API resource not found

- 500 Internal Server Error - for any unexpected resource failures

####### Logging Events:

\- At the start of the application

flowStep: "Flow Start"

-At the End of the application

>  flowStep: "Flow End"

###### Error Processing

Error mapping from our standard error structure to the SCIM error
structure

| Element Name | Assignment                                         | Notes                                       |
| ------------ | -------------------------------------------------- | ------------------------------------------- |
| schemas      | Assign urn:ietf:params:scim:api:messages:2.0:Error | urn:ietf:params:scim:api:messages:2.0:Error |
| detail       | context.message from the common error response     | No user found                               |
| status       | status from the common error response              | 400                                         |

If an issue/error is encountered, the specifics related to the error are
to be reported back on the response via our SCIM error structure along
with the correlation Id and the tracing Id if provided.

###### Non Functional Requirements

####### Security

####### Data

- System client id and secret

- Masking elements: Does Not apply

####### Transport

- https

####### Availability

- *99.99% uptime 24x7*

####### Reliability

- High availability via multiple workers

####### Traceability

- Transaction tracing via log data to Splunk

- Specific Auditing requirements: Does Not Apply

####### Throughput

- Current Peak Metric:

  - <span class="mark">xx</span> Concurrent transactions per second

  - <span class="mark">xx</span> Minutes - specified duration(s)

  - M T W T F S S Note any applicable days in the week

- Seasonal dimension: Does Not Apply

- Estimated Peak metric over the next 9-12 months:

  - <span class="mark">xx</span> Concurrent transactions per second

  - <span class="mark">xx</span> minutes - specified duration(s)

  - M T W T F S S Note any applicable days in the week

####### Response Time

- Target times for average or maximum response times, expressed as a
  percentile: 95% within 2 second(s).

##### Get user data via a user Id

Get user information using an employee Id

###### Resource Locators

- To retrieve details on an user:

GET {BASE_URI}/v1/users/{userId}

Type of Data Consumed:

application/json

###### Path Parameters: 

| Name   | Assignment/Description     | Example   |
| ------ | -------------------------- | --------- |
| userId | Unique employee identifier | 000061149 |

###### Query Parameters: Does Not Apply

| Name | Assignment/Description | Example |
| ---- | ---------------------- | ------- |
|      |                        |         |

###### Http Header Parameters: 

| Name             | Assignment/Description                                                                                                  | Example                              |
| ---------------- | ----------------------------------------------------------------------------------------------------------------------- | ------------------------------------ |
| tracing_id       | Optionally sent in on request                                                                                           | ASY7748901                           |
| X-Correlation-Id | If this element is present, assign it to correlationId variable, otherwise create a uuid and assign it to correlationId | 23d10540-e316-11ed-8a7a-0205dd115db9 |

###### Request Payload: Does Not Apply

| Element Name | Required | Notes |
| ------------ | :------: | ----- |
|              |          |       |

Example:

GET https://\<hostName\>/scim-users-exp-api/v1/users/000061149

Example request:

Does Not Apply

###### Processing Summary

- Validation

- Generate a value for the correlationId

- Call the Employee ODS system API

- Prepare Response

####### Validation

- Validate using the API model to insure the presence of required fields
  and valid values

####### Call System API to Get employee data for an employee identifier

See model project for interaction details: employee-ods-sys-api

######## Path Parameters: 

| Name       | Assignment/Description     | Example   |
| ---------- | -------------------------- | --------- |
| employeeId | Unique employee identifier | 000061149 |

######## Query Parameters: Does Not Apply

| Name | Assignment/Description | Example |
| ---- | ---------------------- | ------- |
|      |                        |         |

######## Http Header Parameters: 

| Name             | Assignment/Description                               | Example                              |
| ---------------- | ---------------------------------------------------- | ------------------------------------ |
| tracing_id       | Optionally sent in on request                        | ASY7748901                           |
| X-Correlation-Id | Assign the correlationId value generated by this api | 979f3d3b-a04a-43d7-b55f-8d5609b48783 |

######## Request Payload: Does Not Apply

| Element Name | Required | Notes |
| ------------ | :------: | ----- |
|              |          |       |

Example:

GET
https://\<server\>:\<port\>/employee-ods-sys-api/v1/employees/000061149

Example request:

Does Not Apply

***Request Connector Configuration**: (externalize into a property
file)*

- *Response Timeout(ms): 30000 (responseTimeOut)*

####### Prepare Response 

System API Response Payload definition: [\#Employee User Detail Response
Structure\|outline](#employee-ods-system-api-user-detail-response-structure)

######## Response Payload: 

\*\*See OAS model in the repository for more details

Response Payload description: [\#SCIM Employee User Detail Mapping
Structure\|outline](#scim-user-response-detail-mapping-structure)

| Element Name | Assignment | Notes |
| ------------ | ---------- | ----- |
|              |            |       |

HTTP Status Codes

Possible HTTP status codes for the response include:

- 200 OK - for success

- 400 Bad Request – for errors in the request data

- 401 Unauthorized - for errors in API authentication

- 403 Forbidden - for errors in API authorization

- 404 Resource Not found - for errors in API resource not found

- 500 Internal Server Error - for any unexpected resource failures

- 

####### Logging Events:

\- At the start of the application

flowStep: "Flow Start"

\- Right before the Get Employee call:

flowStep: "Get Employee Request"

\- Right after the return of the Get Employee call:

flowStep: "Get Employee Response"

-At the End of the application

>  flowStep: "Flow End"

###### Error Processing

Error mapping from our standard error structure to the SCIM error
structure

| Element Name | Assignment                                         | Notes                                       |
| ------------ | -------------------------------------------------- | ------------------------------------------- |
| schemas      | Assign urn:ietf:params:scim:api:messages:2.0:Error | urn:ietf:params:scim:api:messages:2.0:Error |
| detail       | context.message from the common error response     | No user found                               |
| status       | status from the common error response              | 400                                         |

If an issue/error is encountered, the specifics related to the error are
to be reported back on the response via our SCIM error structure along
with the correlation Id and the tracing Id if provided.

###### Non Functional Requirements

####### Security

####### Data

- System client id and secret

- Masking elements: Does Not apply

####### Transport

- https

####### Availability

- *99.99% uptime 24x7*

####### Reliability

- High availability via multiple workers

####### Traceability

- Transaction tracing via log data to Splunk

- Specific Auditing requirements: Does Not Apply

####### Throughput

- Current Peak Metric:

  - <span class="mark">xx</span> Concurrent transactions per second

  - <span class="mark">xx</span> Minutes - specified duration(s)

  - M T W T F S S Note any applicable days in the week

- Seasonal dimension: Does Not Apply

- Estimated Peak metric over the next 9-12 months:

  - <span class="mark">xx</span> Concurrent transactions per second

  - <span class="mark">xx</span> minutes - specified duration(s)

  - M T W T F S S Note any applicable days in the week

####### Response Time

- Target times for average or maximum response times, expressed as a
  percentile: 95% within 2 second(s).

##### Update employee data via an employee Id

Update employee information using an employee Id

###### Resource Locators

- To update details on an employee:

PUT {BASE_URI}/v1/Users/{userId}

Type of Data Consumed:

application/json

###### Path Parameters: 

| Name   | Assignment/Description     | Example   |
| ------ | -------------------------- | --------- |
| userId | Unique employee identifier | 000061149 |

###### Query Parameters: Does Not Apply

| Name | Assignment/Description | Example |
| ---- | ---------------------- | ------- |
|      |                        |         |

###### Http Header Parameters: 

| Name             | Assignment/Description                                                                                                  | Example                              |
| ---------------- | ----------------------------------------------------------------------------------------------------------------------- | ------------------------------------ |
| tracing_id       | Optionally sent in on request                                                                                           | ASY7748901                           |
| X-Correlation-Id | If this element is present, assign it to correlationId variable, otherwise create a uuid and assign it to correlationId | 23d10540-e316-11ed-8a7a-0205dd115db9 |

###### Request Payload: See the model repo for details

<table>
<colgroup>
<col style="width: 36%" />
<col style="width: 21%" />
<col style="width: 41%" />
</colgroup>
<thead>
<tr>
<th>Element Name</th>
<th style="text-align: center;">Required</th>
<th>Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td>schemas</td>
<td style="text-align: center;">Y</td>
<td><p>urn:ietf:params:scim:schemas:core:2.0:User,</p>
<p>urn:ietf:params:scim:schemas:extension:CustomExtensionName:2.0:User</p></td>
</tr>
<tr>
<td></td>
<td style="text-align: center;"></td>
<td></td>
</tr>
<tr>
<td>userName</td>
<td style="text-align: center;">Y</td>
<td><p>string</p>
<p>Ex. 000061149</p></td>
</tr>
<tr>
<td>active</td>
<td style="text-align: center;">Y</td>
<td><p>boolean</p>
<p>Ex. true</p></td>
</tr>
<tr>
<td>name</td>
<td style="text-align: center;">Y</td>
<td>object</td>
</tr>
<tr>
<td>givenName</td>
<td style="text-align: center;">Y</td>
<td><p>string</p>
<p>Ex. Mary</p></td>
</tr>
<tr>
<td><del>middleName</del></td>
<td style="text-align: center;"><del>N</del></td>
<td><p><del>string</del></p>
<p><del>Ex. Sue</del></p></td>
</tr>
<tr>
<td>familyName</td>
<td style="text-align: center;">Y</td>
<td><p>string</p>
<p>Ex. Eliassen</p></td>
</tr>
<tr>
<td>password</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. xq69ivVT</p></td>
</tr>
<tr>
<td>urn:okta:mclaneco-dev_scimusersexp_2:1.0:user:custom</td>
<td style="text-align: center;"></td>
<td>Object</td>
</tr>
<tr>
<td>userId</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. psmith</p></td>
</tr>
<tr>
<td>middleName</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. Sue</p></td>
</tr>
<tr>
<td>title</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. Administrator, Lead Middleware</p></td>
</tr>
<tr>
<td>streetAddress</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. 4747 McLane Parkway</p></td>
</tr>
<tr>
<td>city</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. Temple</p></td>
</tr>
<tr>
<td>state</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. TX</p></td>
</tr>
<tr>
<td>zipCode</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. 76504</p></td>
</tr>
<tr>
<td>department</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. Platform Administration</p></td>
</tr>
<tr>
<td>departmentId</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. 20000</p></td>
</tr>
<tr>
<td>managerId</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. 000061149</p></td>
</tr>
<tr>
<td>birthDate</td>
<td style="text-align: center;">N</td>
<td><p>date</p>
<p>Ex. 14-Sep-1959</p></td>
</tr>
<tr>
<td>managerId</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. 000061149</p></td>
</tr>
<tr>
<td>birthDate</td>
<td style="text-align: center;">N</td>
<td><p>date</p>
<p>Ex. 01-Sep-2000</p></td>
</tr>
<tr>
<td>ssnLastFour</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex.1149</p></td>
</tr>
<tr>
<td>jobCode</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. 1067</p></td>
</tr>
<tr>
<td>divisionCode</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. GR260</p></td>
</tr>
<tr>
<td>division</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. McLane Business Info Services</p></td>
</tr>
<tr>
<td>companyCode</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. 001</p></td>
</tr>
<tr>
<td>companyName</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. McLane Company, Inc.</p></td>
</tr>
<tr>
<td>payGrade</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. L</p></td>
</tr>
<tr>
<td>employmentStatusCode</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. A</p></td>
</tr>
<tr>
<td>compensationTypeCode</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. S</p></td>
</tr>
<tr>
<td>businessUnit</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. IS790</p></td>
</tr>
<tr>
<td>terminationDate</td>
<td style="text-align: center;">N</td>
<td><p>date</p>
<p>EX. 31-Sep-2024</p></td>
</tr>
<tr>
<td>extendedLeaveEffectiveDate</td>
<td style="text-align: center;">N</td>
<td><p>date</p>
<p>EX. 14-Sep-2024</p></td>
</tr>
<tr>
<td>flsaCode</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. V</p></td>
</tr>
<tr>
<td>locationId</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. L</p></td>
</tr>
<tr>
<td>startDate</td>
<td style="text-align: center;">N</td>
<td><p>date</p>
<p>EX. 14-Sep-2000</p></td>
</tr>
<tr>
<td>jobFamilyCode</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. L</p></td>
</tr>
<tr>
<td>jobFamilyName</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. T Platform</p></td>
</tr>
<tr>
<td>positionCode</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. P001537</p></td>
</tr>
</tbody>
</table>

Example:

PUT https://\<hostName\>/scim-users-exp-api/v1/Users/000061149

Example Request:

```json
{
  "schemas": [
    "urn:scim:schemas:core:1.0",
    "urn:scim:schemas:extension:enterprise:1.0",
    "urn:okta:mclaneco-dev_scimusersexp_2:1.0:user:custom"
  ],
  "userName": "oTEST0004578",
  "name": {
    "givenName": "TestFirst4578",
    "familyName": "TestLast4578"
  },
  "password": "xq69ivVT",
  "active": true,
  "urn:okta:mclaneco-dev_scimusersexp_2:1.0:user:custom": {
    "userId": "psmith",
    "middleName": "Test",
    "title": "Administrator, Lead Middleware",
    "streetAddress": "4747 McLane Parkway",
    "city": "Temple",
    "state": "TX",
    "zipCode": "7504",
    "department": "Platform Administration",
    "departmentId": "50200",
    "managerId": "000058215",
    "birthDate": "14-Sep-1959",
    "ssnLastFour": "1234",
    "jobCode": "1067",
    "divisionCode": "IS790",
    "division": "McLane Business Info Services",
    "companyCode": "001",
    "companyName": "McLane Company, Inc.",
    "payGrade": "L",
    "employmentStatusCode": "A",
    "compensationTypeCode": "S",
    "businessUnit": "IS790",
    "terminationDate": "01-Sep-2024",
    "extendedLeaveEffectiveDate": "30-Sep-2024",
    "flsaCode": "N",
    "locationId": "999",
    "startDate": "01-Sep-2022",
    "jobFamilyCode": "D",
    "jobFamilyName": "IT Platform",
    "positionCode": "P001537"
  }
}
```

###### Processing Summary

- Validation

- Interact with Employee ODS system api

- Prepare Response

###### Processing

####### Validation

- Validate using the API model to insure the presence of required fields
  and valid values

####### Call the Employees ODS system API

See model project for interaction details: employee-ods-sys-api

######## Path Parameters: 

| Name       | Assignment/Description     | Example   |
| ---------- | -------------------------- | --------- |
| employeeId | Unique employee identifier | 000061149 |

######## Query Parameters: Does Not Apply

| Name | Assignment/Description | Example |
| ---- | ---------------------- | ------- |
|      |                        |         |

######## Http Header Parameters: 

| Name             | Assignment/Description                               | Example                              |
| ---------------- | ---------------------------------------------------- | ------------------------------------ |
| tracing_id       | Optionally sent in on request                        | ASY7748901                           |
| X-Correlation-Id | Assign the correlationId value generated by this api | 979f3d3b-a04a-43d7-b55f-8d5609b48783 |

######## Request Payload: see OAS model repo employee-ods-sys-api

| Element Name | Required | Notes |
| ------------ | :------: | ----- |
|              |          |       |

Example:

PUT
https://\<server\>:\<port\>/employee-ods-sys-api/v1/employees/000061149

Example request:

```json
{
  "employee": {
    "employeeId": "000136214",
    "userId": "zernest",
    "isActive": true,
    "employmentStatusCode": "A",
    "birthDate": "15-Oct-1963",
    "ssnLastFour": "1123",
    "distributionCenterDivisionId": "GR260",
    "division": "GR260 GR Concord",
    "costCenter": "20020",
    "managerId": "000028632",
    "locationId": "999",
    "companyCode": "001",
    "companyName": "McLane Company, Inc.",
    "department": "Platform Administration",
    "departmentId": "50200",
    "terminationDate": null,
    "payGrade": "L",
    "flsaCode": "N",
    "compensationTypeCode": "S",
    "businessUnit": "GR260",
    "startDate": "11-Aug-2022",
    "extendedTimeOff": {
      "startDate": ""
    },
    "name": {
      "first": "Zachary",
      "middle": "Ernest",
      "last": "Hines"
    },
    "job": {
      "code": "1067",
      "title": "Stocker",
      "familyCode": "D3",
      "family": "IT Platform3",
      "positionId": "P001533"
    },
    "workAddress": {
      "address1": "4747 McLane Parkway",
      "city": "Temple",
      "state": "TX",
      "postalCode": "76504"
    }
  }
}
```

***Request Connector Configuration**: (externalize into a property
file)*

- *Response Timeout(ms): 50000 (responseTimeOut)*

####### Prepare Response 

The Response requires the endpoint to return an image of the employee
after the update was made

###### Response Payload: [\#Employee Detail Response Structure\|outline](#employee-ods-system-api-user-detail-response-structure)

###### Logging Events:

\- At the start of the application

flowStep: "Flow Start"

\- Right before the Updating an Employee call

flowStep: " Update an Employee Request"

\- Right after the return of Updating an Employee call:

flowStep: " Update an Employee Response"

-At the End of the application

flowStep: "Flow End"

###### Error Processing

Error mapping from our standard error structure to the SCIM error
structure

| Element Name | Assignment                                         | Notes                                       |
| ------------ | -------------------------------------------------- | ------------------------------------------- |
| schemas      | Assign urn:ietf:params:scim:api:messages:2.0:Error | urn:ietf:params:scim:api:messages:2.0:Error |
| detail       | context.message from the common error response     | No user found                               |
| status       | status from the common error response              | 400                                         |

If the results set is empty (employee not found) then create an error
response and sent back to the caller.

-Set the following status elements in the response

status = 404

schemas = "urn:ietf:params:scim:api:messages:2.0:Error"

> detail = User not found for employee Id = {userId}
>
> Note: userId from the path parameter

Example:

```json
{
  "schemas": [
    "urn:ietf:params:scim:api:messages:2.0:Error"
  ],
  "detail": "User not found for employee Id = 000022340",
  "status": 404
}
```

If an issue/error are encountered, the specifics related to the error
are to be reported back on the response via our SCIM error structure
along with the correlation Id and the tracing Id if provided. See
[\#SCIM Error Structure\|outline](#scim-error-structure)

Example:

```json
{
  "correlationId": "979f3d3b-a04a-43d7-b55f-8d5609b48783",
  "tracingId": "abc55247",
  "schemas": ["urn:ietf:params:scim:api:messages:2.0:Error"],
  "detail": "User not found for employee Id = 000022340",
  "status": 404
}
```

###### HTTP Status Codes

Possible HTTP status codes for the response include:

- 200 OK - for success

- 400 Bad Request – for errors in the request data

- 401 Unauthorized - for errors in API authentication

- 403 Forbidden - for errors in API authorization

- 404 Resource Not found - for errors in API resource not found

- 500 Internal Server Error - for any unexpected resource failures

###### Non Functional Requirements

####### Security

####### Data

- System client id and secret

- Masking elements: Does Not apply

####### Transport

- http

####### Availability

- *99.99% uptime 24x7*

####### Reliability

- High availability via multiple workers

####### Traceability

- Transaction tracing via log data to Splunk

- Specific Auditing requirements: Does Not Apply

####### Throughput

- Current Peak Metric:

  - <span class="mark">xx</span> Concurrent transactions per second

  - <span class="mark">xx</span> Minutes - specified duration(s)

  - M T W T F S S Note any applicable days in the week

- Seasonal dimension: Does Not Apply

- Estimated Peak metric over the next 9-12 months:

  - <span class="mark">xx</span> Concurrent transactions per second

  - <span class="mark">xx</span> minutes - specified duration(s)

  - M T W T F S S Note any applicable days in the week

####### Response Time

- Target times for average or maximum response times, expressed as a
  percentile: 95% within 3 second(s).

##### Patch employee data via an employee Id

Update employee status

###### Resource Locators

- To update the status of an employee:

PATCH {BASE_URI}/v1/users/{userId}

Type of Data Consumed:

application/json

###### Path Parameters: 

| Name   | Assignment/Description     | Example   |
| ------ | -------------------------- | --------- |
| userId | Unique employee identifier | 000061149 |

###### Query Parameters: Does Not Apply

| Name | Assignment/Description | Example |
| ---- | ---------------------- | ------- |
|      |                        |         |

###### Http Header Parameters: 

| Name             | Assignment/Description                                                                                                  | Example                              |
| ---------------- | ----------------------------------------------------------------------------------------------------------------------- | ------------------------------------ |
| tracing_id       | Optionally sent in on request                                                                                           | ASY7748901                           |
| X-Correlation-Id | If this element is present, assign it to correlationId variable, otherwise create a uuid and assign it to correlationId | 23d10540-e316-11ed-8a7a-0205dd115db9 |

###### Request Payload: See the model repo for details

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 26%" />
<col style="width: 52%" />
</colgroup>
<thead>
<tr>
<th>Element Name</th>
<th style="text-align: center;">Required</th>
<th>Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td>schemas</td>
<td style="text-align: center;">Y</td>
<td><p>string</p>
<p>Ex. urn:ietf:params:scim:api:messages:2.0:PatchOp</p></td>
</tr>
<tr>
<td>Operations</td>
<td style="text-align: center;">Y</td>
<td></td>
</tr>
<tr>
<td>op</td>
<td style="text-align: center;">Y</td>
<td><p>string</p>
<p>Ex. replace</p></td>
</tr>
<tr>
<td>value</td>
<td style="text-align: center;">Y</td>
<td><p>string</p>
<p>Ex.</p></td>
</tr>
<tr>
<td>active</td>
<td style="text-align: center;">Y</td>
<td><p>boolean</p>
<p>Ex. false</p></td>
</tr>
</tbody>
</table>

Example:

PATCH https://\<hostName\>/scim-users-exp-api/v1/users/000061149

Example Request:

```json
{
  "schemas": ["urn:ietf:params:scim:api:messages:2.0:PatchOp"],
  "Operations": [
    {
      "op": "replace",
      "value": {
        "active": false
      }
    }
  ]
}
```

###### Processing Summary

- Validation

- Interact with Employee ODS system api

- Prepare Response

###### Processing

####### Validation

- Validate using the API model to insure the presence of required fields
  and valid values

####### Call the Employees ODS system API

See model project for interaction details: employee-ods-sys-api

######## Path Parameters: 

| Name       | Assignment/Description     | Example   |
| ---------- | -------------------------- | --------- |
| employeeId | Unique employee identifier | 000061149 |

######## Query Parameters: Does Not Apply

| Name | Assignment/Description | Example |
| ---- | ---------------------- | ------- |
|      |                        |         |

######## Http Header Parameters: 

| Name             | Assignment/Description                               | Example                              |
| ---------------- | ---------------------------------------------------- | ------------------------------------ |
| tracing_id       | Optionally sent in on request                        | ASY7748901                           |
| X-Correlation-Id | Assign the correlationId value generated by this api | 979f3d3b-a04a-43d7-b55f-8d5609b48783 |

######## Request Payload: see OAS model repo employee-ods-sys-api

<table>
<colgroup>
<col style="width: 35%" />
<col style="width: 11%" />
<col style="width: 53%" />
</colgroup>
<thead>
<tr>
<th>Element Name</th>
<th style="text-align: center;">Required</th>
<th>Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td>employee</td>
<td style="text-align: center;">Y</td>
<td></td>
</tr>
<tr>
<td>status</td>
<td style="text-align: center;">Y</td>
<td><p>string</p>
<p>Ex. Terminated</p>
<p>If active=false then Terminated else Active</p></td>
</tr>
</tbody>
</table>

Example:

PATCH
https://\<server\>:\<port\>/employee-ods-sys-api/v1/employees/000061149

Example request:

```json
{  
  "employee": {  
    "status": "Terminated"  
  }  
}
```

***Request Connector Configuration**: (externalize into a property
file)*

- *Response Timeout(ms): 30000 (responseTimeOut)*

####### Prepare Response 

The Response requires the endpoint to return an image of the employee
after the update was made

###### Response Payload: [\#Employee Detail Response Structure\|outline](#employee-ods-system-api-user-detail-response-structure)

###### Logging Events:

\- At the start of the application

flowStep: "Flow Start"

\- Right before the Patching an Employee call

flowStep: " Patching an Employee Request"

\- Right after the return of Patching an Employee call:

flowStep: " Patching an Employee Response"

-At the End of the application

flowStep: "Flow End"

###### Error Processing

Error mapping from our standard error structure to the SCIM error
structure

| Element Name | Assignment                                         | Notes                                       |
| ------------ | -------------------------------------------------- | ------------------------------------------- |
| schemas      | Assign urn:ietf:params:scim:api:messages:2.0:Error | urn:ietf:params:scim:api:messages:2.0:Error |
| detail       | context.message from the common error response     | No user found                               |
| status       | status from the common error response              | 400                                         |

If the results set is empty (employee not found) then create an error
response and sent back to the caller.

-Set the following status elements in the response

status = 404

schemas = "urn:ietf:params:scim:api:messages:2.0:Error"

> detail = User not found for employee Id = {userId}
>
> Note: userId assign from the userId path parameter

Example:

```json
{
  "schemas": [
    "urn:ietf:params:scim:api:messages:2.0:Error"
  ],
  "detail": "User not found for employee Id = 000022340",
  "status": 404
}
```

If an issue/error are encountered, the specifics related to the error
are to be reported back on the response via the SCIM error structure
along with the correlation Id and the tracing Id if provided. See
[\#SCIM Error Structure\|outline](#scim-error-structure)

Example:

```json
{
  "correlationId": "979f3d3b-a04a-43d7-b55f-8d5609b48783",
  "tracingId": "abc55247",
  "schemas": ["urn:ietf:params:scim:api:messages:2.0:Error"],
  "detail": "User not found for employee Id = 000022340",
  "status": 404
}
```

###### HTTP Status Codes

Possible HTTP status codes for the response include:

- 200 OK - for success

- 400 Bad Request – for errors in the request data

- 401 Unauthorized - for errors in API authentication

- 403 Forbidden - for errors in API authorization

- 404 Resource Not found - for errors in API resource not found

- 500 Internal Server Error - for any unexpected resource failures

###### Non Functional Requirements

####### Security

####### Data

- System client id and secret

- Masking elements: Does Not apply

####### Transport

- http

####### Availability

- *99.99% uptime 24x7*

####### Reliability

- High availability via multiple workers

####### Traceability

- Transaction tracing via log data to Splunk

- Specific Auditing requirements: Does Not Apply

####### Throughput

- Current Peak Metric:

  - <span class="mark">xx</span> Concurrent transactions per second

  - <span class="mark">xx</span> Minutes - specified duration(s)

  - M T W T F S S Note any applicable days in the week

- Seasonal dimension: Does Not Apply

- Estimated Peak metric over the next 9-12 months:

  - <span class="mark">xx</span> Concurrent transactions per second

  - <span class="mark">xx</span> minutes - specified duration(s)

  - M T W T F S S Note any applicable days in the week

####### Response Time

- Target times for average or maximum response times, expressed as a
  percentile: 95% within 3 second(s).

##### Add an employee

Add an employee

###### Resource Locators

- To add details for a new user:

POST {BASE_URI}/v1/Users

Type of Data Consumed:

application/json

###### Path Parameters: Does Not Apply

| Name | Assignment/Description | Example |
| ---- | ---------------------- | ------- |
|      |                        |         |

###### Query Parameters: Does Not Apply

| Name | Assignment/Description | Example |
| ---- | ---------------------- | ------- |
|      |                        |         |

###### Http Header Parameters: 

| Name             | Assignment/Description                                                                                                  | Example                              |
| ---------------- | ----------------------------------------------------------------------------------------------------------------------- | ------------------------------------ |
| tracing_id       | Optionally sent in on request                                                                                           | ASY7748901                           |
| X-Correlation-Id | If this element is present, assign it to correlationId variable, otherwise create a uuid and assign it to correlationId | 23d10540-e316-11ed-8a7a-0205dd115db9 |

###### Request Payload: See the model repo for details

<table>
<colgroup>
<col style="width: 36%" />
<col style="width: 21%" />
<col style="width: 41%" />
</colgroup>
<thead>
<tr>
<th>Element Name</th>
<th style="text-align: center;">Required</th>
<th>Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td>schemas</td>
<td style="text-align: center;">Y</td>
<td><p>urn:ietf:params:scim:schemas:core:2.0:User,</p>
<p>urn:ietf:params:scim:schemas:extension:CustomExtensionName:2.0:User</p></td>
</tr>
<tr>
<td></td>
<td style="text-align: center;"></td>
<td></td>
</tr>
<tr>
<td>userName</td>
<td style="text-align: center;">Y</td>
<td><p>string</p>
<p>Ex. 000061149</p></td>
</tr>
<tr>
<td>active</td>
<td style="text-align: center;">Y</td>
<td><p>boolean</p>
<p>Ex. true</p></td>
</tr>
<tr>
<td>name</td>
<td style="text-align: center;">Y</td>
<td>object</td>
</tr>
<tr>
<td>givenName</td>
<td style="text-align: center;">Y</td>
<td><p>string</p>
<p>Ex. Mary</p></td>
</tr>
<tr>
<td><del>middleName</del></td>
<td style="text-align: center;"><del>N</del></td>
<td><p><del>string</del></p>
<p><del>Ex. Sue</del></p></td>
</tr>
<tr>
<td>familyName</td>
<td style="text-align: center;">Y</td>
<td><p>string</p>
<p>Ex. Eliassen</p></td>
</tr>
<tr>
<td>password</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. xq69ivVT</p></td>
</tr>
<tr>
<td>urn:okta:mclaneco-dev_scimusersexp_2:1.0:user:custom</td>
<td style="text-align: center;"></td>
<td>Object</td>
</tr>
<tr>
<td>userId</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. psmith</p></td>
</tr>
<tr>
<td>middleName</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. Sue</p></td>
</tr>
<tr>
<td>title</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. Administrator, Lead Middleware</p></td>
</tr>
<tr>
<td>streetAddress</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. 4747 McLane Parkway</p></td>
</tr>
<tr>
<td>city</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. Temple</p></td>
</tr>
<tr>
<td>state</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. TX</p></td>
</tr>
<tr>
<td>zipCode</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. 76504</p></td>
</tr>
<tr>
<td>department</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. Platform Administration</p></td>
</tr>
<tr>
<td>departmentId</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. 20000</p></td>
</tr>
<tr>
<td>managerId</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. 000061149</p></td>
</tr>
<tr>
<td>birthDate</td>
<td style="text-align: center;">N</td>
<td><p>date</p>
<p>Ex. 14-Sep-1959</p></td>
</tr>
<tr>
<td>title</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. Administrator, Lead Middleware</p></td>
</tr>
<tr>
<td>streetAddress</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. 4747 McLane Parkway</p></td>
</tr>
<tr>
<td>city</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. Temple</p></td>
</tr>
<tr>
<td>state</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. TX</p></td>
</tr>
<tr>
<td>zipCode</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. 76504</p></td>
</tr>
<tr>
<td>department</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. Platform Administration</p></td>
</tr>
<tr>
<td>departmentId</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. 20000</p></td>
</tr>
<tr>
<td>managerId</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. 000061149</p></td>
</tr>
<tr>
<td>birthDate</td>
<td style="text-align: center;">N</td>
<td><p>date</p>
<p>Ex. 01-Sep-2000</p></td>
</tr>
<tr>
<td>ssnLastFour</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex.1149</p></td>
</tr>
<tr>
<td>jobCode</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. 1067</p></td>
</tr>
<tr>
<td>divisionCode</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. GR260</p></td>
</tr>
<tr>
<td>division</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. McLane Business Info Services</p></td>
</tr>
<tr>
<td>companyCode</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. 001</p></td>
</tr>
<tr>
<td>companyName</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. McLane Company, Inc.</p></td>
</tr>
<tr>
<td>payGrade</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. L</p></td>
</tr>
<tr>
<td>employmentStatusCode</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. A</p></td>
</tr>
<tr>
<td>compensationTypeCode</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. S</p></td>
</tr>
<tr>
<td>businessUnit</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. IS790</p></td>
</tr>
<tr>
<td>terminationDate</td>
<td style="text-align: center;">N</td>
<td><p>date</p>
<p>EX. 31-Sep-2024</p></td>
</tr>
<tr>
<td>extendedLeaveEffectiveDate</td>
<td style="text-align: center;">N</td>
<td><p>date</p>
<p>EX. 14-Sep-2024</p></td>
</tr>
<tr>
<td>flsaCode</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. V</p></td>
</tr>
<tr>
<td>locationId</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. L</p></td>
</tr>
<tr>
<td>startDate</td>
<td style="text-align: center;">N</td>
<td><p>date</p>
<p>EX. 14-Sep-2000</p></td>
</tr>
<tr>
<td>jobFamilyCode</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. L</p></td>
</tr>
<tr>
<td>jobFamilyName</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. T Platform</p></td>
</tr>
<tr>
<td>positionCode</td>
<td style="text-align: center;">N</td>
<td><p>string</p>
<p>Ex. P001537</p></td>
</tr>
</tbody>
</table>

Example:

POST https://\<hostName\>/scim-users-exp-api/v1/Users

Example Request:

```json
{
  "schemas": [
    "urn:scim:schemas:core:1.0",
    "urn:scim:schemas:extension:enterprise:1.0",
    "urn:okta:mclaneco-dev_scimusersexp_2:1.0:user:custom"
  ],
  "userName": "oTEST0004578",
  "name": {
    "givenName": "Peter",
    "familyName": "Smith"
  },
  "password": "xq69ivVT",
  "active": true,
  "urn:okta:mclaneco-dev_scimusersexp_2:1.0:user:custom": {
    "userId": "psmith",
    "middleName": "M",
    "title": "Administrator, Lead Middleware",
    "streetAddress": "4747 McLane Parkway",
    "city": "Temple",
    "state": "TX",
    "zipCode": "7504",
    "department": "Platform Administration",
    "departmentId": "50200",
    "managerId": "000058215",
    "birthDate": "14-Sep-1959",
    "ssnLastFour": "1234",
    "jobCode": "1067",
    "divisionCode": "IS790",
    "division": "McLane Business Info Services",
    "companyCode": "001",
    "companyName": "McLane Company, Inc.",
    "payGrade": "L",
    "employmentStatusCode": "A",
    "compensationTypeCode": "S",
    "businessUnit": "IS790",
    "terminationDate": "01-Sep-2024",
    "extendedLeaveEffectiveDate": "30-Sep-2024",
    "flsaCode": "N",
    "locationId": "999",
    "startDate": "01-Sep-2022",
    "jobFamilyCode": "D",
    "jobFamilyName": "IT Platform",
    "positionCode": "P001537"
  }
}
```

###### Processing Summary

- Validation

- Interact with Employee ODS system api

- Prepare Response

###### Processing

####### Validation

- Validate using the API model to insure the presence of required fields
  and valid values

####### Call the Employees ODS system API

See model project for interaction details: employee-ods-sys-api

######## Path Parameters: Does Not Apply

| Name | Assignment/Description | Example |
| ---- | ---------------------- | ------- |
|      |                        |         |

######## Query Parameters: Does Not Apply

| Name | Assignment/Description | Example |
| ---- | ---------------------- | ------- |
|      |                        |         |

######## Http Header Parameters: 

| Name             | Assignment/Description                               | Example                              |
| ---------------- | ---------------------------------------------------- | ------------------------------------ |
| tracing_id       | Optionally sent in on request                        | ASY7748901                           |
| X-Correlation-Id | Assign the correlationId value generated by this api | 979f3d3b-a04a-43d7-b55f-8d5609b48783 |

######## Request Payload: see OAS model repo employee-ods-sys-api

| Element Name                 | Assignment/Description                                                                        | Notes                             |
| ---------------------------- | --------------------------------------------------------------------------------------------- | --------------------------------- |
| employee                     | Object that holds the employee data                                                           |                                   |
| employeeId                   | userName from the scim request                                                                | Ex. 000014527                     |
| userId                       | userId from the scim request                                                                  | Ex. psmith                        |
| isActive                     | active from the scim request                                                                  | Ex. true                          |
| employmentStatusCode         | If employmentStatusCode from the scim request is T then set to Terminated, else set to Active | Ex. A                             |
| birthDate                    | birthDate from the scim request                                                               | Ex. 01-Sep-1990                   |
| ssnLastFour                  | ssnLastFour from the scim request                                                             | Ex. 2212                          |
| distributionCenterDivisionId | divisionCode from the scim request                                                            | Ex. GR360                         |
| division                     | division from the scim request                                                                | Ex. McLane Business Info Services |
| department                   | department from the scim request                                                              | Ex. Platform Administration       |
| costCenter                   | departmentId from the scim request                                                            | Ex. 50200                         |
| managerId                    | managerId from the scim request                                                               | Ex. 000025527                     |
| locationId                   | locationId from the scim request                                                              | Ex. 999                           |
| companyCode                  | companyCode from the scim request                                                             | Ex. 101                           |
| companyName                  | businessUnit from the scim request                                                            | Ex. McLane Company, Inc.          |
| businessUnit                 | companyName from the scim request                                                             | Ex. IS970                         |
| terminationDate              | terminationDate from the scim request                                                         | Ex. 01-Sep-2024                   |
| payGrade                     | payGrade from the scim request                                                                | Ex. L                             |
| flsaCode                     | flsaCode from the scim request                                                                | Ex. N                             |
| compensationTypeCode         | compensationTypeCode from the scim request                                                    | Ex. S                             |
| extendedTimeOff              |                                                                                               |                                   |
| startDate                    | extendedLeaveEffectiveDate from the scim request                                              | Ex. 01-Sep-2020                   |
| name                         |                                                                                               |                                   |
| first                        | firstName from the scim request                                                               | Ex. Alex                          |
| middle                       | middleName from the scim request                                                              | Ex. Peter                         |
| last                         | lastName from the scim request                                                                | Ex. Murry                         |
| job                          |                                                                                               |                                   |
| code                         | yyyy from the scim request                                                                    | Ex. 1067                          |
| title                        | yyyy from the scim request                                                                    | Ex. Stoker                        |
| familyCode                   | jobFamilyCode from the scim request                                                           | Ex. D                             |
| family                       | jobFamilyName from the scim request                                                           | Ex. IT Platform                   |
| positionId                   | positionCode from the scim request                                                            | Ex. P001533                       |
| payGrade                     | payGrade from the scim request                                                                | Ex. L                             |
| startDate                    | startDate from the scim request                                                               | Ex. 30-Sep-2021                   |
| workAddress                  |                                                                                               |                                   |
| address1                     | streetAddress from the scim request                                                           | Ex. 123 Main Street               |
| city                         | city from the scim request                                                                    | Ex. ROME                          |
| state                        | state from the scim request                                                                   | Ex. TX                            |
| postalCode                   | zipCode from the scim request                                                                 | Ex. 14006                         |
|                              |                                                                                               |                                   |

Example:

POST https://\<server\>:\<port\>/employee-ods-sys-api/v1/employees

Example request:

{  
"employee": {  
"employeeId": "000136214",

"userId": "zernest",  
"isActive": true,  
"employmentStatusCode": "A",  
"birthDate": "30-Sep-2000",  
"ssnLastFour": "1123",  
"distributionCenterDivisionId": "GR260",  
"division": "GR260 GR Concord",  
"costCenter": "20020",  
"managerId": "000028632",  
"locationId": "999",  
"companyCode": "001",  
"companyName": "McLane Company, Inc.",

"department": "Platform Administration",

"departmentId": "50200",  
"terminationDate": null,  
"payGrade": "L",  
"flsaCode": "N",  
"compensationTypeCode": "S",

"startDate": "11-Aug-2022",  
"extendedTimeOff": {  
"startDate": ""  
},  
"name": {  
"first": "Zachary",  
"middle": "Ernest",  
"last": "Hines"  
},  
"job": {  
"code": "1067",  
"title": "Stocker",  
"familyCode": "D",  
"family": "IT Platform",  
"positionId": "P001537"  
},  
"workAddress": {  
"address1": "4747 McLane Parkway",  
"city": "Temple",  
"state": "TX",  
"postalCode": "76504"  
}  
}  
}

***Request Connector Configuration**: (externalize into a property
file)*

- *Response Timeout(ms): 50000 (responseTimeOut)*

####### Prepare Response 

The Response requires the endpoint to return an image of the employee
after the update was made

###### Response Payload: [\#Employee Detail Response Structure\|outline](#employee-ods-system-api-user-detail-response-structure)

###### Logging Events:

\- At the start of the application

flowStep: "Flow Start"

\- Right before the Create an Employee call

flowStep: " Create an Employee Request"

\- Right after the return of Create an Employee call:

flowStep: " Create an Employee Response"

-At the End of the application

flowStep: "Flow End"

###### Error Processing

Error mapping from our standard error structure to the SCIM error
structure

| Element Name | Assignment                                         | Notes                                       |
| ------------ | -------------------------------------------------- | ------------------------------------------- |
| schemas      | Assign urn:ietf:params:scim:api:messages:2.0:Error | urn:ietf:params:scim:api:messages:2.0:Error |
| detail       | context.message from the common error response     | No user found                               |
| status       | status from the common error response              | 400                                         |

If an issue/error are encountered, the specifics related to the error
are to be reported back on the response via our SCIM error structure
along with the correlation Id and the tracing Id if provided. See
[\#SCIM Error Structure\|outline](#scim-error-structure)

Example:

{  
"correlationId": "979f3d3b-a04a-43d7-b55f-8d5609b48783",  
"tracingId": "abc55247",

"schemas": \["urn:ietf:params:scim:api:messages:2.0:Error"\],  
"detail": "Bad Request",  
"status": 400  
}

###### HTTP Status Codes

Possible HTTP status codes for the response include:

- 200 OK - for success

- 400 Bad Request – for errors in the request data

- 401 Unauthorized - for errors in API authentication

- 403 Forbidden - for errors in API authorization

- 404 Resource Not found - for errors in API resource not found

- 500 Internal Server Error - for any unexpected resource failures

###### Non Functional Requirements

####### Security

####### Data

- System client id and secret

- Masking elements: Does Not apply

####### Transport

- http

####### Availability

- *99.99% uptime 24x7*

####### Reliability

- High availability via multiple workers

####### Traceability

- Transaction tracing via log data to Splunk

- Specific Auditing requirements: Does Not Apply

####### Throughput

- Current Peak Metric:

  - <span class="mark">xx</span> Concurrent transactions per second

  - <span class="mark">xx</span> Minutes - specified duration(s)

  - M T W T F S S Note any applicable days in the week

- Seasonal dimension: Does Not Apply

- Estimated Peak metric over the next 9-12 months:

  - <span class="mark">xx</span> Concurrent transactions per second

  - <span class="mark">xx</span> minutes - specified duration(s)

  - M T W T F S S Note any applicable days in the week

####### Response Time

- Target times for average or maximum response times, expressed as a
  percentile: 95% within 3 second(s).

##### Get users

Get users via filter or by paged request

###### Resource Locators

- To retrieve users:

GET {BASE_URI}/v1/Users

Type of Data Consumed:

application/json

###### Path Parameters: Does Not Apply

| Name | Assignment/Description | Example |
| ---- | ---------------------- | ------- |
|      |                        |         |

###### Query Parameters: 

| Name       | Assignment/Description                                                                        | Example              |
| ---------- | --------------------------------------------------------------------------------------------- | -------------------- |
| startIndex | Start position, Optional, default is 0                                                        | 0                    |
| count      | Number of items to return in the collection , Value between 1 and 100, optional default is 50 | 75                   |
| filter     | Search phrase, Optional                                                                       | userName = 000014527 |

###### Http Header Parameters: 

| Name             | Assignment/Description                                                                                                  | Example                              |
| ---------------- | ----------------------------------------------------------------------------------------------------------------------- | ------------------------------------ |
| tracing_id       | Optionally sent in on request                                                                                           | ASY7748901                           |
| X-Correlation-Id | If this element is present, assign it to correlationId variable, otherwise create a uuid and assign it to correlationId | 23d10540-e316-11ed-8a7a-0205dd115db9 |

###### Request Payload: Does Not Apply

| Element Name | Required | Notes |
| ------------ | :------: | ----- |
|              |          |       |

Example:

GET
https://\<hostName\>/scim-users-exp-api/v1/Users?userName=000014527&startIndex=1&count=100

Example request:

Does Not Apply

###### Processing Summary

- Validation

- Generate a value for the correlationId

- Call the Employee ODS system API

- Prepare Response

####### Validation

- Validate using the API model to insure the presence of required fields
  and valid values

####### Call System API to Get employee data for an employee identifier

See model project for interaction details: employee-ods-sys-api

######## Path Parameters: Does Not Apply

| Name | Assignment/Description | Example |
| ---- | ---------------------- | ------- |
|      |                        |         |

######## Query Parameters: 

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 41%" />
<col style="width: 38%" />
</colgroup>
<thead>
<tr>
<th>Name</th>
<th>Assignment/Description</th>
<th>Example</th>
</tr>
</thead>
<tbody>
<tr>
<td>offset</td>
<td>startIndex query parameter from the request</td>
<td>0</td>
</tr>
<tr>
<td>limit</td>
<td>count query parameter from the request</td>
<td>75</td>
</tr>
<tr>
<td>filter</td>
<td><p>filter query parameter from the request</p>
<p>map userName to employeeId</p></td>
<td>employeeId=000014527</td>
</tr>
</tbody>
</table>

######## Http Header Parameters: 

| Name             | Assignment/Description                               | Example                              |
| ---------------- | ---------------------------------------------------- | ------------------------------------ |
| tracing_id       | Optionally sent in on request                        | ASY7748901                           |
| X-Correlation-Id | Assign the correlationId value generated by this api | 979f3d3b-a04a-43d7-b55f-8d5609b48783 |

######## Request Payload: Does Not Apply

| Element Name | Required | Notes |
| ------------ | :------: | ----- |
|              |          |       |

Example:

GET
https://\<server\>:\<port\>/employee-ods-sys-api/v1/employees?employeeId
eq 00014527&offset=1&limit=100

Example request:

Does Not Apply

***Request Connector Configuration**: (externalize into a property
file)*

- *Response Timeout(ms): 30000 (responseTimeOut)*

####### Prepare Response 

System API Response Payload definition: [\#Employee User Detail Response
Structure\|outline](#employee-ods-system-api-user-detail-response-structure)

The System API response will be a collection of employees with each item
defined as: [\#Employee User Detail Response
Structure\|outline](#employee-ods-system-api-user-detail-response-structure)

This experience API response will be a collection of resources with each
item defined as [\#SCIM Employee User Detail Mapping
Structure\|outline](#scim-user-response-detail-mapping-structure)

######## Response Payload: 

\*\*See OAS model in the repository for more details

Response Payload description: [\#SCIM Employee User Detail Mapping
Structure\|outline](#scim-user-response-detail-mapping-structure)

<table>
<colgroup>
<col style="width: 24%" />
<col style="width: 42%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr>
<th>Element Name</th>
<th>Assignment</th>
<th>Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td>correlationId</td>
<td>correlationId</td>
<td><p>string</p>
<p>Ex. ae8c5b85-97e0-4f55-80e7-6161d67220ae</p></td>
</tr>
<tr>
<td>tracingId</td>
<td>Optional tracing_Id from the system API request header</td>
<td><p>string</p>
<p>Ex. A19283745</p></td>
</tr>
<tr>
<td>schemas</td>
<td>urn:ietf:params:scim:api:messages:2.0:ListResponse</td>
<td><p>string array</p>
<p>EX, urn:ietf:params:scim:api:messages:2.0:ListResponse</p></td>
</tr>
<tr>
<td>totalResults</td>
<td>Total number of items in the resources collection</td>
<td><p>number</p>
<p>Ex. 50</p></td>
</tr>
<tr>
<td>startIndex</td>
<td>startIndex query parameter</td>
<td><p>number</p>
<p>Ex. 1</p></td>
</tr>
<tr>
<td>itemsPerPage</td>
<td>Total number of items in the resources collection</td>
<td><p>number</p>
<p>Ex. 50</p></td>
</tr>
<tr>
<td>Resources</td>
<td><p>Collection of SCIM employees without the meta information</p>
<p><a href="#scim-user-response-detail-mapping-structure">#SCIM Employee
User Detail Mapping Structure|outline</a></p></td>
<td></td>
</tr>
<tr>
<td></td>
<td></td>
<td></td>
</tr>
</tbody>
</table>

Example:

{  
"correlationId": "87f646bd-5cfd-41de-8263-02e636a91383",  
"tracingId": "js-20240703-001",  
"totalResults": 2,  
"startIndex": 1,  
"itemsPerPage": 2,  
"schemas": \[  
"urn:ietf:params:scim:api:messages:2.0:ListResponse"  
\],  
"Resources": \[  
{  
"id": "000012333",  
"userName": "000012333",  
"active": true,  
"name": {  
"familyName": "Julips",  
"givenName": "Skip"  
},  
"title": "Stocker",  
"middleName": "Terry",  
"streetAddress": "133 Center Street",  
"city": "Angola",  
"state": "NY",  
"zipCode": "14006",  
"employeeNumber": "000012333",  
"department": "Platform Administration",  
"managerId": "000028633",  
"birthDate": "1999-06-23",  
"ssnLastFour": "1234",  
"departmentId": "20020",  
"jobCode": "1067",  
"divisionCode": "GR260",  
"division": "GR260 GR Concords",  
"companyCode": "001",  
"companyName": "McLane Company, Inc.",  
"payGrade": "L",  
"employmentStatusCode": "A",  
"compensationType": "S",  
"businessUnit": "GR260",  
"terminationDate": "",  
"extendedLeaveEffectiveDate": "2024-07-01",  
"flsaCode": "N",  
"locationId": "999",  
"jobFamilyCode": "D",  
"jobFamilyName": "IT Platform",  
"positionCode": "P001537",  
"startDate": "2020-01-01"  
},  
{  
"id": "000012388",  
"userName": "000012388",  
"active": true,  
"name": {  
"familyName": "Drew",  
"givenName": "Nancy"  
},  
"title": "Stocker",  
"middleName": "P",  
"streetAddress": "133 Center Street",  
"city": "Angola",  
"state": "NY",  
"zipCode": "14006",  
"employeeNumber": "000012388",  
"department": "Platform Administration",  
"managerId": "000028633",  
"birthDate": "11-Oct-1995",  
"ssnLastFour": "5749",  
"departmentId": "50020",  
"jobCode": "1088",  
"divisionCode": "GR260",  
"division": "GR360 GR Concords",  
"companyCode": "001",  
"companyName": "McLane Company, Inc.",  
"payGrade": "L",  
"employmentStatusCode": "A",  
"compensationTypeCode": "S",  
"businessUnit": "GR360",  
"terminationDate": "",  
"extendedLeaveEffectiveDate": "21-Oct-2024",  
"flsaCode": "N",  
"locationId": "999",  
"jobFamilyCode": "D",  
"jobFamilyName": "IT Platform",  
"positionCode": "P001588",  
"startDate": "11-Oct-2000"  
}  
\]  
}

HTTP Status Codes

Possible HTTP status codes for the response include:

- 200 OK - for success

- 400 Bad Request – for errors in the request data

- 401 Unauthorized - for errors in API authentication

- 403 Forbidden - for errors in API authorization

- 404 Resource Not found - for errors in API resource not found

- 500 Internal Server Error - for any unexpected resource failures

####### Logging Events:

\- At the start of the application

flowStep: "Flow Start"

\- Right before the Get Employees call:

flowStep: "Get Employees Request"

\- Right after the return of the Get Employees call:

flowStep: "Get Employees Response"

-At the End of the application

>  flowStep: "Flow End"

###### Error Processing

Error mapping from our standard error structure to the SCIM error
structure

| Element Name | Assignment                                         | Notes                                       |
| ------------ | -------------------------------------------------- | ------------------------------------------- |
| schemas      | Assign urn:ietf:params:scim:api:messages:2.0:Error | urn:ietf:params:scim:api:messages:2.0:Error |
| detail       | context.message from the common error response     | No user found                               |
| status       | status from the common error response              | 400                                         |

If an issue/error is encountered, the specifics related to the error are
to be reported back on the response via our SCIM error structure along
with the correlation Id and the tracing Id if provided.

###### Non Functional Requirements

####### Security

####### Data

- System client id and secret

- Masking elements: Does Not apply

####### Transport

- https

####### Availability

- *99.99% uptime 24x7*

####### Reliability

- High availability via multiple workers

####### Traceability

- Transaction tracing via log data to Splunk

- Specific Auditing requirements: Does Not Apply

####### Throughput

- Current Peak Metric:

  - <span class="mark">xx</span> Concurrent transactions per second

  - <span class="mark">xx</span> Minutes - specified duration(s)

  - M T W T F S S Note any applicable days in the week

- Seasonal dimension: Does Not Apply

- Estimated Peak metric over the next 9-12 months:

  - <span class="mark">xx</span> Concurrent transactions per second

  - <span class="mark">xx</span> minutes - specified duration(s)

  - M T W T F S S Note any applicable days in the week

####### Response Time

- Target times for average or maximum response times, expressed as a
  percentile: 95% within 2 second(s).

##### SCIM Users Health Check 

This endpoint enables a health check ping to insure the application, and
the dependent API is up and running

###### Resource Locators

1)  To get a heart check response

GET {BASE_URI}/v1/health

1.  Type of Data Consumed:

<!-- -->

2)  Type of Data Consumed:

Does not apply as there is no request payload

###### Path Parameters: Does Not Apply

| Name | Assignment/Description | Example |
| ---- | ---------------------- | ------- |
|      |                        |         |

###### Query Parameters: Does Not Apply

| Name | Assignment/Description | Example |
| ---- | ---------------------- | ------- |
|      |                        |         |

###### Http Request Parameters: 

| Name             | Assignment/Description                                   | Example                              |
| ---------------- | -------------------------------------------------------- | ------------------------------------ |
| tracing_id       | Optional                                                 | Z987yy54r3                           |
| X-Correlation-Id | Optional, if present should be used as the correlationId | 979f3d3b-a04a-43d7-b55f-8d5609b48783 |

###### Request Payload: Does Not Apply

| Element Name | Assignment | Notes |     |
| ------------ | ---------- | ----- | --- |
|              |            |       |     |

Example:

GET https://\<server\>:\<port\>/scim-users-exp-api/v1/health

This will check that the API, and any dependent API’s are up and
responding

-Return a 200 upon successful completion with payload:

-Return a 500 if any issue(s) are encountered returning the status
object outlining the

###### Processing Summary

- Call the health check endpoint for the Employees ODS system API

<!-- -->

- Prepare Response

####### Call the health endpoint for the Employees ODS system API

API:

- API:

GET https:\<host\>:\<port\>/{BASE_URI}/v1/health

- See the OAS model project for interaction details:
  employee-ods-sys-api

###### Response Payload: For Successful responses

####### Response Payload: For Successful responses

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 40%" />
<col style="width: 38%" />
</colgroup>
<thead>
<tr>
<th>Element Name</th>
<th>Assignment</th>
<th>Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td>status</td>
<td>Constant UP or DOWN</td>
<td><p>string</p>
<p>Ex. UP</p></td>
</tr>
<tr>
<td>checks</td>
<td>Object that contains the dependent status</td>
<td></td>
</tr>
<tr>
<td>name</td>
<td>The value of API name returned from the calling that application
health check</td>
<td><p>string</p>
<p>Ex. EBS Purchasing</p></td>
</tr>
<tr>
<td>status</td>
<td>The value of the API status returned from the calling that
application health check</td>
<td><p>string</p>
<p>Ex. UP</p></td>
</tr>
<tr>
<td>data</td>
<td>Object that hold health check specifics</td>
<td></td>
</tr>
<tr>
<td>correlationId</td>
<td>correlationId</td>
<td><p>string</p>
<p>Ex. d5f6fbf8-6774-4a95-9b59-15348943abd4</p></td>
</tr>
<tr>
<td>tracingId</td>
<td>Optional tracing_id from the system API request header, if
present</td>
<td><p>string</p>
<p>Ex. A3345732</p></td>
</tr>
<tr>
<td>apiVersion</td>
<td>Version of the API</td>
<td><p>string</p>
<p>Ex. v1</p></td>
</tr>
<tr>
<td>apiName</td>
<td>API application name</td>
<td><p>string</p>
<p>Ex. procurement-mgmt-exp-api</p></td>
</tr>
<tr>
<td>timestamp</td>
<td>now</td>
<td><p>string</p>
<p>Ex. 2021-07-18T16:55:46.678-05:00</p></td>
</tr>
<tr>
<td>url</td>
<td>rl called when checking the dependant API</td>
<td><p>string</p>
<p>Ex.</p></td>
</tr>
</tbody>
</table>

Example:

{  
"status": "UP",  
"checks": \[  
{  
"name": "Liveness",  
"status": "UP",  
"data": {  
"apiName": "supplier-items-exp-api",  
"apiVersion": "v1",  
"dependencies":
"\[http:/supplier-items-exp-api-service.supplier-items.svc.cluster.local:8080/supplier-items-exp-api/v1,
http://ecomm-jira-sys-api-service.ecomm-jira-dev.svc.cluster.local:8080/ecomm-jira-sys-api/v1\]",  
"timestamp": "2024-03-12T17:20:57.874697615",  
"correlationId": "93b0a5ca-4eaa-4650-a7a1-ca51bd63e0e1",  
"tracingId": "try again"  
}  
},  
{  
"name": "Readiness",  
"status": "UP",  
"data": {  
"apiName": "ecomm-jira-sys-api",  
"apiVersion": "v1",  
"timestamp": "2024-03-12T17:20:57.875002037",  
"correlationId": "93b0a5ca-4eaa-4650-a7a1-ca51bd63e0e1",  
"tracingId": "try again",  
"url":
"http://ecomm-jira-sys-api-service.ecomm-jira-dev.svc.cluster.local:8080/ecomm-jira-sys-api/v1"  
}  
}  
\]  
}

-Return a 500 if any issue(s) are encountered returning the status
object outlining the context of the issue

###### Response Payload: For failures only

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 40%" />
<col style="width: 38%" />
</colgroup>
<thead>
<tr>
<th>Element Name</th>
<th>Assignment</th>
<th>Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td>correlationId</td>
<td>correlationId</td>
<td><p>string</p>
<p>Ex. d5f6fbf8-6774-4a95-9b59-15348943abd4</p></td>
</tr>
<tr>
<td>tracingId</td>
<td>tracing_id from the system API request header, if present</td>
<td><p>string</p>
<p>Ex. A3345732</p></td>
</tr>
<tr>
<td>status</td>
<td>Http status code</td>
<td>Object that holds processing status context</td>
</tr>
<tr>
<td><strong>context</strong></td>
<td></td>
<td>Object that holds the collection of diagnostic information</td>
</tr>
<tr>
<td>type</td>
<td>“Error”</td>
<td>string</td>
</tr>
<tr>
<td>severity</td>
<td></td>
<td>string</td>
</tr>
<tr>
<td>reasonCode</td>
<td>Sql code if available</td>
<td>string</td>
</tr>
<tr>
<td>message</td>
<td>Error message text</td>
<td>string</td>
</tr>
<tr>
<td>component</td>
<td>app.name</td>
<td>string</td>
</tr>
<tr>
<td>timeStamp</td>
<td>Current date &amp; time</td>
<td>string</td>
</tr>
</tbody>
</table>

Example:

{  
"correlationId": "d5f6fbf8-6774-4a95-9b59-15348943abd4",  
"tracingId": "A19283745",  
"status": 500,  
"context": \[  
{  
"type": "Error",  
"severity": "1",  
"reasonCode": "40613",  
"message": "Database mydb on server mydbserver is not currently
available",  
"component": "supplier-items-exp-api",  
"timeStamp": "2022-09-30T15:27:49.274Z"  
}  
\]  
}

###### HTTP Status Codes

Possible HTTP status codes for the response include:

- 200 Request accepted

- 401 Unauthorized - for errors in API authentication

- 403 Forbidden - for errors in API authorization

- 500 Internal Server Error - for unexpected failures

# Appendix

## API Environments:

| Environment | Host                   |
| ----------- | ---------------------- |
| Development | apim-dev.mclaneco.com  |
| Test        | apim-test.mclaneco.com |
| Production  | apim.mclaneco.com      |

## SCIM Error Structure

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 40%" />
<col style="width: 38%" />
</colgroup>
<thead>
<tr>
<th>Element Name</th>
<th>Assignment</th>
<th>Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td>correlationId</td>
<td>correlationId</td>
<td><p>string</p>
<p>Ex. d5f6fbf8-6774-4a95-9b59-15348943abd4</p></td>
</tr>
<tr>
<td>tracingId</td>
<td>tracing_id from the system API request header, if present</td>
<td><p>string</p>
<p>Ex. A3345732</p></td>
</tr>
<tr>
<td>schemas</td>
<td>Assign urn:ietf:params:scim:api:messages:2.0:Error</td>
<td><p>string</p>
<p>Ex. urn:ietf:params:scim:api:messages:2.0:Error</p></td>
</tr>
<tr>
<td>message</td>
<td>Error message text</td>
<td><p>string</p>
<p>Ex. User not found</p></td>
</tr>
<tr>
<td>status</td>
<td><p>Http status code</p>
<p>400=Bad Request</p>
<p>401=Unauthorized</p>
<p>403=Forbidden</p>
<p>404=Resource Not Found</p>
<p>405=Method Not Allowed</p>
<p>406=Not Acceptable</p>
<p>429=Too Many Requests</p>
<p>3xx: Redirection</p>
<p>5xx: Unexpected error</p></td>
<td><p>number</p>
<p>Ex, 404</p></td>
</tr>
<tr>
<td></td>
<td></td>
<td></td>
</tr>
</tbody>
</table>

Example:

{  
"correlationId": "d5ebd3b0-774e-11ed-aa7d-02d22cb5f8e0",  
"tracingId": "XYZ188978-001",  
"schemas": \[  
"urn:ietf:params:scim:api:messages:2.0:Error"  
\],  
"detail": "User not found",  
"status": 404  
}

## Log Event Structure

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 40%" />
<col style="width: 38%" />
</colgroup>
<thead>
<tr>
<th>Element Name</th>
<th>Assignment</th>
<th>Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td>correlationId</td>
<td>correlationId</td>
<td><p>string</p>
<p>Ex. d5f6fbf8-6774-4a95-9b59-15348943abd4</p></td>
</tr>
<tr>
<td>tracingId</td>
<td>tracing_id from the system API request header, if present</td>
<td>Ex. A3345732</td>
</tr>
<tr>
<td>clientId</td>
<td></td>
<td>Ex. c9feb3160f0b4ea785875ad678e00c1c</td>
</tr>
<tr>
<td>appName</td>
<td></td>
<td>Ex. mfdb2-sales-sys-api-1</td>
</tr>
<tr>
<td>flowName</td>
<td></td>
<td>Ex. mfdb2-sales-sys-api-main</td>
</tr>
<tr>
<td>flowStep</td>
<td></td>
<td>Ex. Flow End</td>
</tr>
<tr>
<td>timestamp</td>
<td>Current date &amp; time</td>
<td>Ex. 2023-04-25T03:06:16.405Z</td>
</tr>
<tr>
<td>environment</td>
<td>DEV,TEST, PROD</td>
<td>Based on the environment we are running in</td>
</tr>
<tr>
<td>payload</td>
<td>If log level is DEBUG add the payload</td>
<td></td>
</tr>
<tr>
<td></td>
<td></td>
<td></td>
</tr>
</tbody>
</table>

Example:

{  
"appName": "mcl-b2bi-files-sys-api-1",  
"clientId": "c9feb3160f0b4ea785875ad678e00c1c",  
"correlationId": "23d10540-e316-11ed-8a7a-0205dd115db9",  
"tracingId": "A23778-01",  
"flowName": "ebs-employee-sys-api-main",  
"flowStep": "Flow End",  
"timestamp": "2023-05-25T03:06:16.405Z",  
"environment": "PROD",  
"payload": {  
"correlationId": "23d10540-e316-11ed-8a7a-0205dd115db9",  
"tracingId": "",  
"status": {  
"code": "200",  
"messages": \[  
{  
"type": "Diagnostic",  
"message": "BuyerQuestTerm Data has been queued for processing",  
"timeStamp": "2023-04-25T03:06:16.403Z"  
}  
\]  
}  
}  
}

## Employee ODS System API User Detail Response Structure

Example system API response:

{  
"correlationId": "d5ebd3b0-774e-11ed-aa7d-02d22cb5f8e0",  
"tracingId": "XYZ188978-001",  
"employee": {  
"employeeId": "000136214",

"userId": "zernest",

"isActive": true,  
"startDate": "2022-01-08",  
"employmentStatusCode": "A",  
"birthDate": "2000-06-08",  
"ssnLastFour": "1123",  
"distributionCenterDivisionId": "GR260",  
"division": "GR260 GR Concord",  
"costCenter": "20020",  
"managerId": "000028632",  
"locationId": "999",  
"companyCode": "001",  
"companyName": "McLane Company, Inc.",  
"terminationDate": null,  
"payGrade": "L",  
"flsaCode": "A",  
"compensationTypeCode": "S",

"businessUnit": "GR360",

"lastModifiedDateTime": "2024-08-16T19:41:53Z",  
"extendedTimeOff": {  
"startDate": ""  
},  
"name": {  
"first": "Zachary",  
"middle": "Ernest",  
"last": "Hines"  
},  
"job": {  
"code": "1067",  
"title": "Stocker",  
"familyCode": "D",  
"family": "IT Platform",  
"positionId": "P001537"  
},  
"workAddress": {  
"address1": "4747 McLane Parkway",  
"city": "Temple",  
"state": "TX",  
"postalCode": "76504"  
}  
}  
}

## SCIM User Response Detail Mapping Structure

### SCIM Employee Detail Mapping 

### Response Payload: 

\*\*See model repo for more details

<table>
<colgroup>
<col style="width: 27%" />
<col style="width: 45%" />
<col style="width: 26%" />
</colgroup>
<thead>
<tr>
<th>Element Name</th>
<th>Assignment</th>
<th>Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td>schemas</td>
<td><p>Text array of scim schema definitions</p>
<p>Assign the constants:</p>
<p>-urn:ietf:params:scim:schemas:core:2.0:User</p>
<p>-urn:ietf:params:scim:schemas:extension:CustomExtensionName:2.0:User</p></td>
<td><p>urn:ietf:params:scim:schemas:core:2.0:User,</p>
<p>urn:ietf:params:scim:schemas:extension:CustomExtensionName:2.0:User</p></td>
</tr>
<tr>
<td>id</td>
<td>employeeId from the response</td>
<td><p>string</p>
<p>Ex. 000061149</p></td>
</tr>
<tr>
<td>userName</td>
<td>employeeId from the response</td>
<td><p>string</p>
<p>Ex. 000061149</p></td>
</tr>
<tr>
<td>active</td>
<td>isActive from the response</td>
<td><p>boolean</p>
<p>Ex. true</p></td>
</tr>
<tr>
<td>name</td>
<td></td>
<td>object</td>
</tr>
<tr>
<td>givenName</td>
<td>name.first from the response</td>
<td><p>string</p>
<p>Ex. Mary</p></td>
</tr>
<tr>
<td><del>middleName</del></td>
<td><del>name.middle from the response</del></td>
<td><p><del>string</del></p>
<p><del>Ex. Sue</del></p></td>
</tr>
<tr>
<td>familyName</td>
<td>name.last from the response</td>
<td><p>string</p>
<p>Ex. Eliassen</p></td>
</tr>
<tr>
<td>userId</td>
<td>userId from the response</td>
<td><p>string</p>
<p>Ex. psmith</p></td>
</tr>
<tr>
<td>middleName</td>
<td>name.middle from the response</td>
<td><p>string</p>
<p>Ex. Sue</p></td>
</tr>
<tr>
<td>title</td>
<td>job.title from the response</td>
<td><p>string</p>
<p>Ex. Administrator, Lead Middleware</p></td>
</tr>
<tr>
<td>streetAddress</td>
<td>workAddress.address1 from the response</td>
<td><p>string</p>
<p>Ex. 4747 McLane Parkway</p></td>
</tr>
<tr>
<td>city</td>
<td>workAddress.city from the response</td>
<td><p>string</p>
<p>Ex. Temple</p></td>
</tr>
<tr>
<td>state</td>
<td>workAddress.state from the response</td>
<td><p>string</p>
<p>Ex. TX</p></td>
</tr>
<tr>
<td>zipCode</td>
<td>workAddress.postalCode from the response</td>
<td><p>string</p>
<p>Ex. 76504</p></td>
</tr>
<tr>
<td>department</td>
<td>department from the response</td>
<td><p>string</p>
<p>Ex. Platform Administration</p></td>
</tr>
<tr>
<td>departmentId</td>
<td>costCenter from the response</td>
<td><p>string</p>
<p>Ex. 20000</p></td>
</tr>
<tr>
<td>managerId</td>
<td>managerId from the response</td>
<td><p>string</p>
<p>Ex. 000061149</p></td>
</tr>
<tr>
<td>birthDate</td>
<td>birthDate from the response</td>
<td><p>date</p>
<p>Ex. 11-Oct-1995</p></td>
</tr>
<tr>
<td>ssnLastFour</td>
<td>ssnLastFour from the response</td>
<td><p>string</p>
<p>Ex.1149</p></td>
</tr>
<tr>
<td>jobCode</td>
<td>job.code from the response</td>
<td><p>string</p>
<p>Ex. 1067</p></td>
</tr>
<tr>
<td>divisionCode</td>
<td>distributionCenterDivisionId from the response</td>
<td><p>string</p>
<p>Ex. GR260</p></td>
</tr>
<tr>
<td>division</td>
<td>division from the response</td>
<td><p>string</p>
<p>Ex. McLane Business Info Services</p></td>
</tr>
<tr>
<td>companyCode</td>
<td>companyCode from the response</td>
<td><p>string</p>
<p>Ex. 20020</p></td>
</tr>
<tr>
<td>companyName</td>
<td>companyName from the response</td>
<td><p>string</p>
<p>Ex. McLane Company, Inc.</p></td>
</tr>
<tr>
<td>payGrade</td>
<td>payGrade from the response</td>
<td><p>string</p>
<p>Ex. L</p></td>
</tr>
<tr>
<td>employmentStatusCode</td>
<td>employmentStatusCode from the response</td>
<td><p>string</p>
<p>Ex. A</p></td>
</tr>
<tr>
<td>compensationTypeCode</td>
<td>compensationTypeCode from the response</td>
<td><p>string</p>
<p>Ex. S</p></td>
</tr>
<tr>
<td>businessUnit</td>
<td>businessUnit from the response</td>
<td><p>string</p>
<p>Ex. IS970</p></td>
</tr>
<tr>
<td>terminationDate</td>
<td>terminationDate from the response</td>
<td><p>date</p>
<p>EX. 11-Oct-2024</p></td>
</tr>
<tr>
<td>extendedLeaveEffectiveDate</td>
<td>extendedTimeOff.startDate from the response</td>
<td><p>date</p>
<p>EX. 11-Aug-2024</p></td>
</tr>
<tr>
<td>flsaCode</td>
<td>flsaCode from the response</td>
<td><p>string</p>
<p>Ex. L</p></td>
</tr>
<tr>
<td>locationId</td>
<td>locationId from the response</td>
<td><p>string</p>
<p>Ex. 099</p></td>
</tr>
<tr>
<td>startDate</td>
<td>startDate from the response</td>
<td><p>date</p>
<p>EX. 11-Oct-2000</p></td>
</tr>
<tr>
<td>jobFamilyCode</td>
<td>job.familyCode from the response</td>
<td><p>string</p>
<p>Ex. L</p></td>
</tr>
<tr>
<td>jobFamilyName</td>
<td>job.family from the response</td>
<td><p>string</p>
<p>Ex. T Platform</p></td>
</tr>
<tr>
<td>positionCode</td>
<td>job.positionId from the response</td>
<td><p>string</p>
<p>Ex. P001537</p></td>
</tr>
<tr>
<td>meta</td>
<td></td>
<td></td>
</tr>
<tr>
<td>resourceType</td>
<td>Assign “User”</td>
<td><p>string</p>
<p>Ex. User</p></td>
</tr>
<tr>
<td>created</td>
<td>Assign “User”</td>
<td><p>date-time</p>
<p>Ex. 2024-01-23T04:56:22Z</p></td>
</tr>
<tr>
<td>lastModified</td>
<td>lastModifiedDateTime from the response</td>
<td><p>date-time</p>
<p>Ex. 2024-05-13T04:42:34Z</p></td>
</tr>
<tr>
<td>version</td>
<td>Assign “v2.0”</td>
<td><p>string</p>
<p>Ex. v2.0</p></td>
</tr>
<tr>
<td>location</td>
<td>Assign the full url that was called</td>
<td><p>string</p>
<p>Ex.
https://apim-test.mclanecp.com/scim-users-exp-api/v1/users/000136214</p></td>
</tr>
</tbody>
</table>

Example:

{  
"schemas": \[  
"urn:ietf:params:scim:schemas:core:2.0:User"  
\],  
"userName": "000014527",  
"active": true,  
"id": "000014527",  
"name": {  
"familyName": "Smith",  
"givenName": "Peter"  
},

"userId": "psmith",

"middleName": null,  
"title": "Administrator, Lead Middleware",  
"streetAddress": "4747 McLane Parkway",  
"city": "Temple",  
"state": "TX",  
"zipCode": "7504",  
"department": "Platform Administration",  
"departmentId": "50200",  
"managerId": "000058215",  
"birthDate": "14-Sep-1959",  
"ssnLastFour": "1234",  
"jobCode": "1067",  
"divisionCode": "IS790",  
"division": "McLane Business Info Services",  
"companyCode": "001",  
"companyName": "McLane Company, Inc.",  
"payGrade": "L",  
"employmentStatusCode": "A",  
"compensationTypeCode": "S",  
"businessUnit": "IS790",  
"terminationDate": "01-Sep-2024",  
"extendedLeaveEffectiveDate": "30-Sep-2024",  
"flsaCode": "N",  
"locationId": "999",  
"startDate": "01-Sep-2022",  
"jobFamilyCode": "D",  
"jobFamilyName": "IT Platform",  
"positionCode": "P001537",  
"meta": {  
"resourceType": "User",  
"created": "2024-01-23T04:56:22Z",  
"lastModified": "2024-05-13T04:42:34Z",  
"version": "v2.0",  
"location":
"https://apim-test.mclanecp.com/scim-users-exp-api/v1/users/000014527"  
}  
}

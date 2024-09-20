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
<td>05/16/2024</td>
</tr>
<tr>
<td></td>
<td></td>
<td>Add Put endpoint</td>
<td>05/29/2024</td>
</tr>
<tr>
<td></td>
<td></td>
<td>Add Patch endpoint</td>
<td>06/05/2024</td>
</tr>
<tr>
<td></td>
<td></td>
<td>Add Post endpoint</td>
<td>06/05/2024</td>
</tr>
<tr>
<td></td>
<td></td>
<td>Update Patch and Put endpoint to use Stored procedure</td>
<td>06/27/2024</td>
</tr>
<tr>
<td></td>
<td></td>
<td>Update Get by user id to endpoint to use Stored procedure</td>
<td>07/03/2204</td>
</tr>
<tr>
<td></td>
<td></td>
<td>Update Get (Search) by user id to endpoint to use Stored
procedure</td>
<td>07/16/2204</td>
</tr>
<tr>
<td>1.1</td>
<td></td>
<td>Update the Get by user id to use the search employees stored
procedure</td>
<td>07/17/2024</td>
</tr>
<tr>
<td></td>
<td></td>
<td><p>Changed fisaRegionalCode to fisaCode</p>
<p>Changed status to employmentStatusCode</p></td>
<td>07/23/2024</td>
</tr>
<tr>
<td></td>
<td></td>
<td><p>Change to handle different date formats</p>
<p>DD-MON-YYYY and YYYY-MM-DD</p></td>
<td>07/31/2024</td>
</tr>
<tr>
<td></td>
<td></td>
<td>URL decode of the filter parameter value</td>
<td>08/06/2024</td>
</tr>
<tr>
<td></td>
<td></td>
<td><p>Add last modified date to the get response</p>
<p>Add userId to Get/Put/Post</p></td>
<td>08/19/2024</td>
</tr>
</tbody>
</table>

# Purpose 

This document provides specifics that describes the API that is to be
built to support a database tables and views of synchronized employee
data. Certain applications would then make use of this data to support
their employee based data needs.

# Taxonomy

OKTA: An application that distributes updated employee data

Workday: McLane’s HCM system of record

# Solution Overview

This document will outline the interaction details required to support
an operational data store containing employee data. This system API will
expose employee data contained in the ODS which is constantly kept up to
data from the system of record via the OKTA application.

## Process Context

![](./images/process-context.png)

## Logical Viewpoint

![](./images/logical-viewpoint.png)

## Deployment Viewpoint

![](./images/deployment-viewpoint.png)

# System API

## Employee ODS

A set of tables and views were built to support an Employee operational
data store. Applications that pull employee based data as part of their
processing would access these ODS tables/views. The employee ODS is
constantly updated to keep in sync with employee system of record.

This system API will focus on the specific nuances associated with
maintaining the database tables associated with the Oracle based
employee ODS.

## Functional Design

### Resources

#### Employee

Employee data is consumed by many systems in the McLane application
landscape, and having accurate employee data is imperative for the
successful operation of those applications. This ODS is sourced from the
HCM system via OKTA, will seek to synchronize employee data in a timly
manner

The ODS is underpinned with an Oracle database that this system API will
expose for real time access.

##### Project Names:

OAS Model Project: employee-ods-sys-api

Development Project: employee-ods-sys-api

OpenShift Project: employee-events-dev, employee-events-test,
employee-events

##### Policies

- Client Id Enforcement

##### Get employee data via an employee Id

Get employee information using an employee Id

###### Resource Locators

- To retrieve details on an employee:

GET {BASE_URI}/v1/employees/{employeeId}

Type of Data Consumed:

application/json

###### Path Parameters: 

| Name       | Assignment/Description     | Example   |
|:-----------|:---------------------------|:----------|
| employeeId | Unique employee identifier | 000061149 |

###### Query Parameters: Does Not Apply

| Name | Assignment/Description | Example |
|:-----|:-----------------------|:--------|
|      |                        |         |

###### Http Header Parameters: 

| Name | Assignment/Description | Example |
|:---|:---|:---|
| tracing_id | Optionally sent in on request | ASY7748901 |
| X-Correlation-Id | If this element is present, assign it to correlationId variable, otherwise create a uuid and assign it to correlatioId | 23d10540-e316-11ed-8a7a-0205dd115db9 |

###### Request Payload: Does Not Apply

| Element Name | Required | Notes |
|:-------------|:--------:|:------|
|              |          |       |

Example:

GET https://\<hostName\>/employees-ods-sys-api/v1/employees/000061149

Example request:

Does Not Apply

###### Processing Summary

- Validation

- Interact with Employee ODS Oracle DB via SQL statements

- Prepare Response

###### Processing

####### Validation

- Validate using the API model to insure the presence of required fields
  and valid values

####### Interact with Employee ODS database

~~Select \* from INTERIM.MCL_ONBOARDING_AND_EMPL Where EMPLID =
\<**employeeId**\>~~

Invoke the stored procedure in the \<schema\>. GETUSERS_SP

Where \<schema\> value is INTERIM_CODE externalized in a property file

**CALL** INTERIM_CODE.GETUSERS_SP(resultsSet,:OFFSET,:LIMIT,:EMPLID);

| Stored Procedure Parameter | Parameter | Assignment/Description | Example |
|----|----|----|----|
| resultsSet |  | Cursor containing the rows returned |  |
| OFFSET |  | offset query parameter, default to zero | 5 |
| LIMIT |  | limit query parameter, default to 20 | 20 |
| EMPLID |  | employeeId query parameter | 000014527 |

Example:

CALL INTERIM_CODE.GETUSERS_SP (resultsSet,5,20,000014527);

~~**CALL**
INTERIM_CODE.GETUSERBYID_SP(:EMPLID,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);~~

~~Example:~~

~~CALL
INTERIM_CODE.GETUSERBYID_SP(:EMPLID,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);~~

~~FIRST_NM~~

~~MIDDLE_NM~~

~~LAST_NM~~

~~BIRTHDATE~~

~~SSN~~

~~DEPT_ID,~~

~~DEPT_NM~~

~~JOB_CD~~

~~JOB_NM~~

~~JOB_FAM_CD~~

~~JOB_FAM_NM~~

~~POSITION_CD~~

~~DIV_CD~~

~~DIV_NM~~

~~COMPANY_CD~~

~~COMPANY_NM~~

~~GRADE~~

~~SUPERVISOR_ID~~

~~EMPL_STATUS~~

~~EMPL_TYPE~~

~~BUSINESS_UNIT~~

~~TERM_DT~~

~~LOCATION~~

~~ADDRESS~~

~~CITY~~

~~STATE~~

~~ZIP~~

~~LEAVE_EFF_DT~~

~~FLSA_STATUS~~

~~START_DT~~

Externalize the schemaName in a property file used in the query by
placing the schema value in a property named: schemaName

The schemaName value can be found at: [EBS Oracle
Environments:](#_EBS_Oracle_Environments:)

**Extension Configuration**: *(externalize into a property file)*

- Query Timeout: 15 *(queryTimeout)*

- Query Timeout Unit: Seconds *(queryTimeoutUnit)*

####### Prepare Response 

###### Response Payload: [\#Employee Detail Response Structure\|outline](#employee-detail-response-structure)

Use the definition in the Appendix to prepare the response.

###### Logging Events:

\- At the start of the application

flowStep: "Flow Start"

\- Right before the Getting an Employee Row call

flowStep: " Get an Employee Row Request"

\- Right after the return of Getting an Employee Row call:

flowStep: " Get an Employee Row Response"

-At the End of the application

flowStep: "Flow End"

###### Error Processing

If the results set is empty (employee not found) then create an error
response and sent back to the caller.

-Set the following status elements in the response

status = 404

context.type = “Error”

> context.message = Employee not found for employee Id = {employeeId}
> from the path parameter}

Example:

{  
"correlationId": "979f3d3b-a04a-43d7-b55f-8d5609b48783",  
"tracingId": "abc55247",  
"title": "Resource Not Found",  
"status": 404,  
"instance":
"https://apim.mclaneco.com/employees-ods-sys-api/v1/employees/000136222",  
"requestId": "979f3d3b-a04a-43d7-b55f-8d5609b48783",  
"context": \[  
{  
"type": "Error",  
"severity": "1",  
"reasonCode": "422",  
"component": "employees-ods-sys-api”,  
"timeStamp": "2023-04-20T14:46:59.131Z",  
"message": "Employee not found for employee Id = 000136222"  
}  
\]  
}

If an issue/error are encountered, the specifics related to the error
are to be reported back on the response via our common error structure
along with the correlation Id and the tracing Id if provided. See [Error
Structure](#_Error_Structure)

Example:

{  
"correlationId": "979f3d3b-a04a-43d7-b55f-8d5609b48783",  
"tracingId": "abc55247",  
"title": "Resource Not Found",  
"status": 404,  
"instance":
"https://apim.mclaneco.com/employees-ods-sys-api/v1/employees/000136222",  
"requestId": "979f3d3b-a04a-43d7-b55f-8d5609b48783",  
"context": \[  
{  
"type": "Error",  
"severity": "1",  
"reasonCode": "422",  
"component": "employees-ods-sys-api”,  
"timeStamp": "2023-04-20T14:46:59.131Z",  
"message": "Employee not found for employee Id = 000136222"  
}  
\]  
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

##### Update employee data via an employee Id

Update employee information using an employee Id

###### Resource Locators

- To update details on an employee:

PUT {BASE_URI}/v1/employees/{employeeId}

Type of Data Consumed:

application/json

###### Path Parameters: 

| Name       | Assignment/Description     | Example   |
|:-----------|:---------------------------|:----------|
| employeeId | Unique employee identifier | 000061149 |

###### Query Parameters: Does Not Apply

| Name | Assignment/Description | Example |
|:-----|:-----------------------|:--------|
|      |                        |         |

###### Http Header Parameters: 

| Name | Assignment/Description | Example |
|:---|:---|:---|
| tracing_id | Optionally sent in on request | ASY7748901 |
| X-Correlation-Id | If this element is present, assign it to correlationId variable, otherwise create a uuid and assign it to correlatioId | 23d10540-e316-11ed-8a7a-0205dd115db9 |

###### Request Payload: See the model repo for details

<table>
<colgroup>
<col style="width: 35%" />
<col style="width: 23%" />
<col style="width: 41%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Element Name</th>
<th style="text-align: left;">Required</th>
<th style="text-align: left;">Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;">employee</td>
<td style="text-align: center;">Y</td>
<td style="text-align: left;"></td>
</tr>
<tr>
<td style="text-align: left;">userId</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. psmith</p></td>
</tr>
<tr>
<td style="text-align: left;">isActive</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>boolean</p>
<p>Ex. true</p></td>
</tr>
<tr>
<td style="text-align: left;">employmentStatusCode</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. A</p></td>
</tr>
<tr>
<td style="text-align: left;">birthDate</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>date</p>
<p>Ex. 2000-09-08</p></td>
</tr>
<tr>
<td style="text-align: left;">ssnLastFour</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. 1124</p></td>
</tr>
<tr>
<td style="text-align: left;">distributionCenterDivisionId</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. GR260</p></td>
</tr>
<tr>
<td style="text-align: left;">division</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. McLane Business Info Services</p></td>
</tr>
<tr>
<td style="text-align: left;">costCenter</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. 20020</p></td>
</tr>
<tr>
<td style="text-align: left;">department</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. Platform Administration</p></td>
</tr>
<tr>
<td style="text-align: left;">managerId</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. 000028632</p></td>
</tr>
<tr>
<td style="text-align: left;">locationId</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. 999</p></td>
</tr>
<tr>
<td style="text-align: left;">companyName</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. McLane Company, Inc.</p></td>
</tr>
<tr>
<td style="text-align: left;">companyCode</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. 001</p></td>
</tr>
<tr>
<td style="text-align: left;">businessUnit</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. GR360</p></td>
</tr>
<tr>
<td style="text-align: left;">terminationDate</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>date</p>
<p>Ex. 2024-01-31</p></td>
</tr>
<tr>
<td style="text-align: left;">startDate</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>date</p>
<p>Ex. 2024-01-31</p></td>
</tr>
<tr>
<td style="text-align: left;">payGrade</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. L</p></td>
</tr>
<tr>
<td style="text-align: left;">flsaCode</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. V</p></td>
</tr>
<tr>
<td style="text-align: left;">compensationTypeCode</td>
<td style="text-align: center;">Y</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. S</p></td>
</tr>
<tr>
<td style="text-align: left;">extendedTimeOff</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"></td>
</tr>
<tr>
<td style="text-align: left;">startDate</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>date</p>
<p>EX. 2024-03-31</p></td>
</tr>
<tr>
<td style="text-align: left;">name</td>
<td style="text-align: center;"></td>
<td style="text-align: left;"></td>
</tr>
<tr>
<td style="text-align: left;">first</td>
<td style="text-align: center;">Y</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. Mary</p></td>
</tr>
<tr>
<td style="text-align: left;">middle</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. Sue</p></td>
</tr>
<tr>
<td style="text-align: left;">last</td>
<td style="text-align: center;">Y</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. Eliassen</p></td>
</tr>
<tr>
<td style="text-align: left;">job</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"></td>
</tr>
<tr>
<td style="text-align: left;">code</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. 1067</p></td>
</tr>
<tr>
<td style="text-align: left;">title</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. Stocker</p></td>
</tr>
<tr>
<td style="text-align: left;">familyCode</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. D</p></td>
</tr>
<tr>
<td style="text-align: left;">family</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. IT Platform</p></td>
</tr>
<tr>
<td style="text-align: left;">positionId</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. P001537</p></td>
</tr>
<tr>
<td style="text-align: left;">workAddress</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"></td>
</tr>
<tr>
<td style="text-align: left;">address1</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. 4747 McLane Parkway</p></td>
</tr>
<tr>
<td style="text-align: left;">city</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. Temple</p></td>
</tr>
<tr>
<td style="text-align: left;">state</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. TX</p></td>
</tr>
<tr>
<td style="text-align: left;">postalCode</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. 76504</p></td>
</tr>
</tbody>
</table>

Example:

PUT https://\<hostName\>/employees-ods-sys-api/v1/employees/000061149

Example request:

{  
"employee": {

"userId": "zernest",  
"activeCode": 1,  
"employmentStatusCode": "A",  
"birthDate": "2000-06-08",  
"ssnLastFour": "1123",  
"department": "Platform Administration",  
"distributionCenterDivisionId": "GR260",  
"division": "GR260 GR Concord",  
"costCenter": "20020",  
"managerId": "000028632",  
"locationId": "999",  
"companyCode": "001",  
"companyName": "McLane Company, Inc.",  
"businessUnit": "GR260",  
"terminationDate": null,

"startDate": "1997-06-08",  
"payGrade": "L",  
"flsaCode": "N",  
"compensationTypeCode": "S",  
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

###### Processing Summary

- Validation

- Interact with Employee ODS Oracle DB via SQL statements

- Prepare Response

###### Processing

####### Validation

- Validate using the API model to insure the presence of required fields
  and valid values

####### Interact with Employee ODS database

Invoke the stored procedure in the \<schema\>.UPDATEUSERBYID_SP

Where \<schema\> value is INTERIM_CODE externalized in a property file

**CALL**
INTERIM_CODE.UPDATEUSERBYID_SP(:EMPLID,:FIRST_NM,:MIDDLE_NM,:LAST_NM,:BIRTHDATE,:SSN,:DEPT_ID,:DEPT_NM,:JOB_CD,:JOB_NM,:JOB_FAM_CD,:JOB_FAM_NM,:POSITION_CD,:DIV_CD,:DIV_NM,:COMPANY_CD,:COMPANY_NM,:GRADE,:SUPERVISOR_ID,:EMPL_STATUS,:EMPL_TYPE,:BUSINESS_UNIT,:TERM_DT,:LOCATION,:ADDRESS,:CITY,:STATE,:ZIP,:LEAVE_EFF_DT,:FLSA_STATUS,:START_DT,:ACTIVE,:USER_ID);

<table style="width:100%;">
<colgroup>
<col style="width: 24%" />
<col style="width: 8%" />
<col style="width: 36%" />
<col style="width: 30%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Parameter Name</th>
<th style="text-align: left;">Parameter Type</th>
<th style="text-align: left;">Assignment/Description</th>
<th style="text-align: left;">Example</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><strong>EMPLID</strong></td>
<td style="text-align: center;">IN</td>
<td>employee.employeeId</td>
<td style="text-align: left;">000132731</td>
</tr>
<tr>
<td style="text-align: left;"><strong>FIRST_NM</strong></td>
<td style="text-align: center;">IN</td>
<td>employee.name.first</td>
<td style="text-align: left;">Pete</td>
</tr>
<tr>
<td style="text-align: left;"><strong>MIDDLE_NM</strong></td>
<td style="text-align: center;">IN</td>
<td>employee.name.middle</td>
<td style="text-align: left;">James</td>
</tr>
<tr>
<td style="text-align: left;"><strong>LAST_NM</strong></td>
<td style="text-align: center;">IN</td>
<td>employee.name.last</td>
<td style="text-align: left;">Lawler</td>
</tr>
<tr>
<td style="text-align: left;"><strong>BIRTHDATE</strong></td>
<td style="text-align: center;">IN</td>
<td><p>employee.birthDate</p>
<p>The date format can come in as in format DD-MON-YYYY or YYYY-MM-DD.
If the date formt comes in as YYYY-MM-DD, convert it to DD-MON-YYYY
format when assigning for the update</p></td>
<td style="text-align: left;">30-Jul-1980</td>
</tr>
<tr>
<td style="text-align: left;"><strong>SSN</strong></td>
<td style="text-align: center;">IN</td>
<td>employee.ssnLastFour</td>
<td style="text-align: left;">3321</td>
</tr>
<tr>
<td style="text-align: left;"><strong>DEPT_ID</strong></td>
<td style="text-align: center;">IN</td>
<td>employee.costCenter</td>
<td style="text-align: left;">20014</td>
</tr>
<tr>
<td style="text-align: left;"><strong>DEPT_NM</strong></td>
<td style="text-align: center;">IN</td>
<td>employee.department</td>
<td style="text-align: left;">Perishable/Refrigeration</td>
</tr>
<tr>
<td style="text-align: left;"><strong>JOB_CD</strong></td>
<td style="text-align: center;">IN</td>
<td>employee.job.code</td>
<td style="text-align: left;">1002</td>
</tr>
<tr>
<td style="text-align: left;"><strong>JOB_NM</strong></td>
<td style="text-align: center;">IN</td>
<td>employee.job.title</td>
<td style="text-align: left;">Checker/Loader IV</td>
</tr>
<tr>
<td style="text-align: left;"><strong>JOB_FAM_CD</strong></td>
<td style="text-align: center;">IN</td>
<td>employee.job.familyCode</td>
<td style="text-align: left;">Loaders</td>
</tr>
<tr>
<td style="text-align: left;"><strong>JOB_FAM_NM</strong></td>
<td style="text-align: center;">IN</td>
<td>employee.job.family</td>
<td style="text-align: left;">Loaders</td>
</tr>
<tr>
<td style="text-align: left;"><strong>POSITION_CD</strong></td>
<td style="text-align: center;">IN</td>
<td>employee.job.positionId</td>
<td style="text-align: left;">P016064</td>
</tr>
<tr>
<td style="text-align: left;"><strong>DIV_CD</strong></td>
<td style="text-align: center;">IN</td>
<td>employee.distributionCenterDivisionId</td>
<td style="text-align: left;">GR250</td>
</tr>
<tr>
<td style="text-align: left;"><strong>DIV_NM</strong></td>
<td style="text-align: center;">IN</td>
<td>employee.division</td>
<td style="text-align: left;">GR Suneast</td>
</tr>
<tr>
<td style="text-align: left;"><strong>COMPANY_CD</strong></td>
<td style="text-align: center;">IN</td>
<td>employee.companyCode</td>
<td style="text-align: left;">007</td>
</tr>
<tr>
<td style="text-align: left;"><strong>COMPANY_NM</strong></td>
<td style="text-align: center;">IN</td>
<td>employee.companyName</td>
<td style="text-align: left;">McLane Suneast, Inc.</td>
</tr>
<tr>
<td style="text-align: left;"><strong>GRADE</strong></td>
<td style="text-align: center;">IN</td>
<td>employee.payGrade</td>
<td style="text-align: left;">4</td>
</tr>
<tr>
<td style="text-align: left;"><strong>SUPERVISOR_ID</strong></td>
<td style="text-align: center;">IN</td>
<td>employee.managerId</td>
<td style="text-align: left;">000030137</td>
</tr>
<tr>
<td style="text-align: left;"><strong>EMPL_STATUS</strong></td>
<td style="text-align: center;">IN</td>
<td>employee.employmentStatusCode</td>
<td style="text-align: left;">A</td>
</tr>
<tr>
<td style="text-align: left;"><strong>EMPL_TYPE</strong></td>
<td style="text-align: center;">IN</td>
<td>employee.compensationTypeCode</td>
<td style="text-align: left;">H</td>
</tr>
<tr>
<td style="text-align: left;"><strong>BUSINESS_UNIT</strong></td>
<td style="text-align: center;">IN</td>
<td>employee.businessUnit</td>
<td style="text-align: left;">GR250</td>
</tr>
<tr>
<td style="text-align: left;"><strong>TERM_DT</strong></td>
<td style="text-align: center;">IN</td>
<td><p>employee.terminationDate</p>
<p>The date format can come in as in format DD-MON-YYYY or YYYY-MM-DD.
If the date formt comes in as YYYY-MM-DD, convert it to DD-MON-YYYY
format when assigning for the update</p></td>
<td style="text-align: left;">30-Jul-2003</td>
</tr>
<tr>
<td style="text-align: left;"><strong>LOCATION</strong></td>
<td style="text-align: center;">IN</td>
<td>employee.locationId</td>
<td style="text-align: left;">250</td>
</tr>
<tr>
<td style="text-align: left;"><strong>ADDRESS</strong></td>
<td style="text-align: center;">IN</td>
<td>employee.workAddress.address1</td>
<td style="text-align: left;">1818 Poinciana Blvd</td>
</tr>
<tr>
<td style="text-align: left;"><strong>CITY</strong></td>
<td style="text-align: center;">IN</td>
<td>employee.workAddress.city</td>
<td style="text-align: left;">Kissimmee</td>
</tr>
<tr>
<td style="text-align: left;"><strong>STATE</strong></td>
<td style="text-align: center;">IN</td>
<td>employee.workAddress.state</td>
<td style="text-align: left;">FL</td>
</tr>
<tr>
<td style="text-align: left;"><strong>ZIP</strong></td>
<td style="text-align: center;">IN</td>
<td>employee.workAddress.postalCode</td>
<td style="text-align: left;">34758</td>
</tr>
<tr>
<td style="text-align: left;"><strong>LEAVE_EFF_DT</strong></td>
<td style="text-align: center;">IN</td>
<td>employee.extendedTimeOff.startDate</td>
<td style="text-align: left;">30-Jul-2024</td>
</tr>
<tr>
<td style="text-align: left;"><strong>FLSA_STATUS</strong></td>
<td style="text-align: center;">IN</td>
<td>employee.flsaCode</td>
<td style="text-align: left;">N</td>
</tr>
<tr>
<td style="text-align: left;"><strong>START_DT</strong></td>
<td style="text-align: center;">IN</td>
<td><p>employee.startDate</p>
<p>The date format can come in as in format DD-MON-YYYY or YYYY-MM-DD.
If the date formt comes in as YYYY-MM-DD, convert it to DD-MON-YYYY
format when assigning for the update</p></td>
<td style="text-align: left;">30-Jan-2000</td>
</tr>
<tr>
<td style="text-align: left;"><strong>ACTIVE</strong></td>
<td style="text-align: center;">IN</td>
<td>If employee.isActive = true then 1 else 0</td>
<td style="text-align: left;">true</td>
</tr>
<tr>
<td style="text-align: left;"><strong>USER_ID</strong></td>
<td style="text-align: center;">IN</td>
<td>employee.userId</td>
<td style="text-align: left;">psmith</td>
</tr>
</tbody>
</table>

Example:

CALL INTERIM_CODE.UPDATEUSERBYID_SP(

employee.employeeId,

employee.name.first,

employee.name.middle,

employee.name.last,

employee.birthDate, --in format DD-MON-YYYY

employee.ssnLastFour,

employee.costCenter,

employee.department,

employee.job.code,

employee.job.title,

employee.job.familyCode,

employee.job.family,

employee.job.positionId,

employee.distributionCenterDivisionId,

employee.division,

employee.companyCode,

employee.companyName,

employee.payGrade,

employee.managerId,

employee.employmentStatusCode,

employee.compensationTypeCode,

employee.businessUnit,

employee.terminationDate, --in format DD-MON-YYYY

employee.locationId,

employee.workAddress.address1,

employee.workAddress.city,

employee.workAddress.state,

employee.workAddress.postalCode,

employee.extendedTimeOff.startDate, --in format DD-MON-YYYY

employee.flsaCode,

employee.startDate, --in format DD-MON-YYYY

1, --If employee.isActive = true then 1 else 0

employee.userId);

~~UPDATE INTERIM.MCL_ONBOARDING_AND_EMPL~~

~~SET FIRST_NM=employee.name.first~~

~~MIDDLE_NM=employee.name.middle~~

~~LAST_NM=employee.name.last~~

~~BIRTHDATE=employee.birthDate~~

~~SSN=employee.ssnLastFour~~

~~DEPT_ID=employee.costCenter~~

~~DEPT_NM=employee.department~~

~~JOB_CD=employee.job.code~~

~~JOB_NM=employee.job.title~~

~~JOB_FAM_CD=employee.job.familyCode~~

~~JOB_FAM_NM=employee.job.family~~

~~POSITION_CD=employee.job.positionId~~

~~DIV_CD=employee.distributionCenterDivisionId~~

~~DIV_NM=employee.division~~

~~COMPANY_CD=employee.companyCode~~

~~COMPANY_NM=employee.companyName~~

~~GRADE=employee.payGrade~~

~~SUPERVISOR_ID=employee.managerId~~

~~EMPL_STATUS=employee.status~~

~~EMPL_TYPE=employee.compensationType~~

~~BUSINESS_UNIT=employee.businessUnit~~

~~START_DT=employee.startDate~~

~~TERM_DT=employee.terminationDate~~

~~LOCATION=employee.locationId~~

~~ADDRESS=employee.workAddress.address1~~

~~CITY=employee.workAddress.city~~

~~STATE=employee.workAddress.state~~

~~ZIP=employee.workAddress.postalCode~~

~~LEAVE_EFF_DT=employee.extendedTimeOff.startDate~~

~~FLSA_STATUS=employee.flsaRegionalCode~~

~~WHERE EMPLID = \<employeeId\>~~

**Note**: If any of the incoming fields are null, or are not present in
the request, then exclude those elements from the update statement. If
the field is to be blanked out, it should arrive on the request as “”.

Externalize the schemaName in a property file used in the query by
placing the schema value in a property named: schemaName

The schemaName value can be found at: [\#Employee ODS Oracle
Environments:\|outline](#employee-ods-oracle-environments)

**Extension Configuration**: *(externalize into a property file)*

- Query Timeout: 15 *(queryTimeout)*

- Query Timeout Unit: Seconds *(queryTimeoutUnit)*

####### Prepare Response 

###### The Response requires the endpoint to return an image of the employee after the update was made

###### Response Payload: [\#Employee Detail Response Structure\|outline](#employee-detail-response-structure)

###### Logging Events:

\- At the start of the application

flowStep: "Flow Start"

\- Right before the Updating an Employee Row call

flowStep: " Update an Employee Row Request"

\- Right after the return of Updating an Employee Row call:

flowStep: " Update an Employee Row Response"

-At the End of the application

flowStep: "Flow End"

###### Error Processing

If the results set is empty (employee not found) then create an error
response and sent back to the caller.

-Set the following status elements in the response

status = 404

context.type = “Error”

> context.message = Employee not found for employee Id = {employeeId}
> from the path parameter}

Example:

{  
"correlationId": "979f3d3b-a04a-43d7-b55f-8d5609b48783",  
"tracingId": "abc55247",  
"title": "Resource Not Found",  
"status": 404,  
"instance":
"https://apim.mclaneco.com/employees-ods-sys-api/v1/employees/000136222",  
"requestId": "979f3d3b-a04a-43d7-b55f-8d5609b48783",  
"context": \[  
{  
"type": "Error",  
"severity": "1",  
"reasonCode": "422",  
"component": "employees-ods-sys-api”,  
"timeStamp": "2024-04-20T14:46:59.131Z",  
"message": "Employee not found for employee Id = 000136222"  
}  
\]  
}

If an issue/error are encountered, the specifics related to the error
are to be reported back on the response via our common error structure
along with the correlation Id and the tracing Id if provided. See [Error
Structure](#_Error_Structure)

Example:

{  
"correlationId": "979f3d3b-a04a-43d7-b55f-8d5609b48783",  
"tracingId": "abc55247",  
"title": "Resource Not Found",  
"status": 404,  
"instance":
"https://apim.mclaneco.com/employees-ods-sys-api/v1/employees/000136222",  
"requestId": "979f3d3b-a04a-43d7-b55f-8d5609b48783",  
"context": \[  
{  
"type": "Error",  
"severity": "1",  
"reasonCode": "422",  
"component": "employees-ods-sys-api”,  
"timeStamp": "2024-04-20T14:46:59.131Z",  
"message": "Employee not found for employee Id = 000136222"  
}  
\]  
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

##### Patch an employee for a given employee Id

Activate/deactivate an employee for an employee Id

###### Resource Locators

- To update the status of an employee:

PATCH {BASE_URI}/v1/employees/{employeeId}

Type of Data Consumed:

application/json

###### Path Parameters: 

| Name       | Assignment/Description     | Example   |
|:-----------|:---------------------------|:----------|
| employeeId | Unique employee identifier | 000061149 |

###### Query Parameters: Does Not Apply

| Name | Assignment/Description | Example |
|:-----|:-----------------------|:--------|
|      |                        |         |

###### Http Header Parameters: 

| Name | Assignment/Description | Example |
|:---|:---|:---|
| tracing_id | Optionally sent in on request | ASY7748901 |
| X-Correlation-Id | If this element is present, assign it to correlationId variable, otherwise create a uuid and assign it to correlatioId | 23d10540-e316-11ed-8a7a-0205dd115db9 |

###### Request Payload: See the model repo for details

<table>
<colgroup>
<col style="width: 35%" />
<col style="width: 23%" />
<col style="width: 41%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Element Name</th>
<th style="text-align: left;">Required</th>
<th style="text-align: left;">Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;">employee</td>
<td style="text-align: center;">Y</td>
<td style="text-align: left;"></td>
</tr>
<tr>
<td style="text-align: left;">status</td>
<td style="text-align: center;">Y</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. Terminated</p></td>
</tr>
</tbody>
</table>

Example:

PATCH https://\<hostName\>/employees-ods-sys-api/v1/employees/000061149

Example request:

{  
"employee": {  
"status": "Terminated"  
}  
}

###### Processing Summary

- Validation

- Interact with Employee ODS Oracle DB via SQL statements

- Prepare Response

###### Processing

####### Validation

- Validate using the API model to insure the presence of required fields
  and valid values

####### Interact with Employee Sync ODS database

~~UPDATE INTERIM.MCL_ONBOARDING_AND_EMPL~~

~~SET EMPL_STATUS=employee.status~~

~~WHERE EMPLID = \<employeeId\>~~

Invoke the stored procedure in the \<schema\>.UPDATEUSERSTATUSBYID_SP

Where \<schema\> value is INTERIM_CODE externalized in a property file

**CALL** INTERIM_CODE.UPDATEUSERSTATUSBYID_SP(**:EMPLID**,**:ACTIVE**);

| Parameter Name | Parameter Type | Assignment/Description | Example |
|:---|:--:|----|:---|
| **EMPLID** | IN | employee.employeeId | 000132731 |
| **ACTIVE** | IN | If employee.status= Active then 1 else 0 | 1 |

Example:

**CALL** INTERIM_CODE.UPDATEUSERSTATUSBYID_SP('000000333',0)

Externalize the schemaName in a property file used in the query by
placing the schema value in a property named: schemaName

The schemaName value can be found at: [\#Employee ODS Oracle
Environments:\|outline](#employee-ods-oracle-environments)

**Extension Configuration**: *(externalize into a property file)*

- Query Timeout: 15 *(queryTimeout)*

- Query Timeout Unit: Seconds *(queryTimeoutUnit)*

####### Prepare Response 

###### The Response requires the endpoint to return an image of the employee after the update was made

###### Response Payload: [\#Employee Detail Response Structure\|outline](#employee-detail-response-structure)

###### 

###### Logging Events:

\- At the start of the application

flowStep: "Flow Start"

\- Right before the Patching an Employee Row call

flowStep: " Patch an Employee Row Request"

\- Right after the return of Patching an Employee Row call:

flowStep: " Patch an Employee Row Response"

-At the End of the application

flowStep: "Flow End"

###### Error Processing

If the results set is empty (employee not found) then create an error
response and sent back to the caller.

-Set the following status elements in the response

status = 404

context.type = “Error”

> context.message = Employee not found for employee Id = {employeeId}
> from the path parameter}

Example:

{  
"correlationId": "979f3d3b-a04a-43d7-b55f-8d5609b48783",  
"tracingId": "abc55247",  
"title": "Resource Not Found",  
"status": 404,  
"instance":
"https://apim.mclaneco.com/employees-ods-sys-api/v1/employees/000136222",  
"requestId": "979f3d3b-a04a-43d7-b55f-8d5609b48783",  
"context": \[  
{  
"type": "Error",  
"severity": "1",  
"reasonCode": "422",  
"component": "employees-ods-sys-api”,  
"timeStamp": "2023-04-20T14:46:59.131Z",  
"message": "Employee not found for employee Id = 000136222"  
}  
\]  
}

Example:

{  
"correlationId": "979f3d3b-a04a-43d7-b55f-8d5609b48783",  
"tracingId": "abc55247",  
"title": "Resource Not Found",  
"status": 404,  
"instance":
"https://apim.mclaneco.com/employees-ods-sys-api/v1/employees/000136222",  
"requestId": "979f3d3b-a04a-43d7-b55f-8d5609b48783",  
"context": \[  
{  
"type": "Error",  
"severity": "1",  
"reasonCode": "422",  
"component": "employees-ods-sys-api”,  
"timeStamp": "2023-04-20T14:46:59.131Z",  
"message": "Employee not found for employee Id = 000136222"  
}  
\]  
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

##### Add a new employee

Add employee information

###### Resource Locators

- To add details on a new employee:

POST {BASE_URI}/v1/employees

Type of Data Consumed:

application/json

###### Path Parameters: Does Not Apply

| Name | Assignment/Description | Example |
|:-----|:-----------------------|:--------|
|      |                        |         |

###### Query Parameters: Does Not Apply

| Name | Assignment/Description | Example |
|:-----|:-----------------------|:--------|
|      |                        |         |

###### Http Header Parameters: 

| Name | Assignment/Description | Example |
|:---|:---|:---|
| tracing_id | Optionally sent in on request | ASY7748901 |
| X-Correlation-Id | If this element is present, assign it to correlationId variable, otherwise create a uuid and assign it to correlatioId | 23d10540-e316-11ed-8a7a-0205dd115db9 |

###### Request Payload: See the model repo for details

<table>
<colgroup>
<col style="width: 35%" />
<col style="width: 23%" />
<col style="width: 41%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Element Name</th>
<th style="text-align: left;">Required</th>
<th style="text-align: left;">Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;">employee</td>
<td style="text-align: center;">Y</td>
<td style="text-align: left;"></td>
</tr>
<tr>
<td style="text-align: left;">employeeId</td>
<td style="text-align: center;">Y</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. 000061149</p></td>
</tr>
<tr>
<td style="text-align: left;">userId</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. psmith</p></td>
</tr>
<tr>
<td style="text-align: left;">employmentStatusCode</td>
<td style="text-align: center;">Y</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. A</p></td>
</tr>
<tr>
<td style="text-align: left;">isActive</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>boolean</p>
<p>Ex. true</p></td>
</tr>
<tr>
<td style="text-align: left;">birthDate</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>date</p>
<p>Ex. 2000-09-08</p></td>
</tr>
<tr>
<td style="text-align: left;">ssnLastFour</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. 1124</p></td>
</tr>
<tr>
<td style="text-align: left;">distributionCenterDivisionId</td>
<td style="text-align: center;">Y</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. GR260</p></td>
</tr>
<tr>
<td style="text-align: left;">division</td>
<td style="text-align: center;">Y</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. McLane Business Info Services</p></td>
</tr>
<tr>
<td style="text-align: left;">costCenter</td>
<td style="text-align: center;">Y</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. 20020</p></td>
</tr>
<tr>
<td style="text-align: left;">department</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. "Platform Administration</p></td>
</tr>
<tr>
<td style="text-align: left;">managerId</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. 000028632</p></td>
</tr>
<tr>
<td style="text-align: left;">locationId</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. 999</p></td>
</tr>
<tr>
<td style="text-align: left;">companyCode</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. 001</p></td>
</tr>
<tr>
<td style="text-align: left;">companyName</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. McLane Company, Inc.</p></td>
</tr>
<tr>
<td style="text-align: left;">businessUnit</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. GR360</p></td>
</tr>
<tr>
<td style="text-align: left;">terminationDate</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>date</p>
<p>Ex. 2024-01-31</p></td>
</tr>
<tr>
<td style="text-align: left;">startDate</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>date</p>
<p>Ex. 2000-03-31</p></td>
</tr>
<tr>
<td style="text-align: left;">payGrade</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. L</p></td>
</tr>
<tr>
<td style="text-align: left;">flsaCode</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. N</p></td>
</tr>
<tr>
<td style="text-align: left;">compensationType</td>
<td style="text-align: center;">Y</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. Salary</p></td>
</tr>
<tr>
<td style="text-align: left;">extendedTimeOff</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"></td>
</tr>
<tr>
<td style="text-align: left;">startDate</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>date</p>
<p>EX. 2024-03-31</p></td>
</tr>
<tr>
<td style="text-align: left;">name</td>
<td style="text-align: center;"></td>
<td style="text-align: left;"></td>
</tr>
<tr>
<td style="text-align: left;">first</td>
<td style="text-align: center;">Y</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. Mary</p></td>
</tr>
<tr>
<td style="text-align: left;">middle</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. Sue</p></td>
</tr>
<tr>
<td style="text-align: left;">last</td>
<td style="text-align: center;">Y</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. Eliassen</p></td>
</tr>
<tr>
<td style="text-align: left;">job</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"></td>
</tr>
<tr>
<td style="text-align: left;">code</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. 1067</p></td>
</tr>
<tr>
<td style="text-align: left;">title</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. Driver</p></td>
</tr>
<tr>
<td style="text-align: left;">familyCode</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. D</p></td>
</tr>
<tr>
<td style="text-align: left;">family</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. IT Platform</p></td>
</tr>
<tr>
<td style="text-align: left;">positionId</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. P001537</p></td>
</tr>
<tr>
<td style="text-align: left;">workAddress</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"></td>
</tr>
<tr>
<td style="text-align: left;">address1</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. 4747 McLane Parkway</p></td>
</tr>
<tr>
<td style="text-align: left;">city</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. Temple</p></td>
</tr>
<tr>
<td style="text-align: left;">state</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. TX</p></td>
</tr>
<tr>
<td style="text-align: left;">postalCode</td>
<td style="text-align: center;">N</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. 76504</p></td>
</tr>
<tr>
<td style="text-align: left;"></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"></td>
</tr>
</tbody>
</table>

Example:

POST https://\<hostName\>/employees-ods-sys-api/v1/employees

Example request:

{  
"employee": {  
"employeeId": "000136214",

"userId": "zernest",  
"isActive": true,  
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

"businessUnit": "GR260",  
"terminationDate": null,

"startDate": "1997-06-08",  
"payGrade": "L",  
"flsaCode": "N",  
"compensationType\\": "Salary",  
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

###### Processing Summary

- Validation

- Interact with Employee ODS Oracle DB via SQL statements

- Prepare Response

###### Processing

####### Validation

- Validate using the API model to insure the presence of required fields
  and valid values

####### Interact with Employee ODS database

Insert into the MCL_ONBOARDING_AND_EMPL table using the stored procedure
\<schema\>. AddUser_SP

Where \<schema\> value is INTERIM_CODE externalized in a property file

**CALL**
INTERIM_CODE.AddUser_SP(**:EMPLID**,**:FIRST_NM**,**:MIDDLE_NM**,**:LAST_NM**,**:BIRTHDATE**,**:SSN**,**:DEPT_ID**,**:DEPT_NM**,**:JOB_CD**,**:JOB_NM**,**:JOB_FAM_CD**,**:JOB_FAM_NM**,**:POSITION_CD**,**:DIV_CD**,**:DIV_NM**,**:COMPANY_CD**,**:COMPANY_NM**,**:GRADE**,**:SUPERVISOR_ID**,**:EMPL_STATUS**,**:EMPL_TYPE**,**:BUSINESS_UNIT**,**:TERM_DT**,**:LOCATION**,**:ADDRESS**,**:CITY**,**:STATE**,**:ZIP**,**:LEAVE_EFF_DT**,**:FLSA_STATUS**,**:START_DT,:ACTIVE,:USER_ID.**);

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 41%" />
<col style="width: 38%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">DB Column Name/SP Parm</th>
<th style="text-align: left;">Assignment/Description</th>
<th style="text-align: left;">Example</th>
</tr>
</thead>
<tbody>
<tr>
<td>EMPLID</td>
<td>employee.employeeId</td>
<td>000000333</td>
</tr>
<tr>
<td>FIRST_NM</td>
<td>employee.name.first</td>
<td>Mary</td>
</tr>
<tr>
<td>MIDDLE_NM</td>
<td>employee.name.middle</td>
<td>Tammy</td>
</tr>
<tr>
<td>LAST_NM</td>
<td>employee.name.last</td>
<td>Schmidt</td>
</tr>
<tr>
<td>BIRTHDATE</td>
<td><p>employee.birthDate</p>
<p>The date format can come in as in format DD-MON-YYYY or YYYY-MM-DD.
If the date formt comes in as YYYY-MM-DD, convert it to DD-MON-YYYY
format when assigning for the insert</p></td>
<td>01-Sep-2001</td>
</tr>
<tr>
<td>SSN</td>
<td>mployee.ssnLastFour</td>
<td>1123</td>
</tr>
<tr>
<td>DEPT_ID</td>
<td>employee.costCenter</td>
<td>20020</td>
</tr>
<tr>
<td>DEPT_NM</td>
<td>employee.department</td>
<td style="text-align: left;">McLane Business Info Services</td>
</tr>
<tr>
<td>JOB_CD</td>
<td>employee.job.code</td>
<td>1067</td>
</tr>
<tr>
<td>JOB_NM</td>
<td>employee.job.title</td>
<td>Stocker</td>
</tr>
<tr>
<td>JOB_FAM_CD</td>
<td>employee.job.familyCode</td>
<td>D</td>
</tr>
<tr>
<td>JOB_FAM_NM</td>
<td>employee.job.family</td>
<td>IT Platform</td>
</tr>
<tr>
<td>POSITION_CD</td>
<td>employee.job.positionId</td>
<td>P001537</td>
</tr>
<tr>
<td>DIV_CD</td>
<td>employee.distributionCenterDivisionId</td>
<td>GR260</td>
</tr>
<tr>
<td>DIV_NM</td>
<td>employee.division</td>
<td>GR260 GR Concord</td>
</tr>
<tr>
<td>COMPANY_CD</td>
<td>employee.companyCode</td>
<td>001</td>
</tr>
<tr>
<td>COMPANY_NM</td>
<td>employee.companyName</td>
<td style="text-align: left;">McLane Company, Inc</td>
</tr>
<tr>
<td>GRADE</td>
<td>employee.payGrade</td>
<td></td>
</tr>
<tr>
<td>SUPERVISOR_ID</td>
<td>employee.managerId</td>
<td>000000111</td>
</tr>
<tr>
<td>EMPL_STATUS</td>
<td>employee.employmentStatusCode</td>
<td>A</td>
</tr>
<tr>
<td>EMPL_TYPE</td>
<td>employee.compensationTypeCode</td>
<td>Salary</td>
</tr>
<tr>
<td>BUSINESS_UNIT</td>
<td>employee.distributionCenterDivisionId</td>
<td></td>
</tr>
<tr>
<td>TERM_DT</td>
<td><p>employee.terminationDate</p>
<p>The date format can come in as in format DD-MON-YYYY or YYYY-MM-DD.
If the date formt comes in as YYYY-MM-DD, convert it to DD-MON-YYYY
format when assigning for the insert</p></td>
<td>01-Sep-2001</td>
</tr>
<tr>
<td>LOCATION</td>
<td>employee.locationId</td>
<td>999</td>
</tr>
<tr>
<td>ADDRESS</td>
<td>employee.workAddress.address1</td>
<td>123 Center Street</td>
</tr>
<tr>
<td>CITY</td>
<td>employee.workAddress.city</td>
<td>Derby</td>
</tr>
<tr>
<td>STATE</td>
<td>employee.state</td>
<td>NY</td>
</tr>
<tr>
<td>ZIP</td>
<td>employee.postalCode</td>
<td>14126</td>
</tr>
<tr>
<td>LEAVE_EFF_DT</td>
<td>employee.extendedTimeOff.startDate</td>
<td>01-Sep-2001</td>
</tr>
<tr>
<td>FLSA_STATUS</td>
<td>employee.flsaCode</td>
<td>N</td>
</tr>
<tr>
<td>START_DT</td>
<td><p>employee.​​​​startDate</p>
<p>The date format can come in as in format DD-MON-YYYY or YYYY-MM-DD.
If the date formt comes in as YYYY-MM-DD, convert it to DD-MON-YYYY
format when assigning for the insert</p></td>
<td>01-Sep-2001</td>
</tr>
<tr>
<td>ACTIVE</td>
<td>employee.​​​​isActive = true then 1 else 0</td>
<td>1</td>
</tr>
<tr>
<td>USER_ID</td>
<td>employee.userId</td>
<td>psmith</td>
</tr>
</tbody>
</table>

Example:

**CALL** INTERIM_CODE.ADDUSER_SP('000000333', 'Skip', 'Terry', 'Julip',
'08-Jun-2000', '1234', '20200', 'Platform Administration', '1067',
'Stocker', 'D', 'IT PLATFORM', 'P001537', 'GR260', 'GR260 GR Concord',
'001', 'McLane Company, Inc.', 'L', '000028632', '000000333', 'A', 'S',
'GR260', null, '999', '122 Center Street', 'Angola', 'NY', '14006',
'01-May-2024', 'N',null, 1, 'sjulip');

Example:

I~~NSERT INTO INTERIM.MCL_ONBOARDING_AND_EMPL~~

~~(EMPLID, ALTER_EMPLID, SM_OB_INVITN_ID, FIRST_NM, MIDDLE_NM, LAST_NM,
BIRTHDATE, SSN, DEPT_ID, DEPT_NM, JOB_CD, JOB_NM, DIV_CD, DIV_NM, DIV,
COMPANY_CD, COMPANY_NM, GRADE, RK, SUPERVISOR_ID, BADGE_NBR,
EMPL_STATUS, EMPL_TYPE, BUSINESS_UNIT, LAST_CHG_JOB_DT, TERM_DT,
LOCATION, ADDRESS, CITY, STATE, ZIP, LEAVE_EFF_DT, FLSA_STATUS)~~

~~VALUES('000000333', '000000333', 'SM_OB_INVITN_ID', 'Skip', 'Terry',
'Julip', '2000-06-08', '1234', 'DEPT_ID', '20020', '1067', 'Stocker',
'DIV_CD', 'GR260 GR Concord', 'DIV', 'COMPANYCD', 'McLane Company,
Inc.', 'L', 'RK', '000028632', '000000333', 'A', 'SAL', 'BUSINESS_UNIT',
'LAST_CHG_JOB_DT', null, '999', '122 Center Street', 'Angola', 'NY',
'14006', TIMESTAMP '2024-09-19 00:00:00.000000', 'A');~~

Externalize the schemaName in a property file used in the query by
placing the schema value in a property named: schemaName

The schemaName value can be found at: [\#Employee ODS Oracle
Environments:\|outline](#employee-ods-oracle-environments)

**Extension Configuration**: *(externalize into a property file)*

- Query Timeout: 15 *(queryTimeout)*

- Query Timeout Unit: Seconds *(queryTimeoutUnit)*

####### Prepare Response 

###### The Response requires the endpoint to return an image of the employee after the update was made

###### Response Payload: [\#Employee Detail Response Structure\|outline](#employee-detail-response-structure)

###### Logging Events:

\- At the start of the application

flowStep: "Flow Start"

\- Right before the Adding an Employee Row call

flowStep: "Add an Employee Row Request"

\- Right after the return of Adding an Employee Row call:

flowStep: " Add an Employee Row Response"

-At the End of the application

flowStep: "Flow End"

###### Error Processing

If an issue/error are encountered, the specifics related to the error
are to be reported back on the response via our common error structure
along with the correlation Id and the tracing Id if provided. See [Error
Structure](#_Error_Structure)

Example:

{  
"correlationId": "979f3d3b-a04a-43d7-b55f-8d5609b48783",  
"tracingId": "abc55247",  
"title": "Resource Not Found",  
"status": 404,  
"instance":
"https://apim.mclaneco.com/employees-ods-sys-api/v1/employees/000136222",  
"requestId": "979f3d3b-a04a-43d7-b55f-8d5609b48783",  
"context": \[  
{  
"type": "Error",  
"severity": "1",  
"reasonCode": "422",  
"component": "employees-ods-sys-api”,  
"timeStamp": "2023-04-20T14:46:59.131Z",  
"message": "Employee not found for employee Id = 000136222"  
}  
\]  
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

##### Get employees(Search)

Get employee list

###### Resource Locators

- To retrieve details for a collection of employees:

GET {BASE_URI}/v1/employees

Type of Data Consumed:

application/json

###### Path Parameters: Does Not Apply

| Name | Assignment/Description | Example |
|:-----|:-----------------------|:--------|
|      |                        |         |

###### Query Parameters: 

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 41%" />
<col style="width: 38%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Assignment/Description</th>
<th style="text-align: left;">Example</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;">offset</td>
<td style="text-align: left;">Optional, default is 0</td>
<td style="text-align: left;">0</td>
</tr>
<tr>
<td style="text-align: left;">limit</td>
<td style="text-align: left;">Value between 1 and 100, optional default
is 50</td>
<td style="text-align: left;">75</td>
</tr>
<tr>
<td style="text-align: left;">filter</td>
<td style="text-align: left;">URL encoded expression expression that
returns a boolean value-using the entity's fields to retrieve a subset
of the results</td>
<td style="text-align: left;"><p>employeeId eq 000013028 url encoded
value=</p>
<p>employeeId%20eq%20%22000013028%22</p></td>
</tr>
</tbody>
</table>

###### Http Header Parameters: 

| Name | Assignment/Description | Example |
|:---|:---|:---|
| tracing_id | Optionally sent in on request | ASY7748901 |
| X-Correlation-Id | If this element is present, assign it to correlationId variable, otherwise create a uuid and assign it to correlatioId | 23d10540-e316-11ed-8a7a-0205dd115db9 |

###### Request Payload: Does Not Apply

| Element Name | Required | Notes |
|:-------------|:--------:|:------|
|              |          |       |

Example:

GET
https://\<hostName\>/employees-ods-sys-api/v1/employees?employeeId%20eq%20%22000013028%22&offset=1&limit=100

Example request:

Does Not Apply

###### Processing Summary

- Validation

- Interact with Employee ODS Oracle DB via SQL statements

- Prepare Response

###### Processing

####### Validation

- Validate using the API model to insure the presence of required fields
  and valid values

####### Interact with Employee ODS database

~~Select \* from INTERIM.MCL_ONBOARDING_AND_EMPL OFFSET \<offset\> ROWS
FETCH NEXT \<limit\> ROWS ONLY;~~

If the filter query parameter is present as part of the request, URL
decode the value to get the employeeId that is to be assigned to the
EMPLID stored procedure input parameter. Remember after URL decoding to
remove the double quites that enclode the employeeId value.

For example: employeeId%20eq%20%22000013028%22 would result in an EMPLID
= 000013028

Invoke the stored procedure in the \<schema\>. GETUSERS_SP

Where \<schema\> value is INTERIM_CODE externalized in a property file

**CALL** INTERIM_CODE.GETUSERS_SP(resultsSet,:OFFSET,:LIMIT,:EMPLID);

<table>
<colgroup>
<col style="width: 16%" />
<col style="width: 16%" />
<col style="width: 34%" />
<col style="width: 31%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Stored Procedure Parameter</th>
<th style="text-align: left;">Parameter</th>
<th style="text-align: left;">Assignment/Description</th>
<th style="text-align: left;">Example</th>
</tr>
</thead>
<tbody>
<tr>
<td>resultsSet</td>
<td></td>
<td>Cursor containing the rows returned</td>
<td></td>
</tr>
<tr>
<td>OFFSET</td>
<td></td>
<td>offset query parameter, default to zero</td>
<td>5</td>
</tr>
<tr>
<td>LIMIT</td>
<td></td>
<td>limit query parameter, default to 20</td>
<td>20</td>
</tr>
<tr>
<td>EMPLID</td>
<td></td>
<td><p>employeeId that is passed in as part of the filter query
parameter</p>
<p>Ex. employeeId%20eq%20%22000013028%22</p></td>
<td>000013028</td>
</tr>
</tbody>
</table>

Example:

CALL INTERIM_CODE.GETUSERS_SP (resultsSet,5,10,000013028);

Externalize the schemaName in a property file used in the query by
placing the schema value in a property named: schemaName

The schemaName value can be found at: [EBS Oracle
Environments:](#_EBS_Oracle_Environments:)

**Extension Configuration**: *(externalize into a property file)*

- Query Timeout: 15 *(queryTimeout)*

- Query Timeout Unit: Seconds *(queryTimeoutUnit)*

####### Prepare Response 

###### Response Payload:

The response will be a collection of employees with each item defined
as:[\#Employee Detail Response
Structure\|outline](#employee-detail-response-structure)

Example Response:

{  
"correlationId": "d5ebd3b0-774e-11ed-aa7d-02d22cb5f8e0",  
"tracingId": "XYZ188978-001",  
"employees": \[  
{  
"employeeId": "000136214",

"userId": "zernest",  
"employmentStatusCode": "A",

"isActive": true,  
"birthDate": "2000-06-08",  
"ssnLastFour": "1123",  
"department": "Platform Administration",  
"distributionCenterDivisionId": "GR260",  
"division": "GR260 GR Concord",  
"costCenter": "20020",  
"managerId": "000028632",  
"locationId": "999",  
"companyCode": "001",  
"companyName": "McLane Company, Inc.",  
"businessUnit": "GR260",  
"terminationDate": null,

"startDate": "1997-06-08",  
"payGrade": "L",  
"flsaCode": "N",  
"compensationTypeCode": "S",

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
"family": "Driver",  
"positionId": "P001537"  
},  
"workAddress": {  
"address1": "4747 McLane Parkway",  
"city": "Temple",  
"state": "TX",  
"postalCode": "76504"  
}  
},  
{  
"employeeId": "000136222",  
"employmentStatusCode": "A",

"isActive": true,  
"birthDate": "2000-01-01",  
"ssnLastFour": "3231",  
"distributionCenterDivisionId": "GR370",  
"division": "GR370 GR Concord",  
"costCenter": "50020",  
"managerId": "000019643",  
"locationId": "999",  
"companyCode": "001",  
"companyName": "McLane Company, Inc.",

"businessUnit": "GR260",  
"terminationDate": null,

"startDate": "1997-06-08",  
"payGrade": "L",  
"flsaCode": "N",  
"compensationTypeCode": "S",  
"extendedTimeOff": {  
"startDate": null  
},  
"name": {  
"first": "Oscar",  
"middle": "E",  
"last": "Simpson"  
},  
"job": {  
"code": "1088",  
"title": "Stocker II",  
"familyCode": "D",  
"family": "Driver",  
"positionId": "P001537"  
},  
"workAddress": {  
"address1": "4747 McLane Parkway",  
"city": "Temple",  
"state": "TX",  
"postalCode": "76504"  
}  
}  
\]  
}

###### Logging Events:

\- At the start of the application

flowStep: "Flow Start"

\- Right before the Get Employee Rows call

flowStep: " Get Employee Rows Request"

\- Right after the return of Get Employee Rows call:

flowStep: " Get an Employee Rows Response"

-At the End of the application

flowStep: "Flow End"

###### Error Processing

If the results set is empty due to paging parameters (offset, and limit)
we should send back an empty employees collection with a 200 http status
code

If the results set is empty (employee not found) and the filter query
parameter was used, then create an error response and sent back to the
caller.

-Set the following status elements in the response

status = 400

context.type = “Error”

> context.message = Employee not found for employee Id = {employeeId}
> the path parameter}

Example:

{  
"correlationId": "979f3d3b-a04a-43d7-b55f-8d5609b48783",  
"tracingId": "abc55247",  
"title": "Bad Request",  
"status": 400,  
"instance":
"https://apim.mclaneco.com/employees-ods-sys-api/v1/employees?filter=userName=000136222",  
"requestId": "979f3d3b-a04a-43d7-b55f-8d5609b48783",  
"context": \[  
{  
"type": "Error",  
"severity": "1",  
"reasonCode": "422",  
"component": "employees-ods-sys-api”,  
"timeStamp": "2023-04-20T14:46:59.131Z",  
"message": "Employee not found for employee Id = 000136222"  
}  
\]  
}

If an issue/error are encountered, the specifics related to the error
are to be reported back on the response via our common error structure
along with the correlation Id and the tracing Id if provided. See [Error
Structure](#_Error_Structure)

Example:

{  
"correlationId": "979f3d3b-a04a-43d7-b55f-8d5609b48783",  
"tracingId": "abc55247",  
"title": "Resource Not Found",  
"status": 404,  
"instance":
"https://apim.mclaneco.com/employees-ods-sys-api/v1/employees/000136222",  
"requestId": "979f3d3b-a04a-43d7-b55f-8d5609b48783",  
"context": \[  
{  
"type": "Error",  
"severity": "1",  
"reasonCode": "422",  
"component": "employees-ods-sys-api”,  
"timeStamp": "2023-04-20T14:46:59.131Z",  
"message": "Employee not found for employee Id = 000136222"  
}  
\]  
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

##### Employee ODS Health Check 

This endpoint enables a health check ping to ensure the application, and
the database is up and running

###### Resource Locators

- To check on both the application health, as well as the supporting
  system availability

GET {BASE_URI}/v1/health

- Type of Data Consumed:

application/json

###### Path Parameters: Does Not Apply

| Name | Assignment/Description | Example |
|:-----|:-----------------------|:--------|
|      |                        |         |

###### Query Parameters: Does Not Apply

| Name | Assignment/Description | Example |
|:-----|:-----------------------|:--------|
|      |                        |         |

###### Http Request Parameters: 

| Name       | Assignment/Description | Example    |
|:-----------|:-----------------------|:-----------|
| tracing_id | Optional               | Z987yy54r3 |

###### Request Payload: Does Not Apply

| Element Name | Assignment | Notes |     |
|:-------------|:-----------|:------|:----|
|              |            |       |     |

Example:

GET https://\<host\>/employees-ods-sys-api/v1/health

###### Processing

Execute the following SQL Statement:

SELECT 1 FROM dual

**Connector Configuration**: *(externalize into a property file)*

- Query Timeout: 5 *(queryTimeout)*

- Query Timeout Unit: Seconds *(queryTimeoutUnit)*

-Return a 200 upon successful completion of the above SQL statement with
payload:

###### Response Payload: For Successful responses

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 40%" />
<col style="width: 38%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Element Name</th>
<th style="text-align: left;">Assignment</th>
<th style="text-align: left;">Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;">correlationId</td>
<td style="text-align: left;">correlationId</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. d5f6fbf8-6774-4a95-9b59-15348943abd4</p></td>
</tr>
<tr>
<td style="text-align: left;">tracingId</td>
<td style="text-align: left;">Optional tracing_id from the system API
request header, if present</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. A3345732</p></td>
</tr>
<tr>
<td style="text-align: left;">status</td>
<td style="text-align: left;">Constant “OK”</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. OK</p></td>
</tr>
<tr>
<td style="text-align: left;">apiName</td>
<td style="text-align: left;">app.name</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. employees-ods-sys-api</p></td>
</tr>
<tr>
<td style="text-align: left;">apiVersion</td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>string</p>
<p>Ex. v1</p></td>
</tr>
<tr>
<td style="text-align: left;">timestamp</td>
<td style="text-align: left;">now</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. 2022-07-18T16:55:46.678-05:00</p></td>
</tr>
<tr>
<td style="text-align: left;">dependencies</td>
<td style="text-align: left;">Object that contains the status</td>
<td style="text-align: left;"></td>
</tr>
<tr>
<td style="text-align: left;">name</td>
<td style="text-align: left;">Assign the constant “TMSHUB Delivery
Tracking”</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. Employee ODS</p></td>
</tr>
<tr>
<td style="text-align: left;">status</td>
<td style="text-align: left;">If successful assign the constant
“UP”</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. UP</p></td>
</tr>
</tbody>
</table>

Example:

{

"correlationId": "d5f6fbf8-6774-4a95-9b59-15348943abd4",

"tracingId": "A3345732",

"status": "OK",

"apiName": "empoyees-ods-sys-api",

"apiVersion": "v1",

"timestamp": "2022-07-18T16:55:46.678-05:00",

"dependencies": \[

{

"name": "Employee ODS",

"status": "UP"

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
<th style="text-align: left;">Element Name</th>
<th style="text-align: left;">Assignment</th>
<th style="text-align: left;">Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;">correlationId</td>
<td style="text-align: left;">correlationId</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. d5f6fbf8-6774-4a95-9b59-15348943abd4</p></td>
</tr>
<tr>
<td style="text-align: left;">tracingId</td>
<td style="text-align: left;">tracing_id from the system API request
header, if present</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. A3345732</p></td>
</tr>
<tr>
<td style="text-align: left;"><strong>status</strong></td>
<td style="text-align: left;"></td>
<td style="text-align: left;">Object that holds processing status
context</td>
</tr>
<tr>
<td style="text-align: left;">code</td>
<td style="text-align: left;">Response code</td>
<td style="text-align: left;"></td>
</tr>
<tr>
<td style="text-align: left;"><strong>messages</strong></td>
<td style="text-align: left;"></td>
<td style="text-align: left;">Object that holds the collection of
diagnostic information</td>
</tr>
<tr>
<td style="text-align: left;">type</td>
<td style="text-align: left;">“Error”</td>
<td style="text-align: left;">string</td>
</tr>
<tr>
<td style="text-align: left;">severity</td>
<td style="text-align: left;"></td>
<td style="text-align: left;">string</td>
</tr>
<tr>
<td style="text-align: left;">reasonCode</td>
<td style="text-align: left;">Sql code if available</td>
<td style="text-align: left;">string</td>
</tr>
<tr>
<td style="text-align: left;">message</td>
<td style="text-align: left;">Error message text</td>
<td style="text-align: left;">string</td>
</tr>
<tr>
<td style="text-align: left;">context</td>
<td style="text-align: left;">app.name</td>
<td style="text-align: left;">string</td>
</tr>
<tr>
<td style="text-align: left;">timeStamp</td>
<td style="text-align: left;">Current date &amp; time</td>
<td style="text-align: left;">string</td>
</tr>
</tbody>
</table>

Example:

{

"correlationId": "d5f6fbf8-6774-4a95-9b59-15348943abd4",

"tracingId": "A19283745",

"status": {

"code": "500",

"messages": \[

{

"type": "Error",

"severity": "1",

"reasonCode": "40613",

"message": "Database mydb on server mydbserver is not currently
available",

"context": "ebs-employees-sys-api-tst,

"timeStamp": "2022-09-30T15:27:49.274Z"

}

\]

}

}

###### HTTP Status Codes

Possible HTTP status codes for the response include:

- 200 Request accepted

- 401 Unauthorized - for errors in API authentication

- 403 Forbidden - for errors in API authorization

- 500 Internal Server Error - for unexpected failures

###### Non Functional Requirements

####### Security – Does Not Apply

####### Availability

- *99.99% uptime 24x7*

####### Reliability

- High availability via multiple workers

####### Traceability

- Transaction tracing via log data to Splunk

- Specific Auditing requirements: Does Not Apply

####### Throughput – Does Not Apply

####### Response Time

- Target times for average or maximum response times, expressed as a
  percentile: 95% within 1 second(s).

# Appendix

## Employee ODS Oracle Environments:

| Environment | Host                       | Schema  | Service Name    | Port |
|:------------|:---------------------------|:--------|:----------------|:-----|
| Development | lddscexa-scan.mclaneco.com | INTERIM | WDTOPS_WDTOPST1 | 1521 |
| Test        | lddscexa-scan.mclaneco.com | INTERIM | WDTOPS_WDTOPST1 | 1521 |
| Production  | lpdstexa-scan.mclaneco.com | INTERIM | WDTOPS_WDTOPSP  | 1521 |

## Error Structure

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 40%" />
<col style="width: 38%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Element Name</th>
<th style="text-align: left;">Assignment</th>
<th style="text-align: left;">Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;">correlationId</td>
<td style="text-align: left;">correlationId</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. d5f6fbf8-6774-4a95-9b59-15348943abd4</p></td>
</tr>
<tr>
<td style="text-align: left;">tracingId</td>
<td style="text-align: left;">tracing_id from the system API request
header, if present</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. A3345732</p></td>
</tr>
<tr>
<td style="text-align: left;">title</td>
<td style="text-align: left;"><p>If http status is:</p>
<p>400=Bad Request</p>
<p>401=Unauthorized</p>
<p>403=Forbidden</p>
<p>404=Resource Not Found</p>
<p>405=Method Not Allowed</p>
<p>406=Not Acceptable</p>
<p>429=Too Many Requests</p>
<p>3xx: Redirection</p>
<p>5xx: Unexpected error</p></td>
<td style="text-align: left;">Short human-readable title of the error
that occurred</td>
</tr>
<tr>
<td style="text-align: left;">status</td>
<td style="text-align: left;">Http status code</td>
<td style="text-align: left;">holds processing status code</td>
</tr>
<tr>
<td style="text-align: left;">instance</td>
<td style="text-align: left;">The called url that experienced the
issue</td>
<td style="text-align: left;">Ex.
https://apim.mclaneco.com/ebs-customers-sys-api/v1/customers/sites?phoneNumber=5857732431</td>
</tr>
<tr>
<td style="text-align: left;">requestId</td>
<td style="text-align: left;">correlationId</td>
<td style="text-align: left;">Id that correlates original request to
response and other events in the API</td>
</tr>
<tr>
<td style="text-align: left;"><strong>context</strong></td>
<td style="text-align: left;"></td>
<td style="text-align: left;">Object that holds the collection of
diagnostic information</td>
</tr>
<tr>
<td style="text-align: left;">type</td>
<td style="text-align: left;">“Error”</td>
<td style="text-align: left;">string</td>
</tr>
<tr>
<td style="text-align: left;">severity</td>
<td style="text-align: left;">Optional designation of the criticality of
the error</td>
<td style="text-align: left;"><p>1=High</p>
<p>2=Medium</p>
<p>3=Low</p></td>
</tr>
<tr>
<td style="text-align: left;">reasonCode</td>
<td style="text-align: left;">Application return code if available</td>
<td style="text-align: left;">string, Ex.. 422</td>
</tr>
<tr>
<td style="text-align: left;">message</td>
<td style="text-align: left;">Error message text</td>
<td style="text-align: left;">string</td>
</tr>
<tr>
<td style="text-align: left;">component</td>
<td style="text-align: left;">Application name</td>
<td style="text-align: left;">string, EX. trimble-shipments-sys-api</td>
</tr>
<tr>
<td style="text-align: left;">timeStamp</td>
<td style="text-align: left;">Current date &amp; time</td>
<td style="text-align: left;">string</td>
</tr>
</tbody>
</table>

Example:

{  
"correlationId": "979f3d3b-a04a-43d7-b55f-8d5609b48783",  
"tracingId": "abc55247",  
"title": "Bad Data",  
"status": 400,  
"instance":
"https://apim.mclaneco.com/prc/tracking-shipments/v1/shipments/MC0109MS20230731/positions",  
"requestId": "979f3d3b-a04a-43d7-b55f-8d5609b48783",  
"context": \[  
{  
"type": "Error",  
"severity": "1",  
"reasonCode": "422",  
"component": "trimble-shipments-sys-api",  
"timeStamp": "2023-04-20T14:46:59.131Z",  
"message": "HTTP POST on resource
'https://apim.mclaneco.com:443/prc/tracking-shipments/v1/shipments/MC0109MS20230731/positions'
failed: bad request (400)."  
}  
\]  
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
<th style="text-align: left;">Element Name</th>
<th style="text-align: left;">Assignment</th>
<th style="text-align: left;">Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;">correlationId</td>
<td style="text-align: left;">correlationId</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. d5f6fbf8-6774-4a95-9b59-15348943abd4</p></td>
</tr>
<tr>
<td style="text-align: left;">tracingId</td>
<td style="text-align: left;">tracing_id from the system API request
header, if present</td>
<td style="text-align: left;">Ex. A3345732</td>
</tr>
<tr>
<td style="text-align: left;">clientId</td>
<td style="text-align: left;"></td>
<td style="text-align: left;">Ex. c9feb3160f0b4ea785875ad678e00c1c</td>
</tr>
<tr>
<td style="text-align: left;">appName</td>
<td style="text-align: left;"></td>
<td style="text-align: left;">Ex. mfdb2-sales-sys-api-1</td>
</tr>
<tr>
<td style="text-align: left;">flowName</td>
<td style="text-align: left;"></td>
<td style="text-align: left;">Ex. mfdb2-sales-sys-api-main</td>
</tr>
<tr>
<td style="text-align: left;">flowStep</td>
<td style="text-align: left;"></td>
<td style="text-align: left;">Ex. Flow End</td>
</tr>
<tr>
<td style="text-align: left;">timestamp</td>
<td style="text-align: left;">Current date &amp; time</td>
<td style="text-align: left;">Ex. 2023-04-25T03:06:16.405Z</td>
</tr>
<tr>
<td style="text-align: left;">environment</td>
<td style="text-align: left;">DEV,TEST, PROD</td>
<td style="text-align: left;">Based on the environment we are running
in</td>
</tr>
<tr>
<td style="text-align: left;">payload</td>
<td style="text-align: left;">If log level is DEBUG add the payload</td>
<td style="text-align: left;"></td>
</tr>
<tr>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
</tbody>
</table>

Example:

{  
"appName": "mcl-b2bi-files-sys-api-1",  
"clientId": "c9feb3160f0b4ea785875ad678e00c1c",  
"correlationId": "23d10540-e316-11ed-8a7a-0205dd115db9",  
"tracingId": "A23778-01",  
"flowName": "ebs-employees-sys-api-main",  
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

## Employee Detail Response Structure

### Interact with Employee ODS database

Invoke the stored procedure in the \<schema\>. GETUSERS_SP

Where \<schema\> value is INTERIM_CODE externalized in a property file

**CALL** INTERIM_CODE.GETUSERS_SP(resultsSet,:OFFSET,:LIMIT,:EMPLID);

<table>
<colgroup>
<col style="width: 16%" />
<col style="width: 16%" />
<col style="width: 34%" />
<col style="width: 31%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Stored Procedure Parameter</th>
<th style="text-align: left;">Parameter</th>
<th style="text-align: left;">Assignment/Description</th>
<th style="text-align: left;">Example</th>
</tr>
</thead>
<tbody>
<tr>
<td>resultsSet</td>
<td></td>
<td>Cursor containing the rows returned</td>
<td></td>
</tr>
<tr>
<td>OFFSET</td>
<td></td>
<td>offset query parameter, default to zero</td>
<td>5</td>
</tr>
<tr>
<td>LIMIT</td>
<td></td>
<td>limit query parameter, default to 20</td>
<td>20</td>
</tr>
<tr>
<td>EMPLID</td>
<td></td>
<td><p>employeeId that is passed in as part of the filter query
parameter</p>
<p>Ex. employeeId eq 000014527</p>
<p>OR</p>
<p>the employeeId query parameter</p></td>
<td>000014527</td>
</tr>
</tbody>
</table>

Example:

CALL INTERIM_CODE.GETUSERS_SP (resultsSet,5,10,000014527);

Results set Cursor Mapping

| Results Set Position | Field           |
|----------------------|-----------------|
| 1                    | EMPLID          |
| 2                    | FIRST_NM        |
| 3                    | MIDDLE_NM       |
| 4                    | LAST_NM         |
| 5                    | BIRTHDATE       |
| 6                    | SSN             |
| 7                    | DEPT_ID         |
| 8                    | DEPT_NM         |
| 9                    | JOB_CD          |
| 10                   | JOB_NM          |
| 11                   | JOB_FAM_CD      |
| 12                   | JOB_FAM_NM      |
| 13                   | POSITION_CD     |
| 14                   | DIV_CD          |
| 15                   | DIV_NM          |
| 16                   | COMPANY_CD      |
| 17                   | COMPANY_NM      |
| 18                   | GRADE           |
| 19                   | SUPERVISOR_ID   |
| 20                   | EMPL_STATUS     |
| 21                   | EMPL_TYPE       |
| 22                   | BUSINESS_UNIT   |
| 23                   | TERM_DT         |
| 24                   | LOCATION        |
| 25                   | ADDRESS         |
| 26                   | CITY            |
| 27                   | STATE           |
| 28                   | ZIP             |
| 29                   | LEAVE_EFF_DT    |
| 30                   | FLSA_STATUS     |
| 31                   | START_DT        |
| 32                   | ACTIVE          |
| 33                   | USER_ID         |
| 34                   | ROWMODIFIEDDATE |

Externalize the schemaName in a property file used in the query by
placing the schema value in a property named: schemaName

The schemaName value can be found at: [EBS Oracle
Environments:](#_EBS_Oracle_Environments:)

**Extension Configuration**: *(externalize into a property file)*

- Query Timeout: 15 *(queryTimeout)*

- Query Timeout Unit: Seconds *(queryTimeoutUnit)*

### Prepare Response 

### Response Payload: 

\*\*See model repo for more details

<table>
<colgroup>
<col style="width: 40%" />
<col style="width: 33%" />
<col style="width: 26%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Element Name</th>
<th style="text-align: left;">Assignment</th>
<th style="text-align: left;">Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;">correlationId</td>
<td style="text-align: left;">correlationId</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. ae8c5b85-97e0-4f55-80e7-6161d67220ae</p></td>
</tr>
<tr>
<td style="text-align: left;">tracingId</td>
<td style="text-align: left;">Optional tracing_Id from the system API
request header</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. A19283745</p></td>
</tr>
<tr>
<td style="text-align: left;">employee</td>
<td style="text-align: left;">Object that holds the employee data</td>
<td style="text-align: left;"></td>
</tr>
<tr>
<td style="text-align: left;">employeeId</td>
<td style="text-align: left;">EMPLID from the results set</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. 000061149</p></td>
</tr>
<tr>
<td style="text-align: left;">userId</td>
<td style="text-align: left;">USER_ID from the results set</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. tsmith</p></td>
</tr>
<tr>
<td style="text-align: left;">employmentStatusCode</td>
<td style="text-align: left;">EMPL_STATUS from the results set</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. A</p></td>
</tr>
<tr>
<td style="text-align: left;">isActive</td>
<td style="text-align: left;">If ACTIVE from the results set = 1 then
true, otherwise false</td>
<td style="text-align: left;"><p>boolean</p>
<p>Ex. true</p></td>
</tr>
<tr>
<td style="text-align: left;">birthDate</td>
<td style="text-align: left;">BIRTHDATE from the results set</td>
<td style="text-align: left;"><p>date</p>
<p>Ex. 2000-09-08</p></td>
</tr>
<tr>
<td style="text-align: left;">ssnLastFour</td>
<td style="text-align: left;">SSN from the results set</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. 1124</p></td>
</tr>
<tr>
<td style="text-align: left;">distributionCenterDivisionId</td>
<td style="text-align: left;">DIV_CD from the results set</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. GR260</p></td>
</tr>
<tr>
<td style="text-align: left;">division</td>
<td style="text-align: left;">DIV_NM from the results set</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. McLane Business Info Services</p></td>
</tr>
<tr>
<td style="text-align: left;">costCenter</td>
<td style="text-align: left;">DEPT_ID from the results set</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. 20020</p></td>
</tr>
<tr>
<td style="text-align: left;">department</td>
<td style="text-align: left;"><p>DEPT_NM</p>
<p>from the results set</p></td>
<td style="text-align: left;"><p>string</p>
<p>Ex. Platform Administration</p></td>
</tr>
<tr>
<td style="text-align: left;">managerId</td>
<td style="text-align: left;">SUPERVISOR_ID from the results set</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. 000028632</p></td>
</tr>
<tr>
<td style="text-align: left;">locationId</td>
<td style="text-align: left;">LOCATION from the results set</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. 999</p></td>
</tr>
<tr>
<td style="text-align: left;">companyName</td>
<td style="text-align: left;">COMPANY_NM from the results set</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. McLane Company, Inc.</p></td>
</tr>
<tr>
<td style="text-align: left;">companyCode</td>
<td style="text-align: left;">COMPANY_CD from the results set</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. 001</p></td>
</tr>
<tr>
<td style="text-align: left;">businessUnit</td>
<td style="text-align: left;">BUSINESS_UNIT from the results set</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. GR360</p></td>
</tr>
<tr>
<td style="text-align: left;">terminationDate</td>
<td style="text-align: left;">TERM_DT from the results set</td>
<td style="text-align: left;"><p>date</p>
<p>Ex. 2024-01-31</p></td>
</tr>
<tr>
<td style="text-align: left;">startDate</td>
<td style="text-align: left;">START_DT from the results set</td>
<td style="text-align: left;"><p>date</p>
<p>EX. 2024-03-31</p></td>
</tr>
<tr>
<td style="text-align: left;">payGrade</td>
<td style="text-align: left;">GRADE from the results set</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. L</p></td>
</tr>
<tr>
<td style="text-align: left;">flsaCode</td>
<td style="text-align: left;">FLSA_STATUS from the results set</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. N</p></td>
</tr>
<tr>
<td style="text-align: left;">compensationTypeCode</td>
<td style="text-align: left;">EMPL_TYPE from the results set</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. S</p></td>
</tr>
<tr>
<td style="text-align: left;">businessUnit</td>
<td style="text-align: left;">BUSINESS_UNIT from the results set</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. GR360</p></td>
</tr>
<tr>
<td style="text-align: left;">lastModifiedDateTime</td>
<td style="text-align: left;">ROWMODIFIEDDATE from the results set</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. 2024-08-16T19:41:53Z</p></td>
</tr>
<tr>
<td style="text-align: left;">extendedTimeOff</td>
<td style="text-align: left;">Object that holds the extended leave
information</td>
<td style="text-align: left;"></td>
</tr>
<tr>
<td style="text-align: left;">startDate</td>
<td style="text-align: left;">LEAVE_EFF_DT from the results set</td>
<td style="text-align: left;"><p>date</p>
<p>EX. 2024-03-31</p></td>
</tr>
<tr>
<td style="text-align: left;">name</td>
<td style="text-align: left;">Employee name parent element</td>
<td style="text-align: left;"></td>
</tr>
<tr>
<td style="text-align: left;">first</td>
<td style="text-align: left;">FIRST_NM from the results set</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. Mary</p></td>
</tr>
<tr>
<td style="text-align: left;">middle</td>
<td style="text-align: left;">MIDDLE_NM from the results set</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. Sue</p></td>
</tr>
<tr>
<td style="text-align: left;">last</td>
<td style="text-align: left;">LAST_NM from the results set</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. Eliassen</p></td>
</tr>
<tr>
<td style="text-align: left;">job</td>
<td style="text-align: left;">Job parent element</td>
<td style="text-align: left;"></td>
</tr>
<tr>
<td style="text-align: left;">code</td>
<td style="text-align: left;">JOB_CD from the results set</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. 1067</p></td>
</tr>
<tr>
<td style="text-align: left;">title</td>
<td style="text-align: left;">JOB_NM from the results set</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. L</p></td>
</tr>
<tr>
<td style="text-align: left;">familyCode</td>
<td style="text-align: left;">JOB_FAM_CD from the results set</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. D</p></td>
</tr>
<tr>
<td style="text-align: left;">family</td>
<td style="text-align: left;">JOB_FAM_NM from the results set</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. Driver</p></td>
</tr>
<tr>
<td style="text-align: left;">positionId</td>
<td style="text-align: left;"><p>POSITION_CD</p>
<p>from the results set</p></td>
<td style="text-align: left;"><p>string</p>
<p>Ex. P001537</p></td>
</tr>
<tr>
<td style="text-align: left;">workAddress</td>
<td style="text-align: left;">Work Address parent element</td>
<td style="text-align: left;"></td>
</tr>
<tr>
<td style="text-align: left;">address1</td>
<td style="text-align: left;">ADDRESS from the results set</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. 4747 McLane Parkway</p></td>
</tr>
<tr>
<td style="text-align: left;">city</td>
<td style="text-align: left;">CITY from the results set</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. Temple</p></td>
</tr>
<tr>
<td style="text-align: left;">state</td>
<td style="text-align: left;">STATE from the results set</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. TX</p></td>
</tr>
<tr>
<td style="text-align: left;">postalCode</td>
<td style="text-align: left;">ZIP from the results set</td>
<td style="text-align: left;"><p>string</p>
<p>Ex. 76504</p></td>
</tr>
</tbody>
</table>

Example:

{  
"correlationId": "d5ebd3b0-774e-11ed-aa7d-02d22cb5f8e0",  
"tracingId": "XYZ188978-001",  
"employee": {  
"employeeId": "000136214",

"userId": "zernest",  
"isActive": true,  
"employeementStatusCode": "A",  
"birthDate": "2000-06-08",  
"ssnLastFour": "1123",  
"department": "Platform Administration",  
"distributionCenterDivisionId": "GR260",  
"division": "GR260 GR Concord",  
"costCenter": "20020",  
"managerId": "000028632",  
"locationId": "999",  
"companyCode": "001",  
"companyName": "McLane Company, Inc.",  
"businessUnit": "GR260",  
"terminationDate": null,

"startDate": "2022-07-08",  
"payGrade": "L",  
"flsaCode": "N",  
"compensationTypeCode": "S",

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
"family": "Driver",  
"positionId": "P001537"  
},  
"workAddress": {  
"address1": "4747 McLane Parkway",  
"city": "Temple",  
"state": "TX",  
"postalCode": "76504"  
}  
}

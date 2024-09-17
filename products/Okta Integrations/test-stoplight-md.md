# test-stoplight-md

v1.0

November 18, 2022

## Table of Contents 

## History Of Changes

|             |            |                                                                                   |            |
|-------------|------------|-----------------------------------------------------------------------------------|------------|
| **Version** | **Author** | **Reason for change**                                                             | **Date**   |
| 1.0         | J Sack     | Initial                                                                           | 11/18/2022 |
| 1.1         |            | Add Egencia processing                                                            | 01/12/2023 |
| 1.2         |            | More Egencia processing                                                           | 01/25/2023 |
| 1.3         |            | Add division to travel group cross walk for teammates with noreply emails address | 02/01/2023 |
| 1.4         |            | Add Supervisor Sync processing                                                    | 03/08/2023 |
|             |            |                                                                                   |            |

# Purpose 

This document provides specifics that describes the application that is
to be used to orchestrate the processing of employee based events. This
application will receive a MQSeries message and use the payload of the
message to identify, and then orchestrate any API calls required to
facilitate the processing, and eventual consumption of the employee
event.

# Taxonomy

**zDirectory**: An application used to support claim hold triggered by
litigation.

**HCM**: Human Capital Management system which is PeopleSoft

**Active Directory**: System of record for employee account information

**Buyers Quest**: Enterprise corporate procurement application

**B2BI**: McLane’s application for handling bulk data

**Egencia**: McLane’s travel agency application

**Shiftboard**: Cloud application to support distribution center shift
management
# Solution Overview

## Process Context


## Logical Viewpoint

![image1.png](../assets/images/image1.png)

## Deployment Viewpoint

![image.3.PNG](../assets/images/image.3.PNG)

# Process

## Employee Event Synchronization

Employee events synchronization orchestration strives to make employee
events consumable by interested applications. This typically required
data enrichment, process step orchestration, format ,mediation, and
delivery over various protocols.

Initially, this application is to be built to support the following:

- Address book synchronization with the zDiscovery application used to
  support litigation claim holds.

- Terminated employees to Buyers Quest

- Employee synchronization with the Egencia travel agency application

- Employee supervisor processing in Shiftbord

## Functional Design

### Resources

#### Employee Event Synchronization

This application will be responsible for the orchestration of the
required processing, and mediation steps to insure that employee event
information is prepared, and presented to downstream applications for
their consumption. This processing will be triggered by details obtained
from the payload of a message from a MQSeries queue.

##### Project Names:

OAS: Does Not Apply

OpenShift Project: employee-events-sync-prc-app

##### Policies

- Not at this time

##### Resource Locators

- To receive unsolicited requests to synchronize employee information:

Input Queue: *MSOFT.PRC.EMPLOYEE.EVENTS.SYNC.REQ*

- Type of Data Consumed: application/json

##### IBM MQ Connector Configuration***:*** 

[***IBM MQ Connector
Configuration***](#ibm-mq-connector-configuration-1)

##### Processing 

###### Processing Structure:

Right after the On New Message source component, wrap any “loose”
components on the palette in a try block and place any related special
error processing in the “Error handling“/“Catch” section. In our case,
we would like to log the error, but in the future, we may want to store
the original message in a queue for later use.

The main reason for doing this is to prevent a poison message situation
where upon failure, the message rolls back to the input queue, and then
picked up again for processing placing us in a loop.

The main “Error handling”/”Catch” section should contain an On Error
Continue component to catch ANY type of error and should simply just log
the error details as well as the payload. The key thing about this

In General the flow template should look like so:

![image4.png](../assets/images/image4.png)

###### Summary

- Receive the request via a MQ Message

- Validate the payload received from the message

- If eventAction=AddressbookSync

Prepare and make a call to the Active Directory system Api

Prepare and make a call to the zDiscovery system Api

Prepare and make a call to the EBS Employee system Api (Egencia)

- If eventAction=Termination

Prepare and make a call to the B2BI files system Api

- If eventAction=SupervisorSync

Prepare and make a call to the HCM Shift Management process Api

- Log the result/response from the API call

###### Receive the request

###### IBM MQ On New Message Component Configuration: 

[\#IBM MQ Employee Events Sync On Message Queue
Configuration\|outline](#ibm-mq-employee-events-sync-on-message-queue-configuration)

###### MQMD Parameters: Does Not Apply

|      |                        |         |
|------|------------------------|---------|
| Name | Assignment/Description | Example |
|      |                        |         |
|      |                        |         |

###### Request Payload: 

<table>
<colgroup>
<col style="width: 30%" />
<col style="width: 11%" />
<col style="width: 57%" />
</colgroup>
<tbody>
<tr class="odd">
<td>Element Name</td>
<td>Required</td>
<td>Notes</td>
</tr>
<tr class="even">
<td>correlationId</td>
<td>N</td>
<td><p>string</p>
<p>Ex. ae8c5b85-97e0-4f55-80e7-6161d67220ae</p></td>
</tr>
<tr class="odd">
<td>tracingId</td>
<td>N</td>
<td><p>string</p>
<p>Ex. A19283745</p></td>
</tr>
<tr class="even">
<td>timeStamp</td>
<td>Y</td>
<td>datetime, Ex. 2022-11-04T14:42:19.74Z</td>
</tr>
<tr class="odd">
<td>eventAction</td>
<td>Y</td>
<td><p>string</p>
<p><strong>Valid Values</strong>:</p>
<p>Addition</p>
<p>Termination</p>
<p>Promotion</p>
<p>Transfer</p>
<p>ContactInfo</p>
<p>Leave Of Absence</p>
<p>AddressBookSync</p>
<p>SupervisorSync</p>
<p>Ex. Termination</p></td>
</tr>
<tr class="even">
<td>targetApplication</td>
<td>N</td>
<td><p>string</p>
<p>Ex. zdirectory</p></td>
</tr>
<tr class="odd">
<td>employees</td>
<td>Y</td>
<td>Collection of employee data</td>
</tr>
<tr class="even">
<td>employeeId</td>
<td>Y</td>
<td><p>string</p>
<p>Ex. 000136214</p></td>
</tr>
<tr class="odd">
<td>status</td>
<td>Y</td>
<td><p>string</p>
<p>Ex. Active</p></td>
</tr>
<tr class="even">
<td>employmentType</td>
<td>N</td>
<td><p>string</p>
<p>Ex. Full-time</p></td>
</tr>
<tr class="odd">
<td>hireDate</td>
<td>N</td>
<td><p>date</p>
<p>Ex. 2022-06-08</p></td>
</tr>
<tr class="even">
<td>distributionCenterDivisionId</td>
<td>N</td>
<td><p>string</p>
<p>Ex. FS112</p></td>
</tr>
<tr class="odd">
<td>email</td>
<td>N</td>
<td><p>string</p>
<p>Ex. zines@mclaneco.com</p></td>
</tr>
<tr class="even">
<td>managerName</td>
<td>N</td>
<td><p>string</p>
<p>Ex. Susan Smith</p></td>
</tr>
<tr class="odd">
<td>escalationEmail</td>
<td>N</td>
<td><p>string</p>
<p>Ex. ssmith@mclaneco.com</p></td>
</tr>
<tr class="even">
<td>division</td>
<td>N</td>
<td><p>string</p>
<p>Ex. MBIS-Administration, Div Human Resources</p></td>
</tr>
<tr class="odd">
<td>department</td>
<td>N</td>
<td><p>string</p>
<p>Ex. Help Desk</p></td>
</tr>
<tr class="even">
<td>location</td>
<td>N</td>
<td><p>string</p>
<p>Ex. GR150 DC Southern, IS970 HO MISD</p></td>
</tr>
<tr class="odd">
<td>title</td>
<td>N</td>
<td><p>string</p>
<p>Ex. Engineer II, Windows</p></td>
</tr>
<tr class="even">
<td>tagLabel</td>
<td>N</td>
<td><p>string</p>
<p>Ex. Do Not Email;Terminated</p></td>
</tr>
<tr class="odd">
<td>name</td>
<td>N</td>
<td>Object</td>
</tr>
<tr class="even">
<td>first</td>
<td>Y</td>
<td><p>string</p>
<p>Ex. Zachary</p></td>
</tr>
<tr class="odd">
<td>middle</td>
<td>N</td>
<td><p>string</p>
<p>Ex. A</p></td>
</tr>
<tr class="even">
<td>last</td>
<td>Y</td>
<td><p>string</p>
<p>Ex. Hines</p></td>
</tr>
<tr class="odd">
<td>fullName</td>
<td>N</td>
<td><p>string</p>
<p>Ex. Zachary Hines</p></td>
</tr>
</tbody>
</table>

Example request:

{

"correlationId": "1ea52c41-98d5-11ec-9852-000c29356fc3",

"tracingId": "A19283745",

"timeStamp": "2022-11-04T14:42:19.74Z",

“eventAction”: “AddressBookSync”,

"targetApplication": "zdiscovery",

"employees": \[

{

"email": "zines@mclaneco.com",

"employeeId": "000136214",

"status": "Active",

"hireDate": "2022-06-08",

"managerName": "Susan Smith",

"escalationEmail:": "Susan.Smith@mclaneco.com",

"division": "MBIS-Administration, Div Human Resources",

"department": "Help Desk",

"tagLabel": "Do Not Email",

"name": {

"first": "Zachary",

"middle": "A",

"last": "Hines",

"fullName": "Zachary Hines"

}

},

{

"email": "lfelzer@mclaneco.com",

"employeeId": "000247325",

"status": "Active",

"hireDate": "2022-01-18",

"managerName": "Susan Smith",

"escalationEmail:": "Susan.Smith@mclaneco.com",

"division": "Transportation Drivers",

"department": "GR290 DC Ocala",

"tagLabel": "Do Not Email",

"name": {

"first": "Larry",

"middle": "T",

"last": "Felzer",

"fullName": "Larry Felzer"

}

},

{

"email": "mshmidt@mclaneco.com",

"employeeId": "3101",

"status": "Active",

"hireDate": "2021-03-11",

"managerName": "Susan Smith",

"escalationEmail:": "Susan.Smith@mclaneco.com",

"division": "MBIS-Administration, Div Human Resources",

"department": "Help Desk",

"tagLabel": "Do Not Email",

"name": {

"first": "Mary",

"last": "Shmidt",

"fullName": "Mary Shmidt"

}

}

\]

}

###### Validation

- The following fields are mandatory and should be checked to insure
  they are present on the request payload

<!-- -->

- employees – at least one item in the collection

- employees.employeeId must be present, and not null

- eventAction must be present, and not null

> If any of these fields are missing, log the standard status message
> with the following fields

status.code = “400”

status.messages.type=”Error”

status.messages.message = Required field {field} is missing from the
request

status.messages.context = app.name

###### eventAction = "AddressbookSync"

###### Step 1: Get employee account information from Active Directory

If eventAction=AddressbookSync and email does not contain "noreply" then
perform this step to enhance the incoming employee data with the one
drive url value from active directory

For each item in the employees collection

> If employees\[\*\].employeeId is present, and not null call the Active
> Directory system API to get the oneDriveURL for the employee

###### Resource Locators

- Get user information

GET {BASE_URI}/ad-accounts/v1/users

- Type of Data Consumed:

application/json

See OAS for interaction details: ad-accounts-sys-api

###### Path Parameters: Does Not Apply

|      |                        |         |
|------|------------------------|---------|
| Name | Assignment/Description | Example |
|      |                        |         |

###### Query Parameters: 

|            |                                          |           |
|------------|------------------------------------------|-----------|
| Name       | Assignment/Description                   | Example   |
| employeeId | employeeId from the employees collection | 000247325 |

###### Http Header Parameters: 

|                  |                                           |                                      |
|------------------|-------------------------------------------|--------------------------------------|
| Name             | Assignment/Description                    | Example                              |
| tracing_id       | Optionally sent in on request             | 000031235                            |
| x-correlation-id | correlationId from the MQ message request | 1ea52c41-98d5-11ec-9852-000c29356fc3 |

###### Request Payload: Does not apply

|              |          |       |
|--------------|----------|-------|
| Element Name | Required | Notes |
|              |          |       |

Example:

GET
https://\<server\>:\<port\>/v1/ad-accounts/users?employeeId=000136214

Example request: Does Not Apply

Example successful response:

{

"correlationId": "1ea52c41-98d5-11ec-9852-000c29356fc3",

"tracingId": "A19283745",

"userId": "mxelias",

"employeeId": "000031235",

"singleSignOnId": "mxelias@mclane.mclaneco.com",

"distinguishedName": "CN=mxelias,OU=Teammates,OU=End Users,OU=Internal
Users,DC=mclane,DC=mclaneco,DC=com",

"givenName": "Mary",

"surname": "Eliasen",

"name": "mxelias",

"displayName": "Mary Eliasen",

"division": "MIS - Information Technology - PC Systems",

"department": "PC and Lan Support",

"title": "Engineer II, Windows",

"manager": "CN=lmhendr,OU=Teammates,OU=End Users,OU=Internal
Users,DC=mclane,DC=mclaneco,DC=com",

"email": "Mary.Eliassen@McLaneCo.com",

"ipPhone": "2547717076",

"telephoneNumber": "254-771-7076",

"userPrincipalName": "mxelias@mclane.mclaneco.com",

"oneDriveURL":
"<https://mclaneco-my.sharepoint.com/personal/mxelias_mclane_mclaneco_com>",

"travelerGroup": "APP TRAVEL CORP SOUTH CAMPUS 995"

}

***Request Connector Configuration**: (externalize into a property
file)*

- *Response Timeout(ms): 15000 (responseTimeOut)*

- *Reconnection Strategy: Frequency(ms): 2000
  (reconnectionFrequencyInMS),*

*Attempts: 2 (reconnectionMaxAttempts)*

Success: Proceed to the next step

Failure: Capture error context, write the error to the log, and continue
on to Step#2

###### Step 1a: Enhance the incoming request from the active directory response data:

-userId

-One drive url

-Single sign on id

-TravelGroup

Example Response from the Active directory system API

Add the above elements returned from the Active Directory system API
response to employee item of the incoming employees collection. If the
response from the Active Directory system API does not contain a value
for any of these elements, assign “” as a value when adding it the
employee item of the employees collection

**Special assignment for Travel group:**

For teammates with no McLane email (employee.email contains "noreply")
instead of assigning “”, use the crosswalk file to lookup the travel
group by division (Use the first five positions of the division element
value for the lookup) 

**Crosswalk file :**

Example of the resulting enhanced payload.

{  
"correlationId": "1ea52c41-98d5-11ec-9852-000c29356fc3",  
"tracingId": "A19283745",  
"timeStamp": "2022-11-04T14:42:19.74Z",  
"eventAction": "AddressBookSync",  
"targetApplication": "zdiscovery",  
"employees": \[  
{  
"email": "zines@mclaneco.com",  
"employeeId": "000136214",  
"singleSignOnId": "zhines@mclane.mclaneco.com",  
"userId": "zhines",  
"status": "Active",  
"hireDate": "2022-06-08",  
"managerName": "Susan Smith",  
"escalationEmail:": "Susan.Smith@mclaneco.com",  
"division": "MIS - Application Development - Software Integration",  
"department": "App Dev - Logistics",  
"tagLabel": "Do Not Email",  
"travelerGroup": "APP TRAVEL CORP SOUTH CAMPUS 995",  
"oneDriveURL":
"https://mclaneco-my.sharepoint.com/personal/zhines_mclane_mclaneco_com",  
"name": {  
"first": "Zachary",  
"middle": "A",  
"last": "Hines",  
"fullName": "Zachary Hines"  
}  
},  
{  
"email": "lfelzer@mclaneco.com",  
"employeeId": "000247325",  
"singleSignOnId": "lfelzer@mclane.mclaneco.com",  
"userId": "lfelzer",  
"status": "Active",  
"hireDate": "2022-01-18",  
"managerName": "Susan Smith",  
"escalationEmail:": "Susan.Smith@mclaneco.com",  
"division": "Transportation Drivers",  
"department": "GR290 DC Ocala",  
"tagLabel": "Do Not Email",  
"travelerGroup": "APP TRAVEL FS CORP 801",

"oneDriveURL":
"https://mclaneco-my.sharepoint.com/personal/lfelzer_mclane_mclaneco_com",  
"name": {  
"first": "Larry",  
"middle": "T",  
"last": "Felzer",  
"fullName": "Larry Felzer"  
}  
},  
{  
"email": "mshmidt@mclaneco.com",  
"employeeId": "000135270",  
"singleSignOnId": "mshmidt@mclane.mclaneco.com",  
"userId": "mshmidt",  
"status": "Active",  
"hireDate": "2021-03-11",  
"managerName": "Susan Smith",  
"escalationEmail:": "Susan.Smith@mclaneco.com",  
"division": "MFD - CAR - Procurement",  
"department": "Division Purchasing",  
"tagLabel": "Do Not Email",  
"travelerGroup": "APP TRAVEL MBIS 970",

"oneDriveURL":
"https://mclaneco-my.sharepoint.com/personal/mshmidt_mclane_mclaneco_com",  
"name": {  
"first": "Mary",  
"last": "Shmidt",  
"fullName": "Mary Shmidt"  
}  
}  
\]  
}

###### Step 2: Upsert employee data in bulk into the zDiscovery address book

If eventAction=AddressbookSync then perform this step

###### Call the zDiscovery system API to post the address book data 

###### Resource Locators

- Upsert employees to Zdiscovery address book

PUT {BASE_URI}/v1/address-book/contacts

- Type of Data Consumed:

application/json

See OAS project for interaction details: zdiscovery-litigations-sys-api

###### Path Parameters: Does Not Apply

|      |                        |         |
|------|------------------------|---------|
| Name | Assignment/Description | Example |
|      |                        |         |

###### Query Parameters: 

|                        |                                                             |            |
|------------------------|-------------------------------------------------------------|------------|
| Name                   | Assignment/Description                                      | Example    |
| identifyingElementName | Name of the column/element containing the unique identifier | employeeId |
|                        |                                                             |            |

###### Http Header Parameters: 

|                  |                                           |                                      |
|------------------|-------------------------------------------|--------------------------------------|
| Name             | Assignment/Description                    | Example                              |
| tracing_id       | Optionally sent in on request             | ASY7748901                           |
| x-correlation-id | correlationId from the MQ message request | 1ea52c41-98d5-11ec-9852-000c29356fc3 |

###### Request Payload: 

|                 |                                                  |                                                                                      |
|-----------------|--------------------------------------------------|--------------------------------------------------------------------------------------|
| Element Name    | Assignment/Description                           | Notes                                                                                |
| employees       | Collection of employees                          |                                                                                      |
| employeeId      | employees\[\*\].employeeId from the request      | string, Ex. 000136214                                                                |
| email           | employees\[\*\].email from the request           | string, Ex. lfelzer@mclaneco.com                                                     |
| status          | employees\[\*\].status from the request          | string, Ex. Active                                                                   |
| hireDate        | employees\[\*\].hireDate from the request        | date, Ex. 2022-03-08                                                                 |
| managerName     | employees\[\*\].managerName from the request     | string, Ex. Carol Meyers                                                             |
| escalationEmail | employees\[\*\].escalationEmail from the request | string, Ex. Carol.Meyers@mclaneco.com                                                |
| division        | employees\[\*\].division from the request        | string, Ex. Transportation                                                           |
| department      | employees\[\*\].department from the request      | string, Ex. Help Desk                                                                |
| oneDriveURL     | employees\[\*\].oneDriveURL from the request     | string, Ex. https://mclaneco-my.sharepoint.com/personal/lfelzer3_mclane_mclaneco_com |
| name            |                                                  |                                                                                      |
| first           | employees\[\*\].name.first from the request      | string, Ex. Susan                                                                    |
| last            | employees\[\*\].name.last from the request       | string, Ex. Smith                                                                    |

###### Interact with the zDiscovery system API

- API:

PUT
https://\<server\>:\<port\>/v1/address-book/contacts?identifyingElementName=xxxxxx

**Example:**

PUT
https://\<server\>:\<port\>/zdiscovery-litigations/v1/address-book/contacts?identifyingElementName=employeeId

Example:

{  
"employees": \[  
{  
"email": "zines3@mclaneco.com",  
"employeeId": "000000046",  
"status": "Active",  
"hireDate": "2022-03-08",  
"managerName": "Susan Smith",  
"escalationEmail:": "Susan.Smith@mclaneco.com",  
"division": "MBIS-Administration, Div Human Resources",  
"department": "Help Desk",  
"location": "GR153 DC Southern, IS970 HO MISD",  
"title": "Engineer II, Windows3",  
"oneDriveURL":
"https://mclaneco-my.sharepoint.com/personal/zhines3_mclane_mclaneco_com",  
"tagLabel": "Do Not Email;Hello",  
"name": {  
"first": "Zachary",  
"middle": "A",  
"last": "Hines3",  
"fullName": "Zachary Hines3"  
}  
},  
{  
"email": "lfelzer3@mclaneco.com",  
"employeeId": "000000071",  
"status": "Terminated",  
"hireDate": "2022-01-13",  
"managerName": "Carol Meyers",  
"escalationEmail:": "Carol.Meyers@mclaneco.com",  
"division": "Transportation Drivers",  
"department": "GR293 DC Ocala",  
"location": "GR293 DC Southern, IS970 HO MISD",  
"title": "Driver",  
"oneDriveURL":
"https://mclaneco-my.sharepoint.com/personal/lfelzer3_mclane_mclaneco_com",  
"tagLabel": "Do Not Email;Terminated",  
"name": {  
"first": "Larry",  
"middle": "T",  
"last": "Felzer3",  
"fullName": "Larry Felzer3"  
}  
},  
{  
"email": "mshmidt3@mclaneco.com",  
"employeeId": "000000146",  
"status": "Active",  
"hireDate": "2021-03-31",  
"managerName": "Steve VanDamme",  
"escalationEmail:": "Steve.VanDamme@mclaneco.com",  
"division": "MBIS-Administration, Div Human Resources",  
"department": "Help Desk",  
"location": "GR130 DC Southern, IS970 HO MISD",  
"title": "Engineer II, Windows",  
"oneDriveURL":
"https://mclaneco-my.sharepoint.com/personal/mshmidt3_mclane_mclaneco_com",  
"tagLabel": "Do Not Email;Hi There",  
"name": {  
"first": "Mary",  
"last": "Shmidt3",  
"fullName": "Mary Shmidt3"  
}  
}  
\]  
}

***Request Connector Configuration**: (externalize into a property
file)*

- *Response Timeout(ms): 15000 (responseTimeOut)*

- *Reconnection Strategy: Frequency(ms): 2000
  (reconnectionFrequencyInMS),*

*Attempts: 2 (reconnectionMaxAttempts)*

Success: Proceed to the next step

Failure*:* Capture error context, write the error to the log, and
continue on to Step#3

###### Step 3: Get employee data from EBS

If eventAction=AddressbookSync then perform this step

###### Call the EBS Employee system API to get employee data 

###### Resource Locators

- Get employee data for a given employee Identifier

GET {BASE_URI}/v1/employees/{employeeId}

- Type of Data Consumed:

application/json

See OAS project for interaction details: ebs-employees-sys-api

###### Path Parameters: 

|            |                        |         |
|------------|------------------------|---------|
| Name       | Assignment/Description | Example |
| employeeId |                        |         |

###### Query Parameters: Does Not Apply

|      |                        |         |
|------|------------------------|---------|
| Name | Assignment/Description | Example |
|      |                        |         |

###### Http Header Parameters: 

|                  |                                           |                                      |
|------------------|-------------------------------------------|--------------------------------------|
| Name             | Assignment/Description                    | Example                              |
| tracing_id       | Optionally sent in on request             | ASY7748901                           |
| x-correlation-id | correlationId from the MQ message request | 1ea52c41-98d5-11ec-9852-000c29356fc3 |

###### Request Payload: Does Not Apply

|              |                        |       |
|--------------|------------------------|-------|
| Element Name | Assignment/Description | Notes |
|              |                        |       |

###### Interact with the EBS Employee system API

- API:

GET https://\<server\>:\<port\>/v1/ebs-employees/employees/XXXXXXXXX

**Example:**

GET https://\<server\>:\<port\>/ebs-employees/v1/employees/000135270

Example Response:

{  
"correlationId": "1ea52c41-98d5-11ec-9852-000c29356fc3",  
"tracingId": "A19283745",  
"id": 49831,  
"employeeId": "000061149",  
"hireDate": "2014-09-08",  
"birthDate": "1987-11-25",  
"isCurrentEmployee": true,  
"email": "Mary.Eliassen@McLaneFS.com",  
"costCenter": "20000",  
"costCenterDescription": "TRANSPORTATION",  
"lastUpdateDateTime": "2022-05-25T18:03:18.000",  
"name": {  
"first": "Mary",  
"middle": "Sue",  
"last": "Eliassen",  
"fullName": "Eliassen, Mary Sue"  
}  
}

***Request Connector Configuration**: (externalize into a property
file)*

- *Response Timeout(ms): 15000 (responseTimeOut)*

- *Reconnection Strategy: Frequency(ms): 2000
  (reconnectionFrequencyInMS),*

*Attempts: 2 (reconnectionMaxAttempts)*

Success: Proceed to the next step

Failure: Capture error context, write the error to the log, and continue
on to Step#4

######  Step 3a: Enhance the incoming request from the EBS Employee response data:

This step is applicable if the call to EBS employee system API was made

-Cost Center

Add the above element(s) returned from the EBS Employee system API
response to the employee item of the incoming employees collection. If
the response from the EBS Employee system API does not contain a value
for any of these elements, assign “” as a value when adding it the
employee item of the employees collection

Example of the resulting enhanced payload.

{  
"correlationId": "1ea52c41-98d5-11ec-9852-000c29356fc3",  
"tracingId": "A19283745",  
"timeStamp": "2022-11-04T14:42:19.74Z",  
"eventAction": "AddressBookSync",  
"targetApplication": "zdiscovery",  
"employees": \[  
{  
"email": "zines@mclaneco.com",  
"employeeId": "000136214",  
"singleSignOnId": "zhines@mclane.mclaneco.com",  
"userId": "zhines",  
"status": "Active",  
"hireDate": "2022-06-08",  
"managerName": "Susan Smith",  
"escalationEmail:": "Susan.Smith@mclaneco.com",  
"division": "MIS - Application Development - Software Integration",  
"department": "App Dev – Logistics",

"costCenter": "20000",  
"tagLabel": "Do Not Email",  
"travelerGroup": "APP TRAVEL CORP SOUTH CAMPUS 995",  
"oneDriveURL":
"https://mclaneco-my.sharepoint.com/personal/zhines_mclane_mclaneco_com",  
"name": {  
"first": "Zachary",  
"middle": "A",  
"last": "Hines",  
"fullName": "Zachary Hines"  
}  
},  
{  
"email": "lfelzer@mclaneco.com",  
"employeeId": "000247325",  
"singleSignOnId": "lfelzer@mclane.mclaneco.com",  
"userId": "lfelzer",  
"status": "Active",  
"hireDate": "2022-01-18",  
"managerName": "Susan Smith",  
"escalationEmail:": "Susan.Smith@mclaneco.com",  
"division": "Transportation Drivers",  
"department": "GR290 DC Ocala",

"costCenter": "80000",  
"tagLabel": "Do Not Email",  
"travelerGroup": "APP TRAVEL FS CORP 801",

"oneDriveURL":
"https://mclaneco-my.sharepoint.com/personal/lfelzer_mclane_mclaneco_com",  
"name": {  
"first": "Larry",  
"middle": "T",  
"last": "Felzer",  
"fullName": "Larry Felzer"  
}  
},  
{  
"email": "mshmidt@mclaneco.com",  
"employeeId": "000135270",  
"singleSignOnId": "mshmidt@mclane.mclaneco.com",  
"userId": "mshmidt",  
"status": "Active",  
"hireDate": "2021-03-11",  
"managerName": "Susan Smith",  
"escalationEmail:": "Susan.Smith@mclaneco.com",  
"division": "MFD - CAR - Procurement",  
"department": "Division Purchasing",

"costCenter": "40005",  
"tagLabel": "Do Not Email",  
"travelerGroup": "APP TRAVEL MBIS 970",

"oneDriveURL":
"https://mclaneco-my.sharepoint.com/personal/mshmidt_mclane_mclaneco_com",  
"name": {  
"first": "Mary",  
"last": "Shmidt",  
"fullName": "Mary Shmidt"  
}  
}  
\]  
}

###### Step 4: Post groups of employee data to B2BI to be eventually sent to Egencia

If eventAction=AddressbookSync then perform this step

###### Call the B2BI Files system API to post the employee data 

###### Resource Locators

- Create employee records intended for Egencia

POST {BASE_URI}/v1/files/employees?

- Type of Data Consumed:

application/json

See OAS project for interaction details: b2bi-files-sys-api

###### Path Parameters: Does Not Apply

|      |                        |         |
|------|------------------------|---------|
| Name | Assignment/Description | Example |
|      |                        |         |

###### Query Parameters: 

|                   |                                                       |               |
|-------------------|-------------------------------------------------------|---------------|
| Name              | Assignment/Description                                | Example       |
| targetApplication | Describes the application that is to consume the data | EgenciaTravel |

###### Http Header Parameters: 

|                  |                                           |                                      |
|------------------|-------------------------------------------|--------------------------------------|
| Name             | Assignment/Description                    | Example                              |
| tracing_id       | tracingId from the request                | ASY7748901                           |
| x-correlation-id | correlationId from the MQ message request | 1ea52c41-98d5-11ec-9852-000c29356fc3 |

###### Request Payload: 

<table>
<colgroup>
<col style="width: 21%" />
<col style="width: 33%" />
<col style="width: 44%" />
</colgroup>
<tbody>
<tr class="odd">
<td>Element Name</td>
<td>Assignment</td>
<td>Notes</td>
</tr>
<tr class="even">
<td>employees</td>
<td></td>
<td>Collection of employee data</td>
</tr>
<tr class="odd">
<td>employeeId</td>
<td>employees[*].employeeId from the request</td>
<td>string, Ex. 000136214</td>
</tr>
<tr class="even">
<td>singleSignOnId</td>
<td>employees.[*].singleSignOnId from the request</td>
<td>string, Ex. zhines@mclane.mclaneco.com</td>
</tr>
<tr class="odd">
<td>userId</td>
<td>employees[*].userId from the request</td>
<td>string, Ex. zhines</td>
</tr>
<tr class="even">
<td>status</td>
<td>employees[*].status from the request</td>
<td><p>string,</p>
<p>Valid Values:</p>
<p>ACTIVE</p>
<p>TERMINATED</p>
<p>UNPAID_LEAVE</p></td>
</tr>
<tr class="odd">
<td>hireDate</td>
<td>employees[*].hireDate from the request</td>
<td>string, Ex. 2022-06-08</td>
</tr>
<tr class="even">
<td>managerName</td>
<td>employees[*].managerName from the request</td>
<td>string, Ex. Susan Smith</td>
</tr>
<tr class="odd">
<td>escalationEmail</td>
<td>employees[*].escalationEmail from the request</td>
<td>string, Ex. Susan.Smith@mclaneco.com</td>
</tr>
<tr class="even">
<td>division</td>
<td>employees.[*].division from the request</td>
<td>string, Ex. MBIS-Administration, Div Human Resources</td>
</tr>
<tr class="odd">
<td>department</td>
<td>employees[*].department from the request</td>
<td>string, Ex. Help Desk</td>
</tr>
<tr class="even">
<td>costCenter</td>
<td>employees.[*].costCenter from the request</td>
<td>string Ex. 20000</td>
</tr>
<tr class="odd">
<td>location</td>
<td>employees[*].location .employeeId from the request</td>
<td>string, Ex. GR150 DC Southern, IS970 HO MISD</td>
</tr>
<tr class="even">
<td>title</td>
<td>employees[*].title from the request</td>
<td>string, Ex. Engineer II, Windows</td>
</tr>
<tr class="odd">
<td>travelerGroup</td>
<td>employees[*].travelerGroup from the request</td>
<td>string, Ex. APP TRAVEL MBIS 970</td>
</tr>
<tr class="even">
<td>oneDriveURL</td>
<td>employees[*].oneDriveURL from the request</td>
<td>string, Ex.
https://mclaneco-my.sharepoint.com/personal/zhinrs_mclane_mclaneco_com</td>
</tr>
<tr class="odd">
<td>email</td>
<td>employees[*].email from the request</td>
<td>string, Ex. zhines@mclaneco.com</td>
</tr>
<tr class="even">
<td>phoneNumber</td>
<td>employees[*].phoneNumber from the request</td>
<td>string, Ex. 704-720-7053</td>
</tr>
<tr class="odd">
<td>ipPhoneNumber</td>
<td>employees[*].ipPhoneNumber from the request</td>
<td>string, Ex. 7047207053</td>
</tr>
<tr class="even">
<td>name</td>
<td></td>
<td>Object that holds name information</td>
</tr>
<tr class="odd">
<td>first</td>
<td>employees[*].name.first from the request</td>
<td>string, Ex. Zachary</td>
</tr>
<tr class="even">
<td>middle</td>
<td>employees[*].name.middle from the request</td>
<td>string, Ex. Robert</td>
</tr>
<tr class="odd">
<td>last</td>
<td>employees[*].name.last from the request</td>
<td>string, Ex. Hines</td>
</tr>
</tbody>
</table>

###### Interact with the B2BI system API

- API:

POST
https://\<server\>:\<port\>/v1/files/employees?targetApplication=xxxxxx

**Example:**

POST
https://\<server\>:\<port\>/b2bi-files/v1/files/employees?targetApplication=EgenciaTravel

Example Request:

{

"employees": \[  
{  
"email": "zines@mclaneco.com",  
"employeeId": "000136214",  
"singleSignOnId": "zhines@mclane.mclaneco.com",  
"userId": "zhines",  
"status": "ACTIVE",  
"hireDate": "2022-06-08",  
"managerName": "Susan Smith",  
"escalationEmail": "Susan.Smith@mclaneco.com",  
"division": "IS970 HO MISD",  
"department": "App Dev - Logistics",  
"costCenter": "50320",  
"tagLabel": "Do Not Email",  
"travelerGroup": "APP TRAVEL CORP SOUTH CAMPUS 995",  
"oneDriveURL":
"https://mclaneco-my.sharepoint.com/personal/zhines_mclane_mclaneco_com",  
"name": {  
"first": "Zachary",  
"middle": "A",  
"last": "Hines",  
"fullName": "Zachary Hines"  
}  
},  
{  
"email": "lfelzer@mclaneco.com",  
"employeeId": "000247325",  
"singleSignOnId": "lfelzer@mclane.mclaneco.com",  
"userId": "lfelzer",  
"status": "UNPAID_LEAVE",  
"hireDate": "2022-01-18",  
"managerName": "Charlie Brown",  
"escalationEmail": "Charlie.Brown@mclaneco.com",  
"division": "GR290 DC Ocala",  
"department": "Distribution Inventory Control",  
"costCenter": "20002",  
"tagLabel": "Do Not Email",  
"travelerGroup": "APP TRAVEL FS CORP 801",  
"oneDriveURL":
"https://mclaneco-my.sharepoint.com/personal/lfelzer_mclane_mclaneco_com",  
"name": {  
"first": "Larry",  
"middle": "T",  
"last": "Felzer",  
"fullName": "Larry Felzer"  
}  
},  
{  
"email": "mshmidt@mclaneco.com",  
"employeeId": "000135270",  
"singleSignOnId": "mshmidt@mclane.mclaneco.com",  
"userId": "mshmidt",  
"status": "ACTIVE",  
"hireDate": "2021-03-11",  
"managerName": "Marty Wilson",  
"escalationEmail": "Marty.Wilson@mclaneco.com",  
"division": "FS800 SC Carrollton Suprt Cntr",  
"department": "Division Purchasing",  
"costCenter": "30001",  
"tagLabel": "Do Not Email",  
"travelerGroup": "APP TRAVEL MBIS 970",  
"oneDriveURL":
"https://mclaneco-my.sharepoint.com/personal/mshmidt_mclane_mclaneco_com",  
"name": {  
"first": "Mary",  
"last": "Shmidt",  
"fullName": "Mary Shmidt"  
}  
}  
\]

}

***Request Connector Configuration**: (externalize into a property
file)*

- *Response Timeout(ms): 15000 (responseTimeOut)*

- *Reconnection Strategy: Frequency(ms): 2000
  (reconnectionFrequencyInMS),*

*Attempts: 2 (reconnectionMaxAttempts)*

###### eventAction=Termination

###### Call the B2BI system API to post the employee data 

###### Resource Locators

- Create an employee termination record

POST {BASE_URI}/v1/files/employees?

- Type of Data Consumed:

application/json

See OAS project for interaction details: b2bi-files-sys-api

###### Path Parameters: Does Not Apply

|      |                        |         |
|------|------------------------|---------|
| Name | Assignment/Description | Example |
|      |                        |         |

###### Query Parameters: 

|                   |                                                       |                |
|-------------------|-------------------------------------------------------|----------------|
| Name              | Assignment/Description                                | Example        |
| targetApplication | Describes the application that is to consume the data | BuyerQuestTerm |

###### Http Header Parameters: 

|                  |                                           |                                      |
|------------------|-------------------------------------------|--------------------------------------|
| Name             | Assignment/Description                    | Example                              |
| tracing_id       | tracingId from the request                | ASY7748901                           |
| x-correlation-id | correlationId from the MQ message request | 1ea52c41-98d5-11ec-9852-000c29356fc3 |

###### Request Payload: 

<table>
<colgroup>
<col style="width: 21%" />
<col style="width: 33%" />
<col style="width: 44%" />
</colgroup>
<tbody>
<tr class="odd">
<td>Element Name</td>
<td>Assignment</td>
<td>Notes</td>
</tr>
<tr class="even">
<td>employees</td>
<td></td>
<td>Collection of employee data</td>
</tr>
<tr class="odd">
<td>employeeId</td>
<td>employees[*].employeeId from the request</td>
<td>string, Ex. 000136214</td>
</tr>
<tr class="even">
<td>userId</td>
<td>employees[*].userId from the request</td>
<td>string, Ex. zhines</td>
</tr>
<tr class="odd">
<td>status</td>
<td>employees[*].status from the request</td>
<td><p>string,</p>
<p>Valid Values:</p>
<p>Active</p>
<p>Terminated</p></td>
</tr>
<tr class="even">
<td>hireDate</td>
<td>employees[*].hireDate from the request</td>
<td>string, Ex. 2022-06-08</td>
</tr>
<tr class="odd">
<td>managerName</td>
<td>employees[*].managerName from the request</td>
<td>string, Ex. Susan Smith</td>
</tr>
<tr class="even">
<td>escalationEmail</td>
<td>employees[*].escalationEmail from the request</td>
<td>string, Ex. Susan.Smith@mclaneco.com</td>
</tr>
<tr class="odd">
<td>division</td>
<td>employees.[*].division from the request</td>
<td>string, Ex. MBIS-Administration, Div Human Resources</td>
</tr>
<tr class="even">
<td>department</td>
<td>employees[*].department from the request</td>
<td>string, Ex. Help Desk</td>
</tr>
<tr class="odd">
<td>location</td>
<td>employees[*].location .employeeId from the request</td>
<td>string, Ex. GR150 DC Southern, IS970 HO MISD</td>
</tr>
<tr class="even">
<td>title</td>
<td>employees[*].title from the request</td>
<td>string, Ex. Engineer II, Windows</td>
</tr>
<tr class="odd">
<td>oneDriveURL</td>
<td>employees[*].oneDriveURL from the request</td>
<td>string, Ex.
https://mclaneco-my.sharepoint.com/personal/zhinrs_mclane_mclaneco_com</td>
</tr>
<tr class="even">
<td>email</td>
<td>employees[*].email from the request</td>
<td>string, Ex. zhines@mclaneco.com</td>
</tr>
<tr class="odd">
<td>phoneNumber</td>
<td>employees[*].phoneNumber from the request</td>
<td>string, Ex. 704-720-7053</td>
</tr>
<tr class="even">
<td>ipPhoneNumber</td>
<td>employees[*].ipPhoneNumber from the request</td>
<td>string, Ex. 7047207053</td>
</tr>
<tr class="odd">
<td>name</td>
<td></td>
<td>Object that holds name information</td>
</tr>
<tr class="even">
<td>first</td>
<td>employees[*].name.first from the request</td>
<td>string, Ex. Zachary</td>
</tr>
<tr class="odd">
<td>middle</td>
<td>employees[*].name.middle from the request</td>
<td>string, Ex. Robert</td>
</tr>
<tr class="even">
<td>last</td>
<td>employees[*].name.last from the request</td>
<td>string, Ex. Hines</td>
</tr>
</tbody>
</table>

###### Interact with the B2BI system API

- API:

POST
https://\<server\>:\<port\>/v1/files/employees?targetApplication=xxxxxx

**Example:**

POST
https://\<server\>:\<port\>/b2bi-files/v1/files/employees?targetApplication=BuyerQuest

Example Request:

{

"employees": \[

{

"email": "zines@mclaneco.com",

"employeeId": "000136214",

"status": "Active",

"hireDate": "2022-06-08",

"managerName": "Susan Smith",

"escalationEmail:": "Susan.Smith@mclaneco.com",

"division": "MBIS-Administration, Div Human Resources",

"department": "Help Desk",

"tagLabel": "Do Not Email",

"name": {

"first": "Zachary",

"middle": "A",

"last": "Hines",

"fullName": "Zachary Hines"

}

},

{

"email": "lfelzer@mclaneco.com",

"employeeId": "000247325",

"status": "Active",

"hireDate": "2022-01-18",

"managerName": "Susan Smith",

"escalationEmail:": "Susan.Smith@mclaneco.com",

"division": "Transportation Drivers",

"department": "GR290 DC Ocala",

"name": {

"first": "Larry",

"middle": "T",

"last": "Felzer",

"fullName": "Larry Felzer"

}

},

{

"email": "mshmidt@mclaneco.com",

"employeeId": "000213101",

"status": "Active",

"hireDate": "2021-03-11",

"managerName": "Susan Smith",

"escalationEmail:": "Susan.Smith@mclaneco.com",

"division": "MBIS-Administration, Div Human Resources",

"department": "Help Desk",

"name": {

"first": "Mary",

"last": "Shmidt",

"fullName": "Mary Shmidt"

}

}

\]

}

Example Response from the system API:

{

"correlationId": "1ea52c41-98d5-11ec-9852-000c29356fc3",

"tracingId": "A19283745",

"status": {

"code": "200",

"messages": \[

{

"type": "Diagnostic",

"message": "Data has been queued for processing",

"timeStamp": "2022-10-30T15:27:49.274Z"

}

\]

}

}

###### eventAction=SupervisorSync

###### Call the HCM Process API post the supervisor employee data 

###### Resource Locators

- Process an employee supervisor updatee

POST {BASE_URI}/v1/employees/supervisors

- Type of Data Consumed:

application/json

See OAS project for interaction details: hcm-shift-mgmt-prc-api

###### Path Parameters: Does Not Apply

|      |                        |         |
|------|------------------------|---------|
| Name | Assignment/Description | Example |
|      |                        |         |

###### Query Parameters: Does Not Apply

|      |                        |         |
|------|------------------------|---------|
| Name | Assignment/Description | Example |
|      |                        |         |

###### Http Header Parameters: 

|                  |                                           |                                      |
|------------------|-------------------------------------------|--------------------------------------|
| Name             | Assignment/Description                    | Example                              |
| tracing_id       | tracingId from the request                | ASY7748901                           |
| x-correlation-id | correlationId from the MQ message request | 1ea52c41-98d5-11ec-9852-000c29356fc3 |

###### Request Payload: 

<table>
<colgroup>
<col style="width: 24%" />
<col style="width: 32%" />
<col style="width: 43%" />
</colgroup>
<tbody>
<tr class="odd">
<td>Element Name</td>
<td>Assignment</td>
<td>Notes</td>
</tr>
<tr class="even">
<td>supervisor</td>
<td>It will be the first item in the employees collection</td>
<td>Object that hold the Supervisor information</td>
</tr>
<tr class="odd">
<td>employeeId</td>
<td>employees[1].employeeId from the request</td>
<td>string, Ex. 000599214</td>
</tr>
<tr class="even">
<td>status</td>
<td>employees[1].status from the request</td>
<td><p>string,</p>
<p>Valid Values:</p>
<p>Active</p>
<p>Terminated</p></td>
</tr>
<tr class="odd">
<td>employmentType</td>
<td>employees[1].employmentType from the request</td>
<td>string, Ex. Full-time</td>
</tr>
<tr class="even">
<td>hireDate</td>
<td>employees[1].hireDate from the request</td>
<td>string, Ex. 2022-06-08</td>
</tr>
<tr class="odd">
<td>distributionCenterDivisionId</td>
<td>employees[1].distributionCenterDivisionId from the request</td>
<td>string, Ex. FS112</td>
</tr>
<tr class="even">
<td>person</td>
<td></td>
<td>Object that holds person information</td>
</tr>
<tr class="odd">
<td>name</td>
<td></td>
<td>Object that holds name information</td>
</tr>
<tr class="even">
<td>first</td>
<td>employees[1].name.first from the request</td>
<td>string, Ex. Zachary</td>
</tr>
<tr class="odd">
<td>middle</td>
<td>employees[1].name.middle from the request</td>
<td>string, Ex. Robert</td>
</tr>
<tr class="even">
<td>lastName</td>
<td>employees[1].name.last from the request</td>
<td>string, Ex. Hines</td>
</tr>
<tr class="odd">
<td>teammates</td>
<td>Assign from all remaining employee items in the collection</td>
<td>Collection of employee data</td>
</tr>
<tr class="even">
<td>employeeId</td>
<td>employees[*].employeeId from the request</td>
<td>string, Ex. 000136214</td>
</tr>
<tr class="odd">
<td>userId</td>
<td>employees[*].userId from the request</td>
<td>string, Ex. zhines</td>
</tr>
<tr class="even">
<td>status</td>
<td>employees[*].status from the request</td>
<td><p>string,</p>
<p>Valid Values:</p>
<p>Active</p>
<p>Terminated</p></td>
</tr>
<tr class="odd">
<td>employmentType</td>
<td>employees[*].employmentType from the request</td>
<td>string, Ex. Full-time</td>
</tr>
<tr class="even">
<td>hireDate</td>
<td>employees[*].hireDate from the request</td>
<td>string, Ex. 2022-06-08</td>
</tr>
<tr class="odd">
<td>managerName</td>
<td>employees[*].managerName from the request</td>
<td>string, Ex. Susan Smith</td>
</tr>
<tr class="even">
<td>escalationEmail</td>
<td>employees[*].escalationEmail from the request</td>
<td>string, Ex. Susan.Smith@mclaneco.com</td>
</tr>
<tr class="odd">
<td>distributionCenterDivisionId</td>
<td>employees[*].distributionCenterDivisionId from the request</td>
<td>string, Ex. FS112</td>
</tr>
<tr class="even">
<td>division</td>
<td>employees.[*].division from the request</td>
<td>string, Ex. MBIS-Administration, Div Human Resources</td>
</tr>
<tr class="odd">
<td>department</td>
<td>employees[*].department from the request</td>
<td>string, Ex. Help Desk</td>
</tr>
<tr class="even">
<td>location</td>
<td>employees[*].location .employeeId from the request</td>
<td>string, Ex. GR150 DC Southern, IS970 HO MISD</td>
</tr>
<tr class="odd">
<td>title</td>
<td>employees[*].title from the request</td>
<td>string, Ex. Engineer II, Windows</td>
</tr>
<tr class="even">
<td>oneDriveURL</td>
<td>employees[*].oneDriveURL from the request</td>
<td>string, Ex.
https://mclaneco-my.sharepoint.com/personal/zhinrs_mclane_mclaneco_com</td>
</tr>
<tr class="odd">
<td>email</td>
<td>employees[*].email from the request</td>
<td>string, Ex. zhines@mclaneco.com</td>
</tr>
<tr class="even">
<td>phoneNumber</td>
<td>employees[*].phoneNumber from the request</td>
<td>string, Ex. 704-720-7053</td>
</tr>
<tr class="odd">
<td>ipPhoneNumber</td>
<td>employees[*].ipPhoneNumber from the request</td>
<td>string, Ex. 7047207053</td>
</tr>
<tr class="even">
<td>person</td>
<td></td>
<td>Object that holds person information</td>
</tr>
<tr class="odd">
<td>name</td>
<td></td>
<td>Object that holds name information</td>
</tr>
<tr class="even">
<td>first</td>
<td>employees[*].name.first from the request</td>
<td>string, Ex. Zachary</td>
</tr>
<tr class="odd">
<td>middle</td>
<td>employees[*].name.middle from the request</td>
<td>string, Ex. Robert</td>
</tr>
<tr class="even">
<td>lastName</td>
<td>employees[*].name.last from the request</td>
<td>string, Ex. Hines</td>
</tr>
</tbody>
</table>

###### Interact with the HCM Shift Management Process API system API

- API:

POST https://\<server\>:\<port\>/v1/employees/supervisors

**Example:**

POST https://\<server\>:\<port\>/hcm-shift-mgmt/v1/employees/supervisors

Example Request:

{  
"supervisor": {  
"employeeId": "000049009",  
"status": "Active",  
"employmentType": "Full-time",  
"hireDate": "2005-08-15",  
"distributionCenterDivisionId": "FB616",  
"person": {  
"name": {  
"first": "Chip",  
"lastName": "Green"  
}  
}  
},  
"teammates": \[  
{  
"employeeId": "000049595",  
"status": "Active",  
"employmentType": "Full-time",  
"hireDate": "1996-07-17",  
"distributionCenterDivisionId": "FB616",  
"person": {  
"name": {  
"first": "Betty",  
"lastName": "Masteroni"  
}  
}  
},  
{  
"employeeId": "000049418",  
"status": "Active",  
"employmentType": "Full-time",  
"hireDate": "1989-10-13",  
"distributionCenterDivisionId": "FB616",  
"person": {  
"name": {  
"first": "Jerry",  
"lastName": "Farrow"  
}  
}  
},  
{  
"employeeId": "000049087",  
"status": "Active",  
"employmentType": "Full-time",  
"hireDate": "2004-01-26",  
"distributionCenterDivisionId": "FB616",  
"person": {  
"name": {  
"first": "Marty",  
"lastName": "Teller"  
}  
}  
}  
\]  
}

Example Response from the process API:

{

"correlationId": "1ea52c41-98d5-11ec-9852-000c29356fc3",

"tracingId": "A19283745",

}

###### Logging the API request, and response: 

###### Logging Payload:

We should log data prior to the API call, and after the api call. The
log message prior to the api call should contain the resource endpoint
being called, the request message payload if it applies, as well as the
standard log elements, and the log message after the api call should
contain the response.

At the end of the flow, we should log the results of the api call with
the following elements.

<table>
<colgroup>
<col style="width: 30%" />
<col style="width: 37%" />
<col style="width: 32%" />
</colgroup>
<tbody>
<tr class="odd">
<td>Element Name</td>
<td>Mapping</td>
<td>Notes</td>
</tr>
<tr class="even">
<td>correlationId</td>
<td>correlationId from the request message</td>
<td>Ex. 233e4fd0-e81b-11ec-8245-06e260431b40</td>
</tr>
<tr class="odd">
<td>tracingId</td>
<td>tracingId from the request message</td>
<td>Ex. abc12321</td>
</tr>
<tr class="even">
<td>eventAction</td>
<td>eventAction from the message</td>
<td>Ex. Termination</td>
</tr>
<tr class="odd">
<td>resourceUrl</td>
<td>Url for calling the active directory system api</td>
<td>Ex. https://api-test.mclaneco.com/users?empoyeeId=000136214</td>
</tr>
<tr class="even">
<td>requestPayload</td>
<td><p>If http response from the API call starts with a 2,</p>
<p>Then null</p>
<p>Else original payload of the message</p></td>
<td></td>
</tr>
<tr class="odd">
<td>apiResponse</td>
<td><p>If http response from the API call starts with a 2,</p>
<p>Then null</p>
<p>Else original payload of the message</p></td>
<td></td>
</tr>
<tr class="even">
<td>statusCode</td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td>code</td>
<td>http response from the API call</td>
<td>Ex. 200</td>
</tr>
<tr class="even">
<td>messages</td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td>type</td>
<td><p>If http response from the API call starts with a 2,</p>
<p>then Diagnostic</p>
<p>else Error</p></td>
<td>Ex. Diagnostic</td>
</tr>
<tr class="even">
<td>reasonCode</td>
<td>error.errorType default null</td>
<td></td>
</tr>
<tr class="odd">
<td>message</td>
<td><p>If http response from the API call starts with a 2</p>
<p>then Success</p>
<p>else assign the error message</p></td>
<td></td>
</tr>
<tr class="even">
<td>context</td>
<td>app.name</td>
<td>Ex. mcl-addressbook-sync-app-tst-1</td>
</tr>
<tr class="odd">
<td>timestamp</td>
<td>Current date &amp; time</td>
<td>Ex. 2022-06-09T22:45:11.042Z</td>
</tr>
</tbody>
</table>

**Example Message to Log:**

{

"correlationId": "c759dc47-c673-4d0c-ab9c-20ee52f6d145",

"tracingId": "A5579098",

"eventAction": "AddressBookSync ",

"retryResourceUrl":
"https://api-test.mclaneco.com/ad-users/accounts?employeeId=000136214",

"apiRetryResponse": null,

"status": {

"code": "200",

"messages": \[

{

"type": "Diagnostic",

"reasonCode": "",

"message": "Success",

"context": "mcl-addressbook-sync-app-tst-1",

"timestamp": "2022-11-09T22:45:11.042Z"

}

\]

}

}

Success: Proceed to the next step

Failure: Capture error context, respond back to the caller and end
processing

###### Error Processing

If an issue/error is encountered with this application, the specifics
related to the error are to be reported via logging which will be routed
over to splunk.

- if there are any issues/errors returned from this MQ call, the context
  of the error should be placed in the status section, and a response
  should be formatted and sent back to the caller.

-Set the following status elements in the response

status.code = 500

status.messages.type = “Error”

> status.messages.reasonCode = error.errorType
>
> status.messages.message = error.exception.cause.linkedException
>
> default error.exception

###### Non Functional Requirements

###### Security

###### Data

- Masking elements: Does Not apply

###### Transport

- http

###### Availability

- *99.99% uptime 24x7*

###### Reliability

- High availability via multiple workers

###### Traceability

- Transaction tracing via log data to Splunk

- Specific Auditing requirements: Does Not Apply

###### Throughput

- Current Peak Metric:

  - xx Concurrent transactions per second

  - xx Minutes - specified duration(s)

  - M T W T F S S Note any applicable days in the week

- Seasonal dimension: Does Not Apply

- Estimated Peak metric over the next 9-12 months:

  - xx Concurrent transactions per second

  - xx minutes - specified duration(s)

  - M T W T F S S Note any applicable days in the week

###### Response Time

- Does Not Apply

# Appendix

## IBM MQ Connector Configuration

***IBM MQ Configuration**: (externalize into a property file)*

- ***Connection mode**: Client, **Specification**: JMS_2_0, **Target
  Client**: NO_JMS Compliant, **IBM MQ Client**: com.ibm.mq.allclient*

- ***Persistent delivery**: false, **Priority**: 0*

- ***Reconnection Strategy**: Fails deployment when test connection
  fails, **Frequency**(ms): 2000 (reconnectionFrequencyInMS),
  **Attempts**: 2 (reconnectionMaxAttempts)*

|             |                           |      |               |               |
|-------------|---------------------------|------|---------------|---------------|
| Environment | Host                      | Port | Queue Manager | Channel       |
| Development | ltdstmqapp01.mclaneco.com | 1415 | TTDCMQ01      | MSOFT.SVRCONN |
| Test        | ltdstmqapp01.mclaneco.com | 1415 | TTDCMQ01      | MSOFT.SVRCONN |
| Production  | lpdstmqapp01.mclaneco.com | 1414 | PTDCMQ01      | MSOFT.SVRCONN |

## IBM MQ Employee Events Sync On Message Queue Configuration

To get a message and make a REST call based on the message payload

***IBM MQ Configuration**: (externalize into a property file)*

- ***Destination**: (externalize in a property file as inputQ)*

  - ***Development:** MSOFT.PRC.EMPLOYEE.EVENTS.SYNC.REQ.DEV*

  - ***Test:** MSOFT.PRC.EMPLOYEE.EVENTS.SYNC.REQ*

  - ***Production:** MSOFT.PRC.EMPLOYEE.EVENTS.SYNC.REQ*

- ***Destination type**: Queue*

- ***Content Type:** text/plain*

## MQ Request Queue Configuration Information

Request Queue: *MSOFT.PRC.EMPLOYEE.EVENTS.SYNC.REQ*

|                    |                                    |                           |
|--------------------|------------------------------------|---------------------------|
| **Parameter Name** | **Parameter Value**                | **Parameter Description** |
| BOTHRESH           | 2                                  | Backout Threshold         |
| BOQNAME            | MSOFT.PRC.EMPLOYEE.EVENTS.SYNC.ERR | Backout Queue Name        |

## Error Structure

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 40%" />
<col style="width: 38%" />
</colgroup>
<tbody>
<tr class="odd">
<td>Element Name</td>
<td>Assignment</td>
<td>Notes</td>
</tr>
<tr class="even">
<td>correlationId</td>
<td>correlationId</td>
<td><p>string</p>
<p>Ex. d5f6fbf8-6774-4a95-9b59-15348943abd4</p></td>
</tr>
<tr class="odd">
<td>tracingId</td>
<td>tracing_id from the system API request header, if present</td>
<td><p>string</p>
<p>Ex. A3345732</p></td>
</tr>
<tr class="even">
<td><strong>status</strong></td>
<td></td>
<td>Object that holds processing status context</td>
</tr>
<tr class="odd">
<td>code</td>
<td>Response code</td>
<td></td>
</tr>
<tr class="even">
<td><strong>messages</strong></td>
<td></td>
<td>Object that holds the collection of diagnostic information</td>
</tr>
<tr class="odd">
<td>type</td>
<td>“Error”</td>
<td>string</td>
</tr>
<tr class="even">
<td>severity</td>
<td></td>
<td>string</td>
</tr>
<tr class="odd">
<td>reasonCode</td>
<td>Application return code if available</td>
<td>string</td>
</tr>
<tr class="even">
<td>message</td>
<td>Error message text</td>
<td>string</td>
</tr>
<tr class="odd">
<td>context</td>
<td>app.name</td>
<td>string</td>
</tr>
<tr class="even">
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

"status": {

"code": "500",

"messages": \[

{

"type": "Error",

"severity": "1",

"reasonCode": "40613",

"message": "Database mydb on server mydbserver is not currently
available",

"context": "third-party-shipping-exp-api",

"timeStamp": "2021-09-30T15:27:49.274Z"

}

\]

}

}

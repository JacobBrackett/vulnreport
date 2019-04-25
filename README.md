# Vulnreport
### Pentesting management and automation platform

Vulnreport is a platform for managing penetration tests and generating well-formatted, actionable findings reports without the normal overhead that takes up security engineer's time. The platform is built to support automation at every stage of the process and allow customization for whatever other systems you use as part of your pentesting process.

Vulnreport was built by the Salesforce Product Security team as a way to get rid of the time we spent writing, formatting, and proofing reports for penetration tests. Our goal was and continues to be to build great security tools that let pentesters and security engineers focus on finding and fixing vulns.

For full documentation, see <http://vulnreport.io/documentation>

## Deployment

Vulnreport is a Ruby web application (Sinatra/Rack stack) backed by a PostgreSQL database with a Redis cache layer.

This version of vulnreport is intended to be deployed with docker-compose for local use. Follow the steps below to set up your user:

1. You must create a .env file and a .postgres.env file based on the two example files provided (.env.example & .postgres.env.example). The username and password for the database must match between the two files.
2. Optionally, add an SSL keypair named server.key (private) and server.crt (public). If you do not add these, they will be generated for you in the next step.
3. Run the `init.sh` script locally and go grab a coffee. This will create a self signed cert, build the vulnreport docker image and spin up the whole stack with intially seeded values.

The server will be available at [https://127.0.0.1:443](https://127.0.0.1:443).The default admin user has been created for you with username `admin` and password `admin`. This should be **immediately rotated and/or SSO should be configured.**

You can stop the server any time with `docker-compose down`, and restart it with `docker-compose up -d`

## Pentest!

You're ready to go - for documentation about how to use your newly-installed Vulnreport instance, see the full docs at <http://vulnreport.io/documentation>

## Custom Interfaces and Integrations

Vulnreport is designed and intended to be used with external systems. For more information about how to implement the interfaces that allow for integration/synchronization with external systems please see the custom interfaces documentation at <http://vulnreport.io/documentation#interfaces>.

## Code Documentation

To generate the documentation for the code, simply run Yard:
```sh
yard doc
yard server
```

## A Note on XML Import/Export

Currently, Vulnreport supports an XML format to import Vulns to a specific Test. This is useful if you want Vulnreport to be on a different network than you do your pentests on and thus are using a different client to record findings while you actively pentest, but relies on being configured for your specific Vulnreport instance and Vulntypes configuration.

We're working on supporting a few other types of XML import (ZAP and Burp, for instance) as well as allowing arbitrary XML export/import between Vulnreport instances. Stay tuned as we hope to push these features soon.

The XML format Vulnreport currently supports is:
```xml
<?xml version="1.0" encoding="UTF-8"?>

<Test xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <Vuln>
    <Type>[Vulntype ID]</Type>
    <File>[File Vuln Data]</File>
    <Code>
      [Code Vuln Data]
    </Code>
    <File>clsSyncLog.cls</File>
    <Code>
      hello world
    </Code>
    ...etc...
  </Vuln>

  <Vuln>
    <Type>6</Type>
    <File>clsSyncLog.cls</File>
    <File>CommonFunction.cls</File>
    <Code>
      12 Public Class CommonFunction{
    </Code>
  </Vuln>
</Test>
```

```xml
<?xml version="1.0" encoding="UTF-8"?>

<Test xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"">
  <Vuln>
    <Type>REQUIRED - EXACTLY 1 - INTEGER - ID of VulnType. 0 = Custom</Type>
    <CustomTypeName>OPTIONAL - EXACTLY 1 - STRING if TYPE == 0</CustomTypeName>
    <BurpData>OPTIONAL - UNLIMITED - STRING - Burp req/resp data encoded in our protocol</BurpData>
    <URL>OPTIONAL - UNLIMITED - STRING - URL for finding</URL>
    <FileName>OPTIONAL - UNLIMITED - STRING - Name/path of file for finding</FileName>
    <Output>OPTIONAL - UNLIMITED - STRING - Output details</Output>
    <Code>OPTIONAL - UNLIMITED - STRING - Code details</Code>
    <Notes>OPTIONAL - UNLIMITED - STRING - Notes for vuln</Notes>
    <Screenshot>
      OPTIONAL - UNLIMITED - Screenshots of vuln
      <Filename>REQUIRED - EXACTLY 1 - STRING - Filename with extension</Filename>
      <ImageData>
        REQUIRED - EXACTLY 1 - BASE64 - Screenshot data
      </ImageData>
    </Screenshot>
  </Vuln>

  ....unlimited vulns....

  <Vuln>
  </Vuln>
</Test>
```

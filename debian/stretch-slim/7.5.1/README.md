# Supported tags and respective `Dockerfile` links

-	[`7.5.0` (*/debian/stretch-slim/7.5.0/Dockerfile*)](https://github.com/wilkesystems/docker-jira/blob/master/debian/stretch-slim/7.5.0/Dockerfile)
-	[`7.5.1` (*/debian/stretch-slim/7.5.1/Dockerfile*)](https://github.com/wilkesystems/docker-jira/blob/master/debian/stretch-slim/7.5.1/Dockerfile)
-	[`7.5.2` (*/debian/stretch-slim/7.5.2/Dockerfile*)](https://github.com/wilkesystems/docker-jira/blob/master/debian/stretch-slim/7.5.2/Dockerfile)
-	[`7.6.0` (*/debian/stretch-slim/7.6.0/Dockerfile*)](https://github.com/wilkesystems/docker-jira/blob/master/debian/stretch-slim/7.6.0/Dockerfile)
-	[`7.6.1` (*/debian/stretch-slim/7.6.1/Dockerfile*)](https://github.com/wilkesystems/docker-jira/blob/master/debian/stretch-slim/7.6.1/Dockerfile)
-	[`7.6.2` (*/debian/stretch-slim/7.6.2/Dockerfile*)](https://github.com/wilkesystems/docker-jira/blob/master/debian/stretch-slim/7.6.2/Dockerfile)
-	[`7.7.0` (*/debian/stretch-slim/7.7.0/Dockerfile*)](https://github.com/wilkesystems/docker-jira/blob/master/debian/stretch-slim/7.7.0/Dockerfile)
-	[`7.7.1` (*/debian/stretch-slim/7.7.1/Dockerfile*)](https://github.com/wilkesystems/docker-jira/blob/master/debian/stretch-slim/7.7.1/Dockerfile)
-	[`7.7.2` (*/debian/stretch-slim/7.7.2/Dockerfile*)](https://github.com/wilkesystems/docker-jira/blob/master/debian/stretch-slim/7.7.2/Dockerfile)
-	[`7.8.0` (*/debian/stretch-slim/7.8.0/Dockerfile*)](https://github.com/wilkesystems/docker-jira/blob/master/debian/stretch-slim/7.8.0/Dockerfile)
-	[`7.8.1` (*/debian/stretch-slim/7.8.1/Dockerfile*)](https://github.com/wilkesystems/docker-jira/blob/master/debian/stretch-slim/7.8.1/Dockerfile)
-	[`7.8.2` (*/debian/stretch-slim/7.8.2/Dockerfile*)](https://github.com/wilkesystems/docker-jira/blob/master/debian/stretch-slim/7.8.2/Dockerfile)
-	[`7.8.4` (*/debian/stretch-slim/7.8.4/Dockerfile*)](https://github.com/wilkesystems/docker-jira/blob/master/debian/stretch-slim/7.8.4/Dockerfile)
-	[`7.9.0` (*/debian/stretch-slim/7.9.0/Dockerfile*)](https://github.com/wilkesystems/docker-jira/blob/master/debian/stretch-slim/7.9.0/Dockerfile)
-	[`7.9.2` (*/debian/stretch-slim/7.9.2/Dockerfile*)](https://github.com/wilkesystems/docker-jira/blob/master/debian/stretch-slim/7.9.2/Dockerfile)
-	[`7.10.0` (*/debian/stretch-slim/7.10.0/Dockerfile*)](https://github.com/wilkesystems/docker-jira/blob/master/debian/stretch-slim/7.10.0/Dockerfile)
-	[`7.10.1` (*/debian/stretch-slim/7.10.1/Dockerfile*)](https://github.com/wilkesystems/docker-jira/blob/master/debian/stretch-slim/7.10.1/Dockerfile)
-	[`7.10.2` (*/debian/stretch-slim/7.10.2/Dockerfile*)](https://github.com/wilkesystems/docker-jira/blob/master/debian/stretch-slim/7.10.2/Dockerfile)
-	[`7.11.0` (*/debian/stretch-slim/7.11.0/Dockerfile*)](https://github.com/wilkesystems/docker-jira/blob/master/debian/stretch-slim/7.11.0/Dockerfile)
-	[`7.11.1` (*/debian/stretch-slim/7.11.1/Dockerfile*)](https://github.com/wilkesystems/docker-jira/blob/master/debian/stretch-slim/7.11.1/Dockerfile)
-	[`7.11.2` (*/debian/stretch-slim/7.11.2/Dockerfile*)](https://github.com/wilkesystems/docker-jira/blob/master/debian/stretch-slim/7.11.2/Dockerfile)
-	[`7.12.0` (*/debian/stretch-slim/7.12.0/Dockerfile*)](https://github.com/wilkesystems/docker-jira/blob/master/debian/stretch-slim/7.12.0/Dockerfile)
-	[`7.12.1`, `latest` (*/debian/stretch-slim/7.12.1/Dockerfile*)](https://github.com/wilkesystems/docker-jira/blob/master/debian/stretch-slim/7.12.1/Dockerfile)


![Atlassian JIRA Software](https://github.com/wilkesystems/docker-jira/raw/master/docs/logo.png)

Jira is a proprietary issue tracking product, developed by Atlassian. It provides bug tracking, issue tracking, and project management functions. Although often styled using all-capital letters as "JIRA", the product name is not an acronym, but a truncation of Gojira, the Japanese name for Godzilla, itself a reference to Jira's main competitor, Bugzilla. It has been developed since 2002. According to one ranking method, as of June 2017, Jira is the most popular issue management tool.
 
Learn more about Jira Server: <https://www.atlassian.com/software/jira>

You can find the repository for this Dockerfile at <https://hub.docker.com/r/wilkesystems/jira>
 
# Overview
 
This Docker container makes it easy to get an instance of Jira up and running.
 
# Quick Start
 
For the directory in the environmental variable `JIRA_HOME` that is used to store Jira data
(amongst other things) we recommend mounting a host directory as a [data volume](https://docs.docker.com/userguide/dockervolumes/#mount-a-host-directory-as-a-data-volume):
 
Start Atlassian Jira Server:
 
    $> docker run -v /data/your-jira-home:/var/atlassian/application-data/jira --name="jira" -d -p 8090:8090 -p 8080 wilkesystems/jira
 

**Success**. Jira is now available on [http://localhost:8080](http://localhost:8080)*
 
Please ensure your container has the necessary resources allocated to it.
We recommend 2GiB of memory allocated to accommodate the application server.
See [Supported Platforms](https://confluence.atlassian.com/display/DOC/Supported+platforms) for further information.
     
 
_* Note: If you are using `docker-machine` on Mac OS X, please use `open http://$(docker-machine ip default):8080` instead._
 
## Memory / Heap Size

If you need to override Jira Server's default memory allocation, you can control the minimum heap (Xms) and maximum heap (Xmx) via the below environment variables.

* `JVM_MINIMUM_MEMORY` (default: 1024m)

   The minimum heap size of the JVM

* `JVM_MAXIMUM_MEMORY` (default: 1024m)

   The maximum heap size of the JVM

## Reverse Proxy Settings

If Jira is run behind a reverse proxy server, then you need to specify extra options to make Jira aware of the setup. They can be controlled via the below environment variables.

* `CATALINA_CONNECTOR_PROXYNAME` (default: NONE)

   The reverse proxy's fully qualified hostname.

* `CATALINA_CONNECTOR_PROXYPORT` (default: NONE)

   The reverse proxy's port number via which Jira is accessed.

* `CATALINA_CONNECTOR_SCHEME` (default: http)

   The protocol via which Jira is accessed.

* `CATALINA_CONNECTOR_SECURE` (default: false)

   Set 'true' if CATALINA_CONNECTOR_SCHEME is 'https'.

## JVM configuration

If you need to pass additional JVM arguments to Jira such as specifying a custom trust store, you can add them via the below environment variable

* `JVM_SUPPORT_RECOMMENDED_ARGS`

   Additional JVM arguments for Jira
   
Example:

    $> docker run -e JVM_SUPPORT_RECOMMENDED_ARGS=-Djavax.net.ssl.trustStore=/var/atlassian/application-data/jira/cacerts -v confluenceVolume:/var/atlassian/application-data/confluence --name="confluence" -d -p 8080:8080 wilkesystems/jira

 
# Upgrade
 
To upgrade to a more recent version of Jira Server you can simply stop the `Jira`
container and start a new one based on a more recent image:
 
    $> docker stop jira
    $> docker rm jira
    $> docker run ... (see above)
 
As your data is stored in the data volume directory on the host, it will still
be available after the upgrade.
 
_Note: Please make sure that you **don't** accidentally remove the `jira`
container and its volumes using the `-v` option._
 
# Versioning
 
The `latest` tag matches the most recent release of Atlassian Jira Server.
So `wilkesystems/jira:latest` will use the newest stable version of Jira Server available.
 
Alternatively, you can use a specific minor version of Jira Server by using a version number
tag: `wilkesystems/jira:7.5.1`. This will install the latest `7.5.x` version that
is available.

# Support

For product support go to [support.atlassian.com](http://support.atlassian.com).  

# Auto Builds

New images are automatically built by each new debian library push.

[![Docker build](https://dockeri.co/image/wilkesystems/jira)](https://hub.docker.com/r/wilkesystems/jira/)
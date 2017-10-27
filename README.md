STOP-HCV LabKey Installation Containers
==========

This repository contains docker and installation files in order to set up a  [LabKey Server](https://www.labkey.org/) in [Docker](https://www.docker.com).


## Architecture
LabKey runs under Apache Tomcat, both of which require Java Server JRE.

LabKey also requires a database for internal storage.

For user administration an SMTP server is desirable in order to send User information on creation and password reset information.

### stophcv_labkey
*Located in the [/stophcv_labkey](/stophcv_labkey) folder*

* **labkey_core**: Dockerfile and other source files needed for building a Docker image that runs LabKey Server.
    * See the [labkey_core README](/stophcv_labkey/labkey_core/README.md) file for further details.
* **lkey_userdb**: Dockerfile and other source files needed for building a Docker image that provides a back end database required by labkey-core.
    * See the [labkey_db README](/stophcv_labkey/labkey_db/README.md) file for further details.
* **labkey_smtp**: Dockerfile and other source files needed for building a Docker image that provides an smtp mail daemon.
    * See the [labkey_smtp README](/stophcv_labkey/labkey_smtp/README.md) file for further details (not yet implemented).
* **stop_hcv_db**: Dockerfile and other source files needed for building a Docker image that provides a database containing the STOP-HCV metadata accessed by labkey-core.
    * See the [stophcv_db README](/stophcv_labkey/stophcv_db/README.md) file for further details.

## Infrastructure
In order for the various Docker containers created above to be able to talk to each other a docker network needs to be created. The name used in all examples is 'labkey_net'.

```Docker
docker network create labkey_net
```
## Support

If you need support using these docker builds, please contact:

- Graham Addis (graham.addis@ndm.ox.ac.uk)

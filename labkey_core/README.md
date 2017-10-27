STOP-HCV LabKey Core Application Container
==========

This repository contains docker and installation files in order to set up the core LabKey components required to provide a LabKey Server installation  [LabKey Server](https://www.labkey.org/) in [Docker](https://www.docker.com).


## Components
The core Docker image is based on the **[tomcat:8.2.3](https://hub.docker.com/_/tomcat/)** image from **[Docker Hub](https://hub.docker.com/)**  repository.

The Tomcat version used is 8.2.3, which is based on the **[openjdk](https://hub.docker.com/r/_/openjdk/)**:8-jre Docker image.

LabKey also requires a database for internal storage. See: [labkey_db README](../labkey_db/README.md).

For user administration an SMTP server is desirable in order to send User information on creation and password reset information. See: [labkey_smtp README](../labkey_smtp/README.md).

To build the labkey_core docker image use the following command from within the labkey_core directory.

```
docker build -t labkey_core .
```

To run up the labkey core component use the following command:
```
docker run -d --network labkey_net -p 8080:8080 --name labkey_core labkey_core
```

The username and password configured for the stop_hcv_db must correspond for the stop_hcv_db and labkey_core containers.

The username and password configured for the lkey_userdb must correspond for the lkey_userdb and labkey_core containers.
```
-----------------------------------------------------------------------------------------------------
|Item                | Container | Defined in           | Variable Name   | Default Value           |
-----------------------------------------------------------------------------------------------------
|stop_hcv_db username|labkey_core|labkey_core/Dockerfile|SHCVDB_USER      |'postgres'               |
|stop_hcv_db password|labkey_core|labkey_core/Dockerfile|SHCVDB_PASSWORD  |'passwordForStopHcvDb'   |
|stop_hcv_db username|stop_hcv_db|stop_hcv_db/Dockerfile|POSTGRES_USER    |'postgres'               |
|stop_hcv_db password|stop_hcv_db|stop_hcv_db/Dockerfile|POSTGRES_PASSWORD|'passwordForStopHcvDb'   |
-----------------------------------------------------------------------------------------------------
|lkey_userdb username|labkey_core|labkey_core/Dockerfile|LKDB_USER        |'postgres'               |
|lkey_userdb password|labkey_core|labkey_core/Dockerfile|LKDB_PASSWORD    |'passwordForLabkeyUserDb'|
|lkey_userdb username|lkey_userdb|lkey_userdb/Dockerfile|POSTGRES_USER    |'postgres'               |
|lkey_userdb password|lkey_userdb|lkey_userdb/Dockerfile|POSTGRES_PASSWORD|'passwordForLabkeyUserDb'|
-----------------------------------------------------------------------------------------------------
```

The default master encryption key for LabKey is set to 'encryptionKeyForLabKey32AsciiCh' and is defined as LABKEY_ENCRYPTION_KEY in the labkey_core Dockerfile.

To override these values when invoking the labkey_core docker image use the following command.
```
docker run -d --network labkey_net \
            -p 8080:8080 \
            --name labkey_core \
            -e SHCVDB_PASSWORD=newPasswordForStopHcvDb \
            -e SHCVDB_USER=newUsernameForStopHcvDb \
            -e LKDB_PASSWORD=newPasswordForLabKeyDb \
            -e LKDB_USER=newUsernameForLabKeyDb \
            -e LABKEY_ENCRYPTION_KEY=chooseRandom32AsciiOr64HexPWord \
            labkey_core
```

## Infrastructure
In order for the various Docker containers created above to be able to talk to each other a docker network needs to be created. The name used in all examples is 'labkey_net'.

```Docker
docker network create labkey_net
```
## Support

If you need support using these docker builds, please contact:

- Graham Addis (graham.addis@ndm.ox.ac.uk)

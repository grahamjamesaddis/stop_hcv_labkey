STOP-HCV LabKey Database Application Container
==========

This repository contains docker and installation files in order to set up the LabKey database components required to provide a LabKey Server installation  [LabKey Server](https://www.labkey.org/) in [Docker](https://www.docker.com).


## Components
The database Docker image is based on the **[postgres](https://hub.docker.com/_/postgres/)**:9.6 image from **[Docker Hub](https://hub.docker.com/)**  repository.

The Postgres version used 9.6, which is based on the **[debian](https://hub.docker.com/r/_/debian/)**:jessie Docker image.

To build the lkey_userdb docker image use the following command from within the labkey_db directory.

```
docker build -t lkey_userdb .
```

To run up the labkey user db component use the following command:
```
docker run -d --network labkey_net --name lkey_userdb lkey_userdb
```

The username and password configured for the lkey_userdb must correspond for the lkey_userdb and labkey_core containers.
```
-----------------------------------------------------------------------------------------------------
|Item                | Container | Defined in           | Variable Name   | Default Value           |
-----------------------------------------------------------------------------------------------------
|lkey_userdb username|labkey_core|labkey_core/Dockerfile|LKDB_USER        |'postgres'               |
|lkey_userdb password|labkey_core|labkey_core/Dockerfile|LKDB_PASSWORD    |'passwordForLabkeyUserDb'|
|lkey_userdb username|lkey_userdb|lkey_userdb/Dockerfile|POSTGRES_USER    |'postgres'               |
|lkey_userdb password|lkey_userdb|lkey_userdb/Dockerfile|POSTGRES_PASSWORD|'passwordForLabkeyUserDb'|
-----------------------------------------------------------------------------------------------------
```

To override these values when invoking the lkey_userdb docker image use the following command.
```
docker run -d --network labkey_net \
           --name lkey_userdb \
           -e POSTGRES_PASSWORD=newPasswordForLabKeyDb \
           -e POSTGRES_USER=newUsernameForLabKeyDb \
           lkey_userdb
```

For the STOP-HCV project a second database containing the clinical, viral sequencing and host genotyping data is also required.

To run up the labkey user db component use the following command:

A string substitution appears to be made by the application on the hostname in the labkey.xml file which results in the application being unable to find the host. e.g. a host name of 'lkey_userdb' works, whereas 'labkey_userdb' does not.

## Infrastructure
In order for the various Docker containers created above to be able to talk to each other a docker network needs to be created. The name used in all examples is 'labkey_net'.

```Docker
docker network create labkey_net
```
## Support

If you need support using these docker builds, please contact:

- Graham Addis (graham.addis@ndm.ox.ac.uk)

STOP-HCV Clinical Database Application Container
==========

This repository contains docker and installation files in order to set up the LabKey database components required to provide a LabKey Server installation  [LabKey Server](https://www.labkey.org/) in [Docker](https://www.docker.com).


## Components
The database Docker image is based on the **[postgres](https://hub.docker.com/_/postgres/)**:9.6 image from **[Docker Hub](https://hub.docker.com/)**  repository.

The Postgres version used 9.6, which is based on the **[debian](https://hub.docker.com/r/_/debian/)**:jessie Docker image.

For the STOP-HCV project a second database containing the clinical, viral sequencing and host genotyping data is also required.

To build the stop_hcv_db docker image use the following command from within the stop_hcv_db directory.

```
docker build -t stop_hcv_db .
```

To run up the STOP-HCV db component use the following command:
```
docker run -d --network labkey_net --name stop_hcv_db stop_hcv_db
```

The username and password configured for the stop_hcv_db must correspond for the stop_hcv_db and labkey_core containers.
```
-----------------------------------------------------------------------------------------------------
|Item                | Container | Defined in           | Variable Name   | Default Value           |
-----------------------------------------------------------------------------------------------------
|stop_hcv_db username|labkey_core|labkey_core/Dockerfile|SHCVDB_USER      |'postgres'               |
|stop_hcv_db password|labkey_core|labkey_core/Dockerfile|SHCVDB_PASSWORD  |'passwordForStopHcvDb'   |
|stop_hcv_db username|stop_hcv_db|stop_hcv_db/Dockerfile|POSTGRES_USER    |'postgres'               |
|stop_hcv_db password|stop_hcv_db|stop_hcv_db/Dockerfile|POSTGRES_PASSWORD|'passwordForStopHcvDb'   |
-----------------------------------------------------------------------------------------------------
```

To override these values when invoking the stop_hcv_db docker image use the following command.
```
docker run -d --network labkey_net \
           --name stop_hcv_db \
           -e POSTGRES_PASSWORD=newPasswordForStopHcvDb \
           -e POSTGRES_USER=newUsernameForStopHcvDb \
           stop_hcv_db
```


In order to load the clinical data:

Copy the clinical data into the instance:

```
docker cp clinical_data.sql stop_hcv_db:/tmp
```

Start a shell within the stop_hcv_db:

```
docker exec -i -t stop_hcv_db sh
```

Use psql to run the sql commands:

```
psql -U postgres
```

At the psql prompt ' ' create the stop_hcv database and load the clinical data:
```
CREATE DATABASE stop_hcv;
\c stop_hcv
\i /tmp/clinical_data.sql
```

An alternative is to use a second temporary instance of the stop_hcv_db image to load the data:

```
docker run -it --rm --network labkey_net --name dbloader stop_hcv_db sh
```

In a separate window load the data into the temporary loader instance.

```
docker cp clinical_data.sql dbloader:/tmp
```

At the dbloader shell prompt '#' invoke psql and connect to the stop_hcv_db host as the db user, e.g. postgres:
```
psql -h stop_hcv_db -U postgres
```

At the psql prompt ' ' create the stop_hcv database and load the clinical data:
```
CREATE DATABASE stop_hcv;
\c stop_hcv
\i /tmp/clinical_data.sql
```
Note: as of LabKey version 17.2 hostnames starting with 'labkey' cannot be used with with the LabKey application.

A string substitution appears to be made by the application on the hostname in the labkey.xml file which results in the application being unable to find the host. e.g. a host name of 'lkey_userdb' works, whereas 'labkey_userdb' does not.

## Infrastructure
In order for the various Docker containers created above to be able to talk to each other a docker network needs to be created. The name used in all examples is 'labkey_net'.

```Docker
docker network create labkey_net
```
## Support

If you need support using these docker builds, please contact:

- Graham Addis (graham.addis@ndm.ox.ac.uk)

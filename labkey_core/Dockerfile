FROM tomcat:8.5.23-alpine
LABEL maintainer="Graham.Addis@ndm.ox.ac.uk"
MAINTAINER Graham.Addis@ndm.ox.ac.uk
# credit to bconn@labkey.com for portions of the setup,
# See https://github.com/LabKey/samples

# The defaults are set so you can get an insecure system up and running
# Make sure you override these at build time.
ARG LKDB_USER=postgres
ARG LKDB_PASSWORD=passwordForLabkeyUserDb
ARG SHCVDB_USER=postgres
ARG SHCVDB_PASSWORD=passwordForStopHcvDb
ARG LABKEY_ENCRYPTION_KEY=encryptionKeyForLabKey32AsciiCh
ARG LABKEY_SMTP_HOST=labkey_smtp
ARG LABKEY_SMTP_PORT=25
ARG LABKEY_SMTP_USER=labkey@labkey_core

ENV LABKEY_PREFIX=LabKey \
    LABKEY_VERSION=17.3 \
    LABKEY_DIST=17.3-55100.13-community \
    LKDB_USER=$LKDB_USER \
    LKDB_PASSWORD=$LKDB_PASSWORD \
    LKDB_HOST=lkey_userdb \
    SHCVDB_USER=$SHCVDB_USER \
    SHCVDB_PASSWORD=$SHCVDB_PASSWORD \
    SHCVDB_HOST=stop_hcv_db \
    LABKEY_SMTP_HOST=$LABKEY_SMTP_HOST \
    LABKEY_SMTP_PORT=$LABKEY_SMTP_PORT \
    LABKEY_SMTP_USER=$LABKEY_SMTP_USER \
    LABKEY_ENCRYPTION_KEY=$LABKEY_ENCRYPTION_KEY \
    CATALINA_BASE=/usr/local/tomcat \
    CATALINA_HOME=/usr/local/tomcat

RUN addgroup -g 3000 tomcat && \
    adduser -D -u 3000 -G tomcat tomcat

#
# Install the LabKey Server and Configure
#

RUN mkdir -p /labkey/bin && \
    mkdir -p /labkey/src && \
    mkdir -p /labkey/labkey

RUN cd /labkey/src && wget --no-verbose http://labkey.s3.amazonaws.com/downloads/general/r/$LABKEY_VERSION/$LABKEY_PREFIX$LABKEY_DIST-bin.tar.gz

# If you want to download a LabKey distribution by hand, put it in the
# labkey_core directory and use a command something like one of these.
# Don't forget to comment out the 'wget' above.
# COPY $LABKEY_PREFIX$LABKEY_DIST-bin.tar.gz /labkey/src/$LABKEY_PREFIX$LABKEY_DIST-bin.tar.gz
# COPY Labkey17.2-52553-community-bin.tar.gz /labkey/src/Labkey17.2-52553-community-bin.tar.gz
# COPY LabKey17.3-55100.13-community-bin.tar.gz /labkey/src/LabKey17.3-55100.13-community-bin.tar.gz

RUN cd /labkey/src && \
    tar xzf /labkey/src/$LABKEY_PREFIX$LABKEY_DIST-bin.tar.gz && \
    cp -R $LABKEY_PREFIX$LABKEY_DIST-bin/modules /labkey/labkey && \
    cp -R $LABKEY_PREFIX$LABKEY_DIST-bin/labkeywebapp /labkey/labkey && \
    cp -R $LABKEY_PREFIX$LABKEY_DIST-bin/pipeline-lib /labkey/labkey && \
    cp -f $LABKEY_PREFIX$LABKEY_DIST-bin/tomcat-lib/*.jar $CATALINA_BASE/lib/ && \
    mkdir /labkey/labkey/files && \
    chown -R tomcat.tomcat /labkey/labkey && \
    rm -rf $LABKEY_PREFIX$LABKEY_DIST-bin && \
    rm $LABKEY_PREFIX$LABKEY_DIST-bin.tar.gz


COPY labkey/labkey.xml_src ${CATALINA_HOME}/conf/Catalina/localhost/labkey.xml_src
COPY labkey/configure_labkey_xml.sh /labkey/bin

RUN cd /labkey/bin && \
    chown tomcat.tomcat configure_labkey_xml.sh && \
    chmod +x configure_labkey_xml.sh

CMD ["/labkey/bin/configure_labkey_xml.sh", "run"]

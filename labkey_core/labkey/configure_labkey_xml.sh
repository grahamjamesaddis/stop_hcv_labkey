#!/bin/sh
#
# Copies the labkey_xml_src to ROOT.xml, adjusting for environment variables
# set at Docker build or run time, before calling the catalina.sh start script.

cd ${CATALINA_HOME}/conf/Catalina/localhost

sed \
-e "s/@@jdbcUser@@/$LKDB_USER/" \
-e "s/@@jdbcPassword@@/$LKDB_PASSWORD/" \
-e "s/@@jdbcHost@@/$LKDB_HOST/" \
-e "s/@@shcvUser@@/$SHCVDB_USER/" \
-e "s/@@shcvPassword@@/$SHCVDB_PASSWORD/" \
-e "s/@@shcvHost@@/$SHCVDB_HOST/" \
-e "s/@@masterEncryptionKey@@/$LABKEY_ENCRYPTION_KEY/" \
-e "s/@@smtpHost@@/$LABKEY_SMTP_HOST/" \
-e "s/@@smtpUser@@/$LABKEY_SMTP_USER/" \
-e "s/@@smtpPort@@/$LABKEY_SMTP_PORT/" \
labkey.xml_src > ROOT.xml

catalina.sh $@

FROM registry.camunda.cloud/camunda-bpm-platform-ee:tomcat-7.10.5
# see: https://docs.camunda.org/manual/latest/installation/docker/

# timezone
ENV TZ=Europe/Berlin

# Remove Tomcat example applications
# see also https://tomcat.apache.org/tomcat-9.0-doc/security-howto.html
RUN rm -fr /camunda/webapps/ROOT \
           /camunda/webapps/docs \
           /camunda/webapps/examples \
           /camunda/webapps/host-manager \
           /camunda/webapps/manager \
# remove Camunda example applications
           /camunda/webapps/camunda-welcome \
           /camunda/webapps/camunda-invoice \
           #/camunda/webapps/engine-rest
           /camunda/webapps/h2 \
# remove Groovy scripting language
           /camunda/lib/groovy-all-*.jar \
# remove connectors
           /camunda/lib/camunda-connect-*.jar \
           /camunda/lib/camunda-engine-plugin-connect-*.jar && \
   xmlstarlet edit --ps --inplace \
   -N 'N=http://www.camunda.org/schema/1.0/BpmPlatform' \
   --delete "//N:plugin[N:class = 'org.camunda.connect.plugin.impl.ConnectProcessEnginePlugin']" \
   /camunda/conf/bpm-platform.xml && \
# add SQL connection check
# <Resource name="jdbc/ProcessEngine" testOnBorrow="true" validationQuery="SELECT 1" />
    xmlstarlet edit --ps --inplace \
    --insert "//Resource[@name='jdbc/ProcessEngine']" --type attr \
    -n testOnBorrow -v true \
    --insert "//Resource[@name='jdbc/ProcessEngine']" --type attr \
    -n validationQuery -v "SELECT 1" \
    /camunda/conf/server.xml && \
# disable JDBC batching since it doesn't work on old Oracle version and maybe PostgreSQL
# see: https://github.com/camunda/docker-camunda-bpm-platform/issues/80
# see: https://docs.camunda.org/manual/latest/user-guide/process-engine/database/#jdbc-batch-processing
# <property name="jdbcBatchProcessing">false</property>
    xmlstarlet edit --ps --inplace \
    -N 'N=http://www.camunda.org/schema/1.0/BpmPlatform' \
    --subnode '//N:properties' -t elem -n property -v "false" \
    --insert '$prev' -t 'attr' -n 'name' -v 'jdbcBatchProcessing' \
    /camunda/conf/bpm-platform.xml && \
# Enable HTTP Basic Authentication for Camunda REST API
# see: https://docs.camunda.org/manual/latest/user-guide/security/
   sed -i -e 's#<!-- <filter>#<filter>#' -e 's#</filter-mapping> -->#</filter-mapping>#' \
   /camunda/webapps/engine-rest/WEB-INF/web.xml && \
# Remove unused Tomcat Connectors
# By default, an HTTP and an AJP connector are configured. Connectors that will not be used should be removed from server.xml.
# see: https://tomcat.apache.org/tomcat-9.0-doc/security-howto.html#Connectors
# <Connector port="8009" protocol="AJP/1.3" redirectPort="8443" />
   xmlstarlet edit --ps --inplace \
   --delete '//Connector[@protocol="AJP/1.3"]' \
   /camunda/conf/server.xml

# TODO Configure LDAP

# TODO SSL either via API Gateway/Reverse Proxy or in Tomcat
# see: https://tomcat.apache.org/tomcat-9.0-doc/ssl-howto.html

# TODO Maybe enable Security manager
# Enabling the security manager causes web applications to be run in a sandbox, significantly limiting a web application's ability to perform malicious actions such as calling System.exit(), establishing network connections or accessing the file system outside of the web application's root and temporary directories.
# see: https://tomcat.apache.org/tomcat-9.0-doc/security-howto.html#Security_manager

# TODO Maybe use Hikari connection pool
# see: https://community.liferay.com/blogs/-/blogs/tomcat-hikaricp
# see: https://github.com/brettwooldridge/HikariCP#configuration-knobs-baby

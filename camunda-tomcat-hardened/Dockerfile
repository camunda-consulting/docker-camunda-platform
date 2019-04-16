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
           /camunda/lib/camunda-connect-*.jar \
           /camunda/lib/camunda-engine-plugin-connect-*.jar \
           /camunda/lib/groovy-all-*.jar \
   && \
   xmlstarlet ed -P --inplace \
   -N 'N=http://www.camunda.org/schema/1.0/BpmPlatform' \
   -d "//N:plugin[N:class = 'org.camunda.connect.plugin.impl.ConnectProcessEnginePlugin']" \
   /camunda/conf/bpm-platform.xml && \
# add SQL connection check
# <Resource name="jdbc/ProcessEngine" testOnBorrow="true" validationQuery="SELECT 1" />
    xmlstarlet ed -P --inplace \
    --insert "//Resource[@name='jdbc/ProcessEngine']" --type attr \
    -n testOnBorrow -v true \
    --insert "//Resource[@name='jdbc/ProcessEngine']" --type attr \
    -n validationQuery -v "SELECT 1" /camunda/conf/server.xml && \
# disable JDBC batching since it doesn't work on old Oracle version and maybe PostgreSQL
# see: https://github.com/camunda/docker-camunda-bpm-platform/issues/80
# see: https://docs.camunda.org/manual/latest/user-guide/process-engine/database/#jdbc-batch-processing
# <property name="jdbcBatchProcessing">false</property>
    xmlstarlet ed -P --inplace \
    -N 'N=http://www.camunda.org/schema/1.0/BpmPlatform' -s '//N:properties' \
    -t elem -n property -v "false" /camunda/conf/bpm-platform.xml && \
    xmlstarlet ed -P --inplace \
    -N 'N=http://www.camunda.org/schema/1.0/BpmPlatform' -i '//N:property[not(@name)]' \
    -t 'attr' -n 'name' -v 'jdbcBatchProcessing' /camunda/conf/bpm-platform.xml

# TODO REST Security
# see: https://docs.camunda.org/manual/latest/user-guide/security/

# TODO SSL either via API Gateway/Reverse Proxy or in Tomcat
# see: https://tomcat.apache.org/tomcat-9.0-doc/ssl-howto.html

# TODO Maybe enable Security manager
# Enabling the security manager causes web applications to be run in a sandbox, significantly limiting a web application's ability to perform malicious actions such as calling System.exit(), establishing network connections or accessing the file system outside of the web application's root and temporary directories.
# see: https://tomcat.apache.org/tomcat-9.0-doc/security-howto.html#Security_manager

# TODO Remove unused Tomcat Connectors
# By default, an HTTP and an AJP connector are configured. Connectors that will not be used should be removed from server.xml.
# see: https://tomcat.apache.org/tomcat-9.0-doc/security-howto.html#Connectors

# TODO Maybe use Hikari connection pool

# TODO Configure LDAP

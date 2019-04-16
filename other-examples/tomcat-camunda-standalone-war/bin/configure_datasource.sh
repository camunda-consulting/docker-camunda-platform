#!/bin/bash

if [ -f /.datasource_configured ]; then
    echo "Datasource already configured"
    exit 0
fi

#!/bin/bash

DB_DRIVER=${DB_DRIVER:-org.h2.Driver}
DB_URL=${DB_URL:-jdbc:h2:./camunda-db/process-engine;MVCC=TRUE;TRACE_LEVEL_FILE=0;DB_CLOSE_ON_EXIT=FALSE}
DB_USERNAME=${DB_USERNAME:-sa}
DB_PASSWORD=${DB_PASSWORD:-sa}

XML_JDBC="//Resource[@name='jdbc/ProcessEngine']"
XML_DRIVER="${XML_JDBC}/@driverClassName"
XML_URL="${XML_JDBC}/@url"
XML_USERNAME="${XML_JDBC}/@username"
XML_PASSWORD="${XML_JDBC}/@password"

if [ -z "$SKIP_DB_CONFIG" ]; then
  echo "Configure Camunda database"
  xmlstarlet ed -L \
    -u "//*[local-name()='bean' and @id='dataSource']//*[local-name()='property' and @name='driverClassName']/@value" -v "${DB_DRIVER}" \
    -u "//*[local-name()='bean' and @id='dataSource']//*[local-name()='property' and @name='url']/@value" -v "${DB_URL}" \
    -u "//*[local-name()='bean' and @id='dataSource']//*[local-name()='property' and @name='username']/@value" -v "${DB_USERNAME}" \
    -u "//*[local-name()='bean' and @id='dataSource']//*[local-name()='property' and @name='password']/@value" -v "${DB_PASSWORD}" \
    ${CATALINA_HOME}/webapps/ROOT/WEB-INF/applicationContext.xml
fi

#HOST=${MYSQL_HOST:-db}
#PORT=${MYSQL_PORT:-3306}
#DATABASE=${MYSQL_DATABASE:-osdb}
#USER=${MYSQL_USER:-root}
#PASSWORD=${MYSQL_PASSWORD:-password}

touch /.datasource_configured

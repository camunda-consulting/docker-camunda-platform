FROM postgres:9.4-alpine
# Camunda is currently supported on PostgreSQL 9.4.
# See also: https://docs.camunda.org/manual/latest/introduction/supported-environments/

# install a wget version that supports SSL and login
RUN apk --no-cache add ca-certificates wget && update-ca-certificates

# no suffix '-ee' in CAMUNDA_VERSION!
ENV CAMUNDA_VERSION 7.6.2

# Put your EE credentials into the following file
COPY camunda-enterprise-login.env .

# download SQL scripts for Camunda BPM
# (All releases contain the same SQL scripts. Oracle WLS is just used to keep the download small.)
RUN export $(cat camunda-enterprise-login.env | xargs) && \
    wget -O - "https://camunda.org/enterprise-release/camunda-bpm/oracle-wls/$(echo $CAMUNDA_VERSION | cut -c 1-3)/${CAMUNDA_VERSION}/camunda-ee-oracle-wls-${CAMUNDA_VERSION}-ee.tar.gz" --user=${EE_USERNAME} --password=${EE_PASSWORD} | \
    tar xzf - --directory /docker-entrypoint-initdb.d/ "sql/create/postgres_engine_${CAMUNDA_VERSION}-ee.sql" "sql/create/postgres_identity_${CAMUNDA_VERSION}-ee.sql" --strip 2

# clean up
RUN rm camunda-enterprise-login.env

# Put your EE license into the following file
COPY camunda-enterprise-license.sql /docker-entrypoint-initdb.d/postgres_license.sql
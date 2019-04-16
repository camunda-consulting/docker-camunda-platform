FROM registry.camunda.cloud/camunda-bpm-platform-ee:tomcat-7.10.5 as source
# see: https://docs.camunda.org/manual/latest/installation/docker/

USER root

RUN apk --no-cache add unzip

RUN unzip /camunda/lib/camunda-engine-7.*-ee.jar -d /camunda-engine-jar

FROM postgres:10.4-alpine
# Camunda BPM 7.10.x is supported on PostgreSQL 10.4
# See also: https://docs.camunda.org/manual/latest/introduction/supported-environments/

COPY --from=source /camunda-engine-jar/org/camunda/bpm/engine/db/create/*.postgres.create.engine.sql           /docker-entrypoint-initdb.d/01.engine.sql
COPY --from=source /camunda-engine-jar/org/camunda/bpm/engine/db/create/*.postgres.create.history.sql          /docker-entrypoint-initdb.d/02.history.sql
COPY --from=source /camunda-engine-jar/org/camunda/bpm/engine/db/create/*.postgres.create.identity.sql         /docker-entrypoint-initdb.d/03.identity.sql
COPY --from=source /camunda-engine-jar/org/camunda/bpm/engine/db/create/*.postgres.create.case.engine.sql      /docker-entrypoint-initdb.d/04.case.engine.sql
COPY --from=source /camunda-engine-jar/org/camunda/bpm/engine/db/create/*.postgres.create.case.history.sql     /docker-entrypoint-initdb.d/05.case.history.sql
COPY --from=source /camunda-engine-jar/org/camunda/bpm/engine/db/create/*.postgres.create.decision.engine.sql  /docker-entrypoint-initdb.d/06.decision.engine.sql
COPY --from=source /camunda-engine-jar/org/camunda/bpm/engine/db/create/*.postgres.create.decision.history.sql /docker-entrypoint-initdb.d/07.decision.history.sql

# Put your EE license into the following file
COPY camunda-enterprise-license.sql /docker-entrypoint-initdb.d/08.license.sql

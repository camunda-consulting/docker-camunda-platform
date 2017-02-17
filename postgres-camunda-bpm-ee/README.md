Camunda BPM EE Docker PostgreSQL
================================

PostgreSQL Docker image for Camunda BPM Enterprise Edition based on the [official PostgreSQL image][postgres].

# Configuration

  1. Put your EE credentials into [camunda-enterprise-login.env](camunda-enterprise-login.env).
  2. Put your EE license into [camunda-enterprise-license.sql](camunda-enterprise-license.sql).

# Additional Packages

  - wget
  - ca-certificates

# PostgresSQL User

  - `postgres` without password
  - `camunda` with password `camunda`

# Database

  - `camunda`

# Usage (local)

```
# Start docker container
docker run -d -p 5432:5432 camunda-ee-postgresql
```

[postgres]: https://hub.docker.com/_/postgres/

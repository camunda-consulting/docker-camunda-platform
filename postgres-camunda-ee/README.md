# Camunda BPM EE Docker PostgreSQL

PostgreSQL Docker image for Camunda BPM Enterprise Edition based on the [official PostgreSQL image][postgres].

## Configuration

Put your EE license into [camunda-enterprise-license.sql](camunda-enterprise-license.sql).

## PostgresSQL User

- `postgres` without password
- `camunda` with password `camunda`

## Database

- `camunda`

## Usage (local)

```bash
# Start docker container
docker run -d -p 5432:5432 camunda-ee-postgresql
```

[postgres]: https://hub.docker.com/_/postgres/
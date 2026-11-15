---
alwaysApply: false
applyTo: "**/{docker-compose,compose}.{yml,yaml},**/{docker-compose,compose}.*.{yml,yaml}"
description: Docker Compose conventions
globs: ["**/{docker-compose,compose}.{yml,yaml}", "**/{docker-compose,compose}.*.{yml,yaml}"]
paths: ["**/{docker-compose,compose}.{yml,yaml}", "**/{docker-compose,compose}.*.{yml,yaml}"]
trigger: glob
---

# Docker Compose

Follow these sources in order. A source that is missing, or too vague to settle the case, is completed by the next one for that point only:

1. The `docker-skills:docker-compose-patterns` skill, invoked, never consulted online
2. [**Compose** specification](https://github.com/compose-spec/compose-spec/blob/main/spec.md)

The rules in this file override all of them on any conflict.

## File

- Prefer the `docker-compose.yml` filename. `compose.yml` is fine too.
- Skip the `version:` field, removed in Compose v2.

## Services

Order the keys like this, omitting the ones you don't need:

1. `build` / `image`
2. `container_name`
3. `restart`
4. `environment`
5. `volumes`
6. `ports`
7. `depends_on`
8. `healthcheck`

Put any unlisted key after these, alphabetically.

## Restart policy

- Set `restart: unless-stopped` on long-running services.
- Set `restart: on-failure` on one-shot and migration containers.

## Environment variables

- Write `environment:` in map syntax:

```yaml
environment:
  POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
  POSTGRES_USER: app
```

## depends_on

- For a long-running service, use `condition: service_healthy` when the dependent needs it ready for connections (database, broker), otherwise `condition: service_started`.
- Give that service a `healthcheck:` block when its image has no native `HEALTHCHECK`.
- Use `condition: service_completed_successfully` for a one-shot container (migration, seed, init) that must exit successfully before its dependent starts:

```yaml
depends_on:
  db:
    condition: service_healthy
  migrate:
    condition: service_completed_successfully
```

---
alwaysApply: false
applyTo: "**/{docker-compose,compose}.{yml,yaml},**/{docker-compose,compose}.*.{yml,yaml}"
description: Docker Compose conventions
globs: ["**/{docker-compose,compose}.{yml,yaml}", "**/{docker-compose,compose}.*.{yml,yaml}"]
paths: ["**/{docker-compose,compose}.{yml,yaml}", "**/{docker-compose,compose}.*.{yml,yaml}"]
trigger: glob
---

# Docker Compose

## File

- Prefer the `docker-compose.yml` filename. `compose.yml` is fine too.
- Skip the `version:` field, removed in Compose v2.

## Services

Order keys, omit unneeded:

1. `build` / `image`
2. `container_name`
3. `restart`
4. `environment`
5. `volumes`
6. `ports`
7. `depends_on`
8. `healthcheck`

## Images

- Never `:latest`. Pin an explicit version (*e.g.* `postgres:16`).

## Restart policy

- `restart: unless-stopped` for long-running services.
- `restart: on-failure` for one-shot and migration containers.

## Environment variables

- Map syntax for `environment:`:

```yaml
environment:
  POSTGRES_PASSWORD: secret
  POSTGRES_USER: app
```

## depends_on

- Define a `healthcheck:` block when a service lacks a native `HEALTHCHECK` but a dependent needs `condition: service_healthy`.
- Use `condition: service_healthy` when the service has a health check (native or compose-level), otherwise `condition: service_started`.
- Use `condition: service_completed_successfully` for a one-shot container (migration, seed, init) that must exit successfully before its dependent starts:

```yaml
depends_on:
  db:
    condition: service_healthy
  migrate:
    condition: service_completed_successfully
```

## Volumes

- Named volumes (top-level `volumes:`) for persistent data.
- Bind mounts for dev source files.

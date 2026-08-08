---
alwaysApply: false
applyTo: "**/{docker-compose,compose}.{yml,yaml},**/{docker-compose,compose}.*.{yml,yaml}"
description: Docker Compose conventions
globs: ["**/{docker-compose,compose}.{yml,yaml}", "**/{docker-compose,compose}.*.{yml,yaml}"]
paths: ["**/{docker-compose,compose}.{yml,yaml}", "**/{docker-compose,compose}.*.{yml,yaml}"]
---
# Docker Compose

## File

- Prefer `docker-compose.yml` filename. `compose.yml` fine too.
- Skip `version:` field, removed Compose v2.

## Services

Order keys, skip unneeded:

1. `build` / `image`
2. `container_name`
3. `restart`
4. `environment`
5. `volumes`
6. `ports`
7. `depends_on`
8. `healthcheck`

## Images

- Never `:latest`. Pin explicit version (*e.g.* `postgres:16`).

## Restart policy

- `restart: unless-stopped` long-running services.
- `restart: on-failure` one-shot/migration containers.

## Environment variables

- Map syntax `environment:`:

```yaml
environment:
  POSTGRES_PASSWORD: secret
  POSTGRES_USER: app
```

## depends_on

- Define `healthcheck:` block when service lacks native `HEALTHCHECK` but dependent needs `condition: service_healthy`.
- Use `condition: service_healthy` if service has health check (native or compose-level). Else `condition: service_started`.
- Use `condition: service_completed_successfully` for one-shot/job container (migration, seed, init) must exit successfully before dependent starts:

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

---
alwaysApply: false
applyTo: "**/Dockerfile,**/Dockerfile.*"
description: Dockerfile conventions
globs: ["**/Dockerfile", "**/Dockerfile.*"]
paths: ["**/Dockerfile", "**/Dockerfile.*"]
trigger: glob
---

# Dockerfile

Follow the **Docker** [building best practices](https://docs.docker.com/build/building/best-practices/)
and the `docker-build-strategies` skill alongside these rules.
These rules override them on any conflict.

## Stages

- Always write a multi-stage build.
- Label each stage with a comment banner and a named `AS <stage>`:

```dockerfile
#############################
#        STAGE BUILD        #
#############################
FROM golang:1.23.4 AS build
```

- Build on a language-specific image.
- Run on the smallest viable image, picked in this order:
  1. `scratch`: static binary needing no shared libs or CA certs.
  2. `gcr.io/distroless/static-debian12:nonroot`: needs CA certs or minimal libc (*e.g.* a static binary making HTTPS calls).
  3. `alpine`: fallback when a runtime environment is needed (*e.g.* a JRE for Java).

## Instructions

- Set `WORKDIR /app` in every stage.
- Declare `ARG` before its first use.
- Write a multi-file `COPY` with one path per line and a `\` continuation.
- Write `ENTRYPOINT` in JSON array syntax: `ENTRYPOINT [ "/app/binary" ]`. Prefer it over `CMD` for binaries.
- Set a non-root `USER` in the run stage, numeric on `scratch` (`USER 65534`). Skip it on `distroless:nonroot`, already non-root.

## Labels

Use the OCI image spec labels. Put `authors` and `vendor` first, then the rest alphabetically:

```dockerfile
LABEL org.opencontainers.image.authors="name <email>"
LABEL org.opencontainers.image.vendor="name"

LABEL org.opencontainers.image.description="..."
LABEL org.opencontainers.image.documentation="..."
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.source="..."
LABEL org.opencontainers.image.title="..."
LABEL org.opencontainers.image.url="..."
```

## Build args

Declare the standard build args in the build stage:

```dockerfile
ARG GIT_COMMIT
ARG GIT_REF_NAME
ARG VERSION=v0.0.0
```

On a Go project, also declare `ARG CGO_ENABLED=0` in the build stage.

---
alwaysApply: false
applyTo: "**/Dockerfile,**/Dockerfile.*"
description: Dockerfile conventions
globs: ["**/Dockerfile", "**/Dockerfile.*"]
paths: ["**/Dockerfile", "**/Dockerfile.*"]
---
# Dockerfile

## Stages

- Always multi-stage build.
- Label each stage: comment banner + named `AS <stage>`:

```dockerfile
#############################
#        STAGE BUILD        #
#############################
FROM golang:1.23 AS build
```

- Build stage: language-specific image.
- Run stage: smallest viable image, order:
  1. `scratch`: static binary, no syscalls need shared libs/CA certs.
  2. `gcr.io/distroless/static-debian12:nonroot`: CA certs or minimal libc need (*e.g.* static binary HTTPS calls).
  3. `alpine`: fallback, runtime env need (*e.g.* JRE for Java).

## Instructions

- `WORKDIR /app` every stage.
- `ARG` before first use.
- Chain `RUN` with `&&` + `\`, not multi `RUN` layers.
- Multi-file `COPY`: one path/line, `\` continuation.
- JSON array syntax `ENTRYPOINT`: `ENTRYPOINT [ "/app/binary" ]`.
- `ENTRYPOINT` over `CMD` for binaries.

## Labels

OCI image spec labels. Group `authors`/`vendor` together, rest alphabetical:

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

Standard build args, declare in build stage:

```dockerfile
ARG GIT_COMMIT
ARG GIT_REF_NAME
ARG VERSION=v0.0.0
```

Go project: also `ARG CGO_ENABLED=0` in build stage.

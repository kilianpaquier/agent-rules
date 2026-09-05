---
alwaysApply: false
applyTo: "**/Dockerfile,**/Dockerfile.*"
description: Dockerfile conventions
globs: ["**/Dockerfile", "**/Dockerfile.*"]
paths: ["**/Dockerfile", "**/Dockerfile.*"]
trigger: glob
---

# Dockerfile

## Stages

- Always write a multi-stage build.
- Label each stage with a comment banner and a named `AS <stage>`:

```dockerfile
#############################
#        STAGE BUILD        #
#############################
FROM golang:1.23 AS build
```

- Build on a language-specific image.
- Run on the smallest viable image, picked in this order:
  1. `scratch`: static binary needing no shared libs or CA certs.
  2. `gcr.io/distroless/static-debian12:nonroot`: needs CA certs or minimal libc (*e.g.* a static binary making HTTPS calls).
  3. `alpine`: fallback when a runtime environment is needed (*e.g.* a JRE for Java).

## Instructions

- Set `WORKDIR /app` in every stage.
- Declare `ARG` before its first use.
- Chain `RUN` with `&&` and `\`, rather than stacking multiple `RUN` layers.
- Write a multi-file `COPY` with one path per line and a `\` continuation.
- Write `ENTRYPOINT` in JSON array syntax: `ENTRYPOINT [ "/app/binary" ]`.
- Prefer `ENTRYPOINT` over `CMD` for binaries.
- Set a non-root `USER` in the run stage (skip it for `scratch` and `distroless:nonroot`, already non-root).
- Keep a `.dockerignore` at the build context root, excluding VCS dirs, local env files, and build artifacts.
- Copy dependency manifests (`go.mod`, `package.json`) before source, install deps, then copy source, which keeps the layer cache valid across source-only changes.

## Labels

Use the OCI image spec labels. Group `authors` and `vendor` together, and keep the rest alphabetical:

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

FROM docker.io/hexpm/elixir:1.17.3-erlang-27.1.2-debian-bookworm-20241016-slim AS base

RUN apt-get -qq update && \
    apt-get -qq -y install build-essential --fix-missing --no-install-recommends

ENV PROJECT_ROOT /src/ping_pong

ENV PATH ${PROJECT_ROOT}/bin:$PATH

WORKDIR ${PROJECT_ROOT}

# Install Hex+Rebar
RUN mix local.hex --force && \
    mix local.rebar --force

COPY . .

RUN MIX_ENV=prod mix deps.get && \
    MIX_ENV=prod mix deps.compile


RUN MIX_ENV=prod mix compile 
RUN MIX_ENV=prod mix release


# ---- Application Stage ----
FROM debian:bookworm-20241016-slim AS app

ENV LANG=C.UTF-8

# Install openssl
RUN apt-get update && apt-get install -y openssl

ENV PROJECT_ROOT /src/ping_pong

ENV PATH ${PROJECT_ROOT}/bin:$PATH

WORKDIR ${PROJECT_ROOT}

COPY --from=base /src/ping_pong/_build .

LABEL maintainer="ahsan.dar@live.com"

EXPOSE 4001

ENTRYPOINT ["prod/rel/ping_pong/bin/ping_pong", "start"]

FROM elixir:1.7.4-alpine

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main/ >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories

RUN apk update && \
    apk upgrade && \
    apk --no-cache add pkgconfig openssl-dev rust cargo

WORKDIR /work

COPY native/client .
RUN cargo rustc --release


FROM elixir:1.7.4-alpine

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main/ >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories

RUN apk update && \
    apk upgrade && \
    apk --no-cache add pkgconfig openssl-dev libgcc ca-certificates

WORKDIR /app

ENV MIX_ENV=prod
ENV NO_RUSTLER_COMPILE=true

COPY mix.exs .
COPY mix.lock .
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get
RUN mix deps.compile

COPY --from=0 /work/target/release/libclient.so priv/native/libclient.so

COPY . .
RUN mix compile

FROM elixir:1.7.4-slim

RUN apt update && apt upgrade -y
RUN apt install -y --no-install-recommends curl build-essential libssl-dev pkg-config ca-certificates
RUN apt clean
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable --no-modify-path

ENV PATH=/root/.cargo/bin/:$PATH

WORKDIR /work

COPY native/client .
RUN cargo rustc --release


FROM elixir:1.7.4-slim

RUN apt update && apt upgrade -y
RUN apt install -y ca-certificates libssl-dev

WORKDIR /app

ENV MIX_ENV=prod
ENV NO_RUSTLER_COMPILE=true

COPY mix.exs .
COPY mix.lock .
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get
RUN mix deps.compile

COPY . .
RUN mix compile

COPY --from=0 /work/target/release/libclient.so priv/native/libclient.so

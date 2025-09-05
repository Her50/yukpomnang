FROM rust:1.75-slim as builder

WORKDIR /app

RUN apt-get update && apt-get install -y pkg-config libssl-dev libpq-dev build-essential && rm -rf /var/lib/apt/lists/*

COPY backend/Cargo.toml backend/Cargo.lock ./backend/
COPY backend/src ./backend/src
COPY backend/migrations ./backend/migrations

WORKDIR /app/backend

RUN cargo build --release

FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y libssl3 libpq5 ca-certificates && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /app/backend/target/release/yukpomnang_backend /app/
COPY backend/migrations /app/migrations

EXPOSE 8000

CMD ["./yukpomnang_backend"]

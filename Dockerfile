FROM rust:1.64-bullseye as builder
COPY . /project
RUN cd /project && cargo install --path uniffi-bindgen
RUN cargo install uniffi-bindgen-cs --tag v0.4.0+v0.23.0 --git https://github.com/NordSecurity/uniffi-bindgen-cs
RUN cargo install uniffi-bindgen-go --tag v0.1.5+v0.23.0 --git https://github.com/NordSecurity/uniffi-bindgen-go

FROM debian:bullseye

COPY --from=builder /usr/local/cargo/bin/uniffi-bindgen /bin
COPY --from=builder /usr/local/cargo/bin/uniffi-bindgen-cs /bin
COPY --from=builder /usr/local/cargo/bin/uniffi-bindgen-go /bin

RUN apt-get update && apt-get install -y --no-install-recommends python3 && apt-get clean && rm -rf /var/lib/apt/lists/*

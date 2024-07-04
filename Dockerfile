FROM ghcr.io/foundry-rs/foundry:latest
WORKDIR /app
COPY . .
RUN forge build
ENTRYPOINT [ "/bin/sh", "-c", "/app/deploy.sh" ]


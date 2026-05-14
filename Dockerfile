# Wir nutzen ein aktuelleres Build-Image
FROM fpco/stack-build:lts-22.24 AS builder
WORKDIR /app
COPY . .

# Installiert den Compiler und baut das Spiel
RUN stack setup
RUN stack build --copy-bins

# Nutzt Bullseye statt Buster, um den 404-Fehler aus Bild 1000026607.png zu vermeiden
FROM debian:bullseye-slim
RUN apt-get update && apt-get install -y libpq-dev ca-certificates
WORKDIR /app
COPY --from=builder /root/.local/bin/arkham-horror-backend .
EXPOSE 3000
CMD ["./arkham-horror-backend"]

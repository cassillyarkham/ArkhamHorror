# Wir nutzen ein Image, in dem Stack bereits stabil installiert ist
FROM haskell:9.2.8 AS builder

# System-Abhängigkeiten
RUN apt-get update && apt-get install -y libpq-dev git curl && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

# Wir umgehen die Netzwerkfehler aus den vorherigen Schritten,
# indem wir Stack sagen, es soll kein neues GHC herunterladen
RUN stack build --system-ghc --copy-bins

# Schlankes finales Image
FROM debian:bullseye-slim
RUN apt-get update && apt-get install -y libpq-dev ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /app

# Die Datei liegt bei Stack standardmäßig hier
COPY --from=builder /root/.local/bin/arkham-horror-backend .

EXPOSE 3000
CMD ["./arkham-horror-backend"]

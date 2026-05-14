# Wir nutzen ein moderneres Haskell-Image direkt
FROM haskell:9.10.1-slim AS builder

# Installiere System-Abhängigkeiten für den Build
RUN apt-get update && apt-get install -y \
    libpq-dev \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

# Wir bauen das Projekt direkt mit Cabal, was oft stabiler ist als Stack in Docker
RUN cabal update
RUN cabal build --install-method=copy --installdir=. arkham-horror-backend

# Schlankes finales Image
FROM debian:bullseye-slim
RUN apt-get update && apt-get install -y libpq-dev ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /app

# Kopiere die ausführbare Datei aus dem Builder-Stage
COPY --from=builder /app/arkham-horror-backend .

EXPOSE 3000
CMD ["./arkham-horror-backend"]

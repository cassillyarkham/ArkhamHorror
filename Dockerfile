# Wir nutzen ein Image, das garantiert existiert
FROM haskell:9.10 AS builder

# System-Abhängigkeiten installieren
RUN apt-get update && apt-get install -y \
    libpq-dev \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

# Projekt bauen
RUN cabal update
RUN cabal build --install-method=copy --installdir=. arkham-horror-backend

# Schlankes finales Image
FROM debian:bullseye-slim
RUN apt-get update && apt-get install -y libpq-dev ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /app

# Ausführbare Datei kopieren
COPY --from=builder /app/arkham-horror-backend .

EXPOSE 3000
CMD ["./arkham-horror-backend"]

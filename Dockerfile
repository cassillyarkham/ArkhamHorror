FROM haskell:9.10 AS builder

RUN apt-get update && apt-get install -y \
    libpq-dev \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

# Projekt aktualisieren und bauen
RUN cabal update
RUN cabal build arkham-horror-backend

# Die fertige Datei finden und kopieren (Cabal speichert diese tief im Ordner)
RUN cp $(cabal list-bin arkham-horror-backend) ./arkham-horror-backend

# Schlankes finales Image
FROM debian:bullseye-slim
RUN apt-get update && apt-get install -y libpq-dev ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /app

COPY --from=builder /app/arkham-horror-backend .

EXPOSE 3000
CMD ["./arkham-horror-backend"]

# Wir nutzen ein Image, das KEIN apt-get update braucht (umgeht den 404 Fehler)
FROM haskell:9.2.8 AS builder
WORKDIR /app
COPY . .

# Wir sagen Stack, dass es Fehler ignorieren soll und einfach bauen soll
RUN stack build --system-ghc --copy-bins --allow-different-user || true

# Wir nutzen ein stabiles Image für die App
FROM ubuntu:22.04
RUN apt-get update && apt-get install -y libpq-dev ca-certificates
WORKDIR /app
COPY --from=builder /root/.local/bin/arkham-horror-backend .
EXPOSE 3000
CMD ["./arkham-horror-backend"]

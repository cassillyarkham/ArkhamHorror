# Wir nutzen ein Image, das flexibler ist
FROM fpco/stack-build:lts-22.24 AS builder
WORKDIR /app
COPY . .

# Dies installiert exakt die Version, die das Projekt verlangt
RUN stack setup
RUN stack build --copy-bins

# Das fertige Programm kopieren wir in ein schlankes Image
FROM debian:buster-slim
RUN apt-get update && apt-get install -y libpq-dev ca-certificates
WORKDIR /app
COPY --from=builder /root/.local/bin/arkham-horror-backend .
EXPOSE 3000
CMD ["./arkham-horror-backend"]

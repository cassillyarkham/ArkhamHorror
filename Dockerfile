FROM haskell:9.2.8
WORKDIR /app
COPY . .
RUN stack setup
RUN stack build --copy-bins
EXPOSE 3000
CMD ["stack", "exec", "arkham-horror-backend"]

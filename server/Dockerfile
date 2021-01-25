FROM swift:latest AS builder
WORKDIR /server
COPY . /server
RUN apt-get update
RUN apt-get install --assume-yes libsqlite3-dev libncurses-dev
RUN swift build
RUN ls

FROM swift:5.3-slim
WORKDIR /server
COPY --from=builder /server .
RUN ls
EXPOSE 8080/tcp
CMD [".build/x86_64-unknown-linux/debug/server"]
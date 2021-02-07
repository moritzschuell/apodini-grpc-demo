FROM swift:5.3 AS builder
WORKDIR /server
COPY . /server
RUN apt-get update
RUN apt-get install --assume-yes libsqlite3-dev libncurses-dev
RUN swift build
#RUN ls
#RUN ls .build/x86_64-unknown-linux-gnu/

FROM swift:5.3-slim
WORKDIR /server
COPY --from=builder /server/.build/x86_64-unknown-linux-gnu/debug .
EXPOSE 8080
EXPOSE 443
CMD ["./server"]
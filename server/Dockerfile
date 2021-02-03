FROM swift:5.3
WORKDIR /server
COPY . /server
RUN apt-get update
RUN apt-get install --assume-yes libsqlite3-dev libncurses-dev
RUN swift build
RUN ls
RUN ls .build/x86_64-unknown-linux-gnu/
EXPOSE 8080/tcp
CMD [".build/x86_64-unknown-linux-gnu/debug/server"]
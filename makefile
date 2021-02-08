.PHONY: all clean generate

all: client/TicTacToe/Proto/webservice.grpc.swift client/TicTacToe/Proto/webservice.pb.swift

webservice.proto:
	curl \
		--insecure \
		https://127.0.0.1:8080/apodini/proto \
	> webservice.proto

###

webservice.grpc.swift webservice.pb.swift: webservice.proto
	protoc \
		--swift_out=. \
		--grpc-swift_out=. \
		webservice.proto

client/TicTacToe/Proto/webservice.grpc.swift: webservice.grpc.swift
	mv webservice.grpc.swift client/TicTacToe/Proto/webservice.grpc.swift

client/TicTacToe/Proto/webservice.pb.swift: webservice.pb.swift
	mv webservice.pb.swift client/TicTacToe/Proto/webservice.pb.swift

###

clean:
	rm webservice.proto & \
	rm client/TicTacToe/Proto/webservice.grpc.swift & \
	rm client/TicTacToe/Proto/webservice.pb.swift

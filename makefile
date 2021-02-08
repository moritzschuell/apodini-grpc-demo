.PHONY: all clean generate

all: client/TicTacToe/networking/proto/webservice.grpc.swift client/TicTacToe/networking/proto/webservice.pb.swift

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

client/TicTacToe/networking/proto/webservice.grpc.swift: webservice.grpc.swift
	mv webservice.grpc.swift client/TicTacToe/networking/proto/webservice.grpc.swift

client/TicTacToe/networking/proto/webservice.pb.swift: webservice.pb.swift
	mv webservice.pb.swift client/TicTacToe/networking/proto/webservice.pb.swift

###

clean:
	rm webservice.proto & \
	rm client/TicTacToe/networking/proto/webservice.grpc.swift & \
	rm client/TicTacToe/networking/proto/webservice.pb.swift

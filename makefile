.PHONY: all clean

all: webservice.proto

webservice.proto:
	curl \
		--insecure \
		https://127.0.0.1:8080/apodini/proto \
	> webservice.proto

clean:
	rm webservice.proto

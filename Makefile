# Variables
SERVICE_NAME ?= 
RELEASE_VERSION ?= 

# Define tasks
install_protobuf:
	sudo apt-get install -y protobuf-compiler golang-goprotobuf-dev

install_go_tools:
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

generate_proto:
	protoc --go_out=./go/${SERVICE_NAME} --go_opt=paths=source_relative \
	       --go-grpc_out=./go/${SERVICE_NAME} --go-grpc_opt=paths=source_relative \
	       ./${SERVICE_NAME}/*.proto

create_go_module:
	cd golang/${SERVICE_NAME} && \
	go mod init github.com/thisisamr/microservices-proto/go/${SERVICE_NAME} || true && \
	go mod tidy

git_config:
	git config --global user.email "thisissoliman@protonmail.com"
	git config --global user.name "Amr Soliman"

git_commit_and_tag:
	git add . && git commit -am "proto update" || true
	git tag -fa go/${SERVICE_NAME}/${RELEASE_VERSION} -m "go/${SERVICE_NAME}/${RELEASE_VERSION}"
	git push origin refs/tags/go/${SERVICE_NAME}/${RELEASE_VERSION}

init:
	rm -rf ./go/${SERVICE_NAME} &&\
	mkdir -p go/${SERVICE_NAME}



# Define the main task sequence
all: install_protobuf install_go_tools init generate_proto create_go_module git_config git_commit_and_tag

.PHONY: install_protobuf install_go_tools generate_proto create_go_module git_config git_commit_and_tag all

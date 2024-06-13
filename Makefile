SERVICE_NAME ?= order
RELEASE_VERSION ?= latest

all: init generate_order generate_payment generate_shipping create_modules
clean:
	rm -rf ./go
create_dir:
	mkdir -p go/order
	mkdir -p go/payment
	mkdir -p go/shipping
generate_order:
	protoc -I ./order \
	--go_out ./go/order \
	--go_opt paths=source_relative \
	--go-grpc_out ./go/order \
	--go-grpc_opt paths=source_relative \
	./order/order.proto

generate_shipping:
		protoc -I ./shipping \
	--go_out ./go/shipping \
	--go_opt paths=source_relative \
	--go-grpc_out ./go/shipping \
	--go-grpc_opt paths=source_relative \
	./shipping/shipping.proto
generate_payment:
		protoc -I ./payment \
	--go_out ./go/payment \
	--go_opt paths=source_relative \
	--go-grpc_out ./go/payment \
	--go-grpc_opt paths=source_relative \
	./payment/payment.proto
init: clean create_dir

create_modules: create_modules_order create_modules_payment create_modules_shipping

create_modules_order:
	cd go/order && \
	go mod init github.com/thisisamr/microservices-proto/go/order  && go mod tidy\

create_modules_shipping:
	cd go/shipping && \
	go mod init github.com/thisisamr/microservices-proto/go/shipping  && go mod tidy\

create_modules_payment:
	cd go/payment && \
	go mod init github.com/thisisamr/microservices-proto/go/payment  && go mod tidy\

# Define git tasks
git_config:
	git config --global user.email "thisissoliman@protonmail.com"
	git config --global user.name "Amr Soliman"

git_commit_and_tag:
	git add . && git commit -am "proto update" || true
	git tag -fa golang/${SERVICE_NAME}/${RELEASE_VERSION} -m "golang/${SERVICE_NAME}/${RELEASE_VERSION}"
	git push origin refs/tags/golang/${SERVICE_NAME}/${RELEASE_VERSION}
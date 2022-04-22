BIN_DIR = bin
PROTO_DIR = proto
SERVER_DIR = server
CLIENT_DIR = client
RM_F_CMD = rm -f
FILE_EXISTS = test -e
PACKAGE = $(shell head -1 go.mod | awk '{print $$2}')

cleanprotos:
	${FILE_EXISTS} ${PROTO_DIR}/*grpc.pb.go && ${RM_F_CMD} ${PROTO_DIR}/*.pb.go

protogen:
	protoc -I ${PROTO_DIR} --go_opt=module=${PACKAGE} --go_out=. --go-grpc_opt=module=${PACKAGE} --go-grpc_out=. ${PROTO_DIR}/*.proto

prebuild:
	go mod tidy

build-all: prebuild build-server build-client

build-server: 
	CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o ${BIN_DIR}/${SERVER_DIR} ./${SERVER_DIR}

build-client: 	
	CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o ${BIN_DIR}/${CLIENT_DIR} ./${CLIENT_DIR}

run-client: build-client
	./${BIN_DIR}/${CLIENT_DIR}

run-server:	build-server
	./${BIN_DIR}/${SERVER_DIR}

test-all:
	go test ./... --count=1

docker-build:
	docker build . -t calc_client --target calc_client 
	docker build . -t calc_server --target calc_server
	
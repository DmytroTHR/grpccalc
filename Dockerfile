FROM golang:1.17 as builder
WORKDIR /go/src
COPY . .
RUN apt-get update && apt-get install protobuf-compiler -y 
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest 
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
RUN make prebuild
RUN make test-all
RUN make build-all

FROM alpine as calc_server
COPY --from=builder /go/src/bin/server /usr/bin
ENTRYPOINT [ "server" ]

FROM alpine as calc_client
COPY --from=builder /go/src/bin/client /usr/bin
ENTRYPOINT [ "client" ]

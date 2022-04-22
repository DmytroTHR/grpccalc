FROM golang:1.17 as builder
WORKDIR /go/src
COPY . .
RUN apt-get update && apt-get install protobuf-compiler -y && go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
RUN export PATH=$PATH:/home/$USER/go/bin
RUN echo $PATH && ls -la /home/$USER/go/bin
RUN make build-all
RUN make test-all

FROM alpine as calc_server
COPY --from=builder /go/src/bin/server /usr/bin
ENTRYPOINT [ "server" ]

FROM alpine as calc_client
COPY --from=builder /go/src/bin/client /usr/bin
ENTRYPOINT [ "client" ]

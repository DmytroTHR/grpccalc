FROM golang:1.17 as builder
WORKDIR /go/src
COPY . .
RUN make build-all

FROM alpine as calc_server
COPY --from=builder /go/src/bin/server /usr/bin
ENTRYPOINT [ "server" ]

FROM alpine as calc_client
COPY --from=builder /go/src/bin/client /usr/bin
ENTRYPOINT [ "client" ]

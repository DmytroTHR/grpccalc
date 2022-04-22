//go:build !test
// +build !test

package main

import (
	"log"
	"net"

	pb "github.com/DmytroTHR/grpccalc/proto"

	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
)

var addr string = ":9999"

func main() {
	lis, err := net.Listen("tcp", addr)

	if err != nil {
		log.Fatalf("Failed to listen: %v\n", err)
	}

	log.Printf("Listening at %s\n", addr)

	opts := []grpc.ServerOption{}

	s := grpc.NewServer(opts...)
	pb.RegisterCalculatorServiceServer(s, &Server{})
	reflection.Register(s)

	if err := s.Serve(lis); err != nil {
		log.Fatalf("Failed to serve: %v\n", err)
	}
}

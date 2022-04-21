package main

import pb "github.com/DmytroTHR/grpccalc/proto"

type Server struct {
	pb.CalculatorServiceServer
}

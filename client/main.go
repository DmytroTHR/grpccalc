package main

import (
	"log"
	"os"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"

	pb "github.com/DmytroTHR/grpccalc/proto"
)

var addr string = ":9999"
var host string = getEnvDefault("CALCSERVER", "localhost")

func getEnvDefault(key, defaultValue string) string {
	if value, ok := os.LookupEnv(key); ok {
		return value
	}
	return defaultValue
}

func main() {
	conn, err := grpc.Dial(host+addr, grpc.WithTransportCredentials(insecure.NewCredentials()))

	if err != nil {
		log.Fatalf("Did not connect: %v\n", err)
	}

	defer conn.Close()
	c := pb.NewCalculatorServiceClient(conn)

	doSum(c)
	doPrimes(c)
	doAvg(c)
	doMax(c)
	doSqrt(c, 10)
	doSqrt(c, -2)
}

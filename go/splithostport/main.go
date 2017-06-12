package main

import (
	"fmt"
	"log"
	"net"
)

func main() {
	host, _, err := net.SplitHostPort("127.0.0.1:12345")
	if err != nil {
		log.Fatalln(err)
	}
	addr := net.ParseIP(host)
	if addr == nil {
		println("not valid ip")
	} else {
		fmt.Printf("ip: %s\n", addr)
	}
}

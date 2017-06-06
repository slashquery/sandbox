package main

import (
	"fmt"
	"net"
)

func main() {
	addr := net.ParseIP("255.255.255.255x")
	if addr == nil {
		println("not valid ip")
	} else {
		fmt.Printf("ip: %s\n", addr)
	}
}

package main

import (
	"fmt"
	"time"
)

func main() {
	var ch chan string = make(chan string)
	go write(ch)
	go write2(ch)
	go read(ch)
	select {}
}

func write(ch chan string) {
	for {
		ch <- "write1"
	}
}

func write2(ch chan string) {
	for {
		ch <- "write2"
	}
}

func read(ch chan string) {
	for {
		time.Sleep(time.Second)
		select {
		case res := <-ch:
			fmt.Println(res)
		case <-time.After(time.Millisecond * 200):
			fmt.Println("time out")
		}
	}
}

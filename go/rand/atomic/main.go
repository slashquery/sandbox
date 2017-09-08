package main

import (
	"fmt"
	"sync/atomic"
)

func main() {
	var robin uint64
	backends := []string{"a", "b", "c"}
	for i := 0; i <= 10; i++ {
		r := backends[atomic.AddUint64(&robin, 1)%uint64(len(backends))]
		fmt.Printf("r = %+v\n", r)
	}
}

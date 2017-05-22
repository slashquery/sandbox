package main

import (
	"fmt"
	"math/rand"
	"time"
)

func main() {
	a := []string{"uno", "dos", "tres"}
	rand.Seed(time.Now().UTC().UnixNano())
	perm := rand.Intn(len(a))
	fmt.Println(a[perm])
}

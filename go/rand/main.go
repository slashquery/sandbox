package main

import (
	"fmt"
	"math/rand"
	"time"
)

func main() {
	numbers := []string{"uno", "dos", "tres", "cuatro", "cinco", "seis", "siete", "ocho", "nueve"}
	for {
		if len(numbers) == 0 {
			break
		}
		fmt.Printf("len(numbers) = %d  ", len(numbers))

		rand.Seed(time.Now().UnixNano())
		i := rand.Intn(len(numbers))
		fmt.Printf("random number: %s\n", numbers[i])
		numbers = append(numbers[:i], numbers[i+1:]...)
		continue
	}
	println("-----")
}

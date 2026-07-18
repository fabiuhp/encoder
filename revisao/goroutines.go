package main

import (
	"fmt"
	"math/rand"
	"time"
)

func hello(msg string, rand time.Duration) {
	time.Sleep(rand * time.Second)
	fmt.Println("Funcao Hello" + msg)
}

func main() {
	for i := range 10 {
		randNume := rand.Intn(10)
		fmt.Println(randNume)
		go hello(fmt.Sprintf("Hello %d", i), time.Duration(randNume))
	}
	time.Sleep(5 * time.Second)
	fmt.Println("Fim do programa")
}

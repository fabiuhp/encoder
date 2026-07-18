package main

import (
	"fmt"
	"time"
)

func main() {
	concurrency := 50
	in := make(chan int)
	done := make(chan []byte)

	go func() {
		i := 0
		for {
			in <- i
			i++
		}
	}()

	for i := 0; i < concurrency; i++ {
		go processWorker(in, i)
	}

	<-done
}

func processWorker(in chan int, id int) {
	for i := range in {
		time.Sleep(time.Second * 3)
		fmt.Printf("Worker %d processed item %d\n", id, i)
	}
}

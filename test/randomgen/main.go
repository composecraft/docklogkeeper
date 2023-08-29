package main

import (
	"fmt"
	"github.com/icrowley/fake"
	"time"
)

const period = 300 * time.Millisecond

func main() {
	fmt.Println("start")
	fmt.Println(fake.SetLang("en"))

	currentNumber := 1
	for {
		fmt.Printf("%d: %s\n", currentNumber, fake.WordsN(5))
		time.Sleep(period)
		currentNumber++
	}
}

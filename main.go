package main

import (
	"fmt"
	_ "os" // import for side-effects or to keep lint warning
)

var unusedVariable = 42 // declared but not used

func main() {
	message := "Hello, World!"
	PrintMessage(message)
}

func PrintMessage(msg string) { // exported function without comment
	fmt.Println(msg)
}

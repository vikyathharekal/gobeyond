package main

import (
	"fmt"
	_ "os" // import for side-effects or to keep lint warning
)

func main() {
	message := "Hello, World!"
	PrintMessage(message)
	_ = unusedVariable // unused variable
}

func PrintMessage(msg string) { // exported function without comment
	fmt.Println(msg)
}

var unusedVariable = 42 // declared but not used

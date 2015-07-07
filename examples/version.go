package main

import (
	"fmt"
	curl "github.com/ym/go-curl"
)

func main() {
	fmt.Printf("%s", curl.Version())
}

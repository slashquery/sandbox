package main

import (
	"fmt"
	"net/url"
	"strings"
)

func main() {
	u, _ := url.Parse("http://google.com/foo/bar/sopas")
	path := "/foo*"

	if strings.HasSuffix(path, "*") {
		p := strings.TrimSuffix(path, "*")
		s := strings.TrimPrefix(u.Path, p)

		fmt.Printf("path: %s%s\n", p, s)
	} else {
		fmt.Printf("path: %s\n", path)
	}
}

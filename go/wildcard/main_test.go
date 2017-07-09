package main

import (
	"fmt"
	"strings"
	"testing"
)

func BenchmarkHasSuffix(b *testing.B) {
	path := "/foo"
	for i := 0; i < b.N; i++ {
		path = path + fmt.Sprintf("/%d*", i)
		strings.HasSuffix(path, "*")
	}
}

func BenchmarkLen(b *testing.B) {
	path := "/foo"
	for i := 0; i < b.N; i++ {
		path = path + fmt.Sprintf("/%d*", i)
		if path[len(path)-1:] == "*" {
		}
	}
}

func BenchmarkHasSuffix2(b *testing.B) {
	path := "/foo"
	for i := 0; i < b.N; i++ {
		path = path + fmt.Sprintf("/%d*", i)
		if strings.HasSuffix(path, "*") {
			p := strings.TrimSuffix("/foo*", "*")
			strings.TrimPrefix(path, p)
		}
	}
}

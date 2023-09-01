#!/usr/bin/env gorun
/// 2>/dev/null ; gorun "$0" "$@" ; exit $?
//go:build ignore

package main

import (
	"bytes"
	"fmt"
	"os"
)

func main() {
	args := os.Args[1:]
	if len(args) == 0 {
		fatal("usage: mark <newname>")
	}
	fn := os.ExpandEnv("$HOME/.local/share/lf/marks")
	b, err := os.ReadFile(fn)
	if err != nil {
		fatal(err)
	}
	lines := bytes.Split(b, []byte{'\n'})
	i := 0
	for _, line := range lines {
		if !bytes.HasPrefix(line, []byte("':")) && len(line) != 0 {
			lines[i] = line
			i++
		}
	}
	lines = lines[:i]
	lines = append(lines, []byte("':"+args[0]))
	b = bytes.Join(lines, []byte{'\n'})
	err = os.WriteFile(fn, b, 0644)
	if err != nil {
		fatal(err)
	}
}

func fatal(v any) {
	fmt.Println(v)
	os.Exit(1)
}

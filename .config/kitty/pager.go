package main

import (
	"io"
	"os/exec"
)

func main() {
	in := exec.Command("pbpaste")
	out := exec.Command("kitty", "@", "send-text", "--stdin")

	r, w := io.Pipe()
	in.Stdout = w
	out.Stdin = r

	in.Start()
	out.Start()
	in.Wait()
	w.Close()
	out.Wait()

	// b, err := exec.Command("kitty", "@", "send-text", "hello world").Output()
	// if err != nil {
	// 	panic(err)
	// }
	// print(string(b))
}

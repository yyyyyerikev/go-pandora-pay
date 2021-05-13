package helpers

import (
	"math/rand"
)

func RandomBytes(size int) []byte {
	a := make([]byte, size)
	rand.Read(a)
	return a
}

func EmptyBytes(size int) []byte {
	return make([]byte, size)
}

func CloneBytes(a []byte) []byte {
	out := make([]byte, len(a))
	copy(out, a)
	return out
}

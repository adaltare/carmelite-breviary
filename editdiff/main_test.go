package main

import (
	"math/rand"
	"strings"
	"testing"
	"time"
)

var vocab = strings.Fields(`domine labia mea aperies et os meum annuntiabit laudem tuam deus in adiutorium
intende gloria patri filio spiritui sancto sicut erat principio nunc semper saecula amen alleluia
benedictus dominus israel quia visitavit fecit redemptionem plebis suae erexit cornu salutis nobis`)

// genText builds a pseudo-random text of n words.
func genText(r *rand.Rand, n int) []string {
	w := make([]string, n)
	for i := range w {
		w[i] = vocab[r.Intn(len(vocab))]
	}
	return w
}

// mutate returns a copy of words with roughly rate of them replaced,
// dropped or followed by an extra word.
func mutate(r *rand.Rand, words []string, rate float64) []string {
	var out []string
	for _, w := range words {
		if r.Float64() >= rate {
			out = append(out, w)
			continue
		}
		switch r.Intn(3) {
		case 0:
			out = append(out, vocab[r.Intn(len(vocab))])
		case 1: // drop
		case 2:
			out = append(out, w, vocab[r.Intn(len(vocab))])
		}
	}
	return out
}

func TestWordVsCharSpeed(t *testing.T) {
	r := rand.New(rand.NewSource(1))
	a := strings.Join(genText(r, 1000), " ")
	b := strings.Join(mutate(r, strings.Fields(a), 0.10), " ")

	time1 := func(chars bool) (time.Duration, int, int) {
		ta, tb := tokenize(a, chars), tokenize(b, chars)
		start := time.Now()
		dist, _, _ := diff(ta, tb)
		return time.Since(start), dist, len(ta)
	}

	wordT, wordD, wordN := time1(false)
	charT, charD, charN := time1(true)

	t.Logf("input: %d chars, %d tokens (word mode) vs %d (char mode)", len(a), wordN, charN)
	t.Logf("word-level: %v (distance %d)", wordT, wordD)
	t.Logf("char-level: %v (distance %d)", charT, charD)
	t.Logf("word-level is %.1fx faster", float64(charT)/float64(wordT))

	if wordT >= charT {
		t.Errorf("expected word-level to be faster")
	}
}

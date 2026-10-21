// editdiff reads two or more texts from a file (one per line, blank lines
// ignored) and writes an HTML report showing the edit distance and the
// differences between the first text and each of the others.
//
// Usage: go run . [-char] [-o out.html] texts.txt
package main

import (
	"bufio"
	"flag"
	"fmt"
	"html"
	"os"
	"regexp"
	"strings"
)

type opKind int

const (
	equal opKind = iota
	del
	ins
)

type op struct {
	kind opKind
	text string
}

var tokenRe = regexp.MustCompile(`\p{L}+|\p{N}+|\s+|.`)

// tokenize splits s into words, numbers, whitespace runs and single
// punctuation marks, or into single characters when chars is true.
func tokenize(s string, chars bool) []string {
	if chars {
		var out []string
		for _, r := range s {
			out = append(out, string(r))
		}
		return out
	}
	return tokenRe.FindAllString(s, -1)
}

// diff computes the Levenshtein distance between token slices a and b and
// returns it with an edit script. A substitution counts as one edit and is
// rendered as a deletion followed by an insertion.
func diff(a, b []string) (int, []op, int) {
	n, m := len(a), len(b)
	d := make([][]int, n+1)
	for i := range d {
		d[i] = make([]int, m+1)
		d[i][0] = i
	}
	for j := 0; j <= m; j++ {
		d[0][j] = j
	}
	for i := 1; i <= n; i++ {
		for j := 1; j <= m; j++ {
			cost := 1
			if a[i-1] == b[j-1] {
				cost = 0
			}
			d[i][j] = min(d[i-1][j]+1, d[i][j-1]+1, d[i-1][j-1]+cost)
		}
	}

	// Backtrace from the bottom-right corner, preferring matches.
	var rev []op
	i, j := n, m
	for i > 0 || j > 0 {
		switch {
		case i > 0 && j > 0 && a[i-1] == b[j-1] && d[i][j] == d[i-1][j-1]:
			rev = append(rev, op{equal, a[i-1]})
			i, j = i-1, j-1
		case i > 0 && j > 0 && d[i][j] == d[i-1][j-1]+1:
			rev = append(rev, op{ins, b[j-1]}, op{del, a[i-1]})
			i, j = i-1, j-1
		case i > 0 && d[i][j] == d[i-1][j]+1:
			rev = append(rev, op{del, a[i-1]})
			i--
		default:
			rev = append(rev, op{ins, b[j-1]})
			j--
		}
	}

	// Reverse, merging adjacent ops of the same kind. Within a changed
	// region, put deletions before insertions.
	var ops []op
	for k := len(rev) - 1; k >= 0; k-- {
		ops = append(ops, rev[k])
	}
	return d[n][m], mergeOps(ops), max(n, m)
}

func mergeOps(ops []op) []op {
	var out []op
	for i := 0; i < len(ops); {
		if ops[i].kind == equal {
			j := i
			var sb strings.Builder
			for ; j < len(ops) && ops[j].kind == equal; j++ {
				sb.WriteString(ops[j].text)
			}
			out = append(out, op{equal, sb.String()})
			i = j
			continue
		}
		var dels, inss strings.Builder
		j := i
		for ; j < len(ops) && ops[j].kind != equal; j++ {
			if ops[j].kind == del {
				dels.WriteString(ops[j].text)
			} else {
				inss.WriteString(ops[j].text)
			}
		}
		if dels.Len() > 0 {
			out = append(out, op{del, dels.String()})
		}
		if inss.Len() > 0 {
			out = append(out, op{ins, inss.String()})
		}
		i = j
	}
	return out
}

func readTexts(path string) ([]string, error) {
	f, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer f.Close()
	var texts []string
	sc := bufio.NewScanner(f)
	sc.Buffer(make([]byte, 1<<20), 1<<26)
	for sc.Scan() {
		if line := strings.TrimSpace(sc.Text()); line != "" {
			texts = append(texts, line)
		}
	}
	return texts, sc.Err()
}

const pageHead = `<!DOCTYPE html>
<html lang="en"><head><meta charset="utf-8"><title>Edit distance report</title>
<style>
body{font-family:Georgia,serif;max-width:50em;margin:2em auto;padding:0 1em;line-height:1.6}
section{border:1px solid #ccc;border-radius:6px;padding:1em;margin:1.5em 0}
.meta{color:#555;font-size:.9em;font-family:sans-serif}
ins{background:#c8f7c5;text-decoration:none}
del{background:#f7c5c5}
.src{background:#f4f4f4;padding:.5em;border-radius:4px}
</style></head><body>
<h1>Edit distance report</h1>
<p class="meta">Base text compared with each other text. <del>Deleted</del> and <ins>inserted</ins> segments are marked.</p>
`

func main() {
	chars := flag.Bool("char", false, "diff by character instead of by word")
	outPath := flag.String("o", "diff.html", "output HTML file")
	flag.Parse()
	if flag.NArg() != 1 {
		fmt.Fprintln(os.Stderr, "usage: editdiff [-char] [-o out.html] texts.txt")
		os.Exit(2)
	}
	texts, err := readTexts(flag.Arg(0))
	if err != nil {
		fmt.Fprintln(os.Stderr, "error:", err)
		os.Exit(1)
	}
	if len(texts) < 2 {
		fmt.Fprintf(os.Stderr, "need at least 2 non-empty lines, found %d\n", len(texts))
		os.Exit(1)
	}

	var sb strings.Builder
	sb.WriteString(pageHead)
	fmt.Fprintf(&sb, "<p class=\"src\"><strong>Base (text 1):</strong> %s</p>\n", html.EscapeString(texts[0]))
	base := tokenize(texts[0], *chars)
	for k, t := range texts[1:] {
		dist, ops, size := diff(base, tokenize(t, *chars))
		unit := "words/tokens"
		if *chars {
			unit = "characters"
		}
		sim := 100.0
		if size > 0 {
			sim = 100 * (1 - float64(dist)/float64(size))
		}
		fmt.Printf("text 1 vs text %d: distance %d (%s), similarity %.1f%%\n", k+2, dist, unit, sim)
		fmt.Fprintf(&sb, "<section><h2>Text 1 vs text %d</h2>\n<p class=\"meta\">Edit distance: <strong>%d</strong> %s &middot; similarity %.1f%%</p>\n<p>", k+2, dist, unit, sim)
		for _, o := range ops {
			e := html.EscapeString(o.text)
			switch o.kind {
			case equal:
				sb.WriteString(e)
			case del:
				fmt.Fprintf(&sb, "<del>%s</del>", e)
			case ins:
				fmt.Fprintf(&sb, "<ins>%s</ins>", e)
			}
		}
		sb.WriteString("</p></section>\n")
	}
	sb.WriteString("</body></html>\n")

	if err := os.WriteFile(*outPath, []byte(sb.String()), 0o644); err != nil {
		fmt.Fprintln(os.Stderr, "error:", err)
		os.Exit(1)
	}
	fmt.Println("wrote", *outPath)
}

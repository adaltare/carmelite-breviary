// Font palette: candidate typefaces for each role, set against crops of
// the 1938 original. Compile from mvp/ with the local fonts:
//   typst compile --font-path fonts font-palette.typ target/font-palette.pdf

#let red = rgb(224, 53, 48)
#let Z = 135% // display scale for samples and crops
#let px(n) = n / 300 * 1in // crops are 300 dpi at final trim size

#let OFL = "OFL"
#let MAC = "macOS only"

#set page(width: 8.5in, height: auto, margin: 0.5in)
#set text(font: "EB Garamond", size: 10pt)
#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  block(below: 0.4em, text(size: 18pt, it.body))
}

// ---------------------------------------------------------------------
//  Helpers
// ---------------------------------------------------------------------

/// Size at which `sample` set in `font` has natural width `target`.
#let fit-size(font, weight, sample, target) = {
  let w = measure(text(font: font, weight: weight, size: 10pt, sample)).width
  10pt * (target / w)
}

/// Largest size at which every line fits its width (lines are then only
/// ever stretched by justification, as in the original).
#let fit-lines(font, weight, lines, widths) = {
  let sizes = lines
    .zip(widths)
    .map(((l, w)) => {
      let m = measure(text(font: (font, "EB Garamond"), weight: weight, size: 10pt, features: (locl: 0), l)).width
      10pt * (w / m)
    })
  calc.min(..sizes)
}

#let crop(path, w) = image(path, width: px(w))

/// A labelled cell. `body` is set at true size, then scaled by Z.
#let cell(label, note, body, original: false, zoom: Z) = block(
  breakable: false,
  width: 100%,
  inset: 6pt,
  radius: 3pt,
  stroke: if original { 1.2pt + red } else { 0.5pt + luma(200) },
  {
    text(size: 8.5pt, weight: 600, label)
    if note != none { text(size: 7.5pt, fill: luma(110))[ · #note] }
    v(3pt)
    scale(zoom, reflow: true, origin: top + left, body)
  },
)

#let palette(cols, ..cells) = grid(columns: (1fr,) * cols, gutter: 8pt, ..cells)

/// Body-like text settings shared by the samples.
#let body-set(font, weight, size, body) = {
  set text(
    // EB Garamond supplies glyphs (℣ ℟ ǽ) a candidate lacks.
    font: (font, "EB Garamond"),
    weight: weight,
    size: size,
    lang: "la",
    features: (locl: 0),
    top-edge: 0.66em,
    bottom-edge: -0.2em,
    hyphenate: false,
  )
  body
}

#let lb = linebreak(justify: true)
#let star = box(text(size: 1.3em, baseline: 0.17em, top-edge: "baseline", bottom-edge: "baseline", "*"))

// ---------------------------------------------------------------------
//  Candidates: (family, body weight, red weight, licence)
// ---------------------------------------------------------------------

#let body-fonts = (
  ("EB Garamond", 500, 600, OFL + " · current"),
  ("EB Garamond", 400, 600, OFL),
  ("Crimson Pro", 400, 600, OFL),
  ("Brygada 1918", 500, 600, OFL),
  ("Literata", 400, 600, OFL),
  ("Source Serif 4", 400, 600, OFL),
  ("Spectral", 500, 600, OFL),
  ("Noto Serif", 400, 600, OFL),
  ("Cardo", 400, 700, OFL),
  ("Libre Caslon Text", 400, 700, OFL),
  ("Merriweather", 400, 700, OFL),
  ("Gentium Book Plus", 400, 700, OFL),
  ("Sorts Mill Goudy", 400, 400, OFL + " · no bold"),
  ("Old Standard TT", 400, 700, OFL),
  ("PT Serif", 400, 700, OFL),
  ("Libertinus Serif", 400, 600, OFL),
  ("Charter", 400, 700, MAC),
  ("Iowan Old Style", 400, 700, MAC),
  ("Palatino", 400, 700, MAC),
  ("Times New Roman", 400, 700, MAC),
  ("Georgia", 400, 700, MAC),
  ("Baskerville", 400, 600, MAC),
  ("Hoefler Text", 400, 700, MAC),
  ("Cochin", 400, 700, MAC),
)

// =====================================================================
#align(center)[
  #text(size: 22pt)[Font palette] \
  #text(size: 11pt, fill: luma(90))[Breviarium Carmelitanum 1938 · pp. 21–30]
]

#v(0.6em)
Each section shows the *original* (red frame) followed by candidates. Every
sample uses the original's line breaks, and each font is sized automatically
so its lines are as long as the original's — compare letter shapes, weight
and colour rather than size. Samples are shown at #(Z) of print size. Licences:
*OFL* fonts may be bundled with the project; *macOS only* fonts are
installed system fonts that can be used locally but not redistributed.

// =====================================================================
= 1 · Body text

Verses, red labels (#text(fill: red)[Ant.], ℣, ℟) and the pause asterisk.
The label under each sample gives the computed size and the body / red weights.

#let body-width = 113.5pt
#let ind = 0.85 * 10pt // approximate indent at ~10pt
#let body-lines = (
  ("Quóniam justus Dóminus,", body-width - ind),
  ("et justítias diléxit : * æqui-", body-width),
  ("Ant. Rex sine fine ma-", body-width - ind),
  ("nens, míseris tu parce", body-width),
  ("ruínis : prǽmia concédens,", body-width),
  ("℣. Exaltáre, Dómine, in", body-width - ind),
  ("virtúte tua. ℟. Cantábimus,", body-width),
)

#let body-sample(font, bw, rw) = context {
  let size = fit-lines(font, bw, body-lines.map(l => l.at(0)), body-lines.map(l => l.at(1)))
  let r(x) = text(fill: red, weight: rw, x)
  let pitch = 9.7pt
  body-set(font, bw, size, {
    set par(
      justify: true,
      leading: pitch - 0.86em,
      spacing: pitch - 0.86em,
      first-line-indent: (amount: 0.85em, all: true),
    )
    block(width: body-width)[
      Quóniam justus Dóminus,#lb et justítias diléxit : #star æqui-#lb tátem vidit vultus ejus.

      #r[Ant.] Rex sine fine ma-#lb nens, míseris tu parce#lb ruínis : prǽmia concédens,#lb et tua cuncta regens.

      #r[℣.] Exaltáre, Dómine, in#lb virtúte tua. #r[℟.] Cantábimus,#lb et psallémus virtútes tuas.
    ]
  })
  place(bottom + right, dx: 8pt, text(
    font: "EB Garamond",
    size: 5pt,
    fill: luma(130),
    str(calc.round(size.pt(), digits: 1)) + " pt",
  ))
}

#palette(
  3,
  cell([Original], [p. 27], crop("assets/crops/body.png", 490), original: true),
  ..body-fonts.map(((f, bw, rw, lic)) => cell(f, [#bw / #rw · #lic], body-sample(f, bw, rw))),
)

// =====================================================================
= 2 · Red text: rubrics, titles, running head

These follow the body face in its red (heavier) weight.

#let rubric-lines = (
  "¶ Asteriscus *, in Psalmorum",
  "versibus et in aliis Officii par-",
  "tibus insertus, denotat pausam",
  "cantus et recitationis in Choro;",
)

#let red-sample(font, bw, rw) = context {
  let rsize = fit-lines(font, rw, rubric-lines, (body-width - ind,) + (body-width,) * 3)
  let tsize = fit-size(font, rw, "Psalmus 1", 40.8pt)
  let hsize = fit-size(font, rw, "Dominica ad Matutinum, in I Nocturno", 172.3pt)
  body-set(font, rw, rsize, {
    set text(fill: red)
    set par(justify: true, leading: 8.1pt - 0.86em, first-line-indent: (amount: 0.85em, all: true))
    block(width: body-width)[
      #text(fill: black, weight: bw, size: 0.85em)[¶] Asteriscus #star, in Psalmorum#lb versibus et in aliis Officii par-#lb tibus insertus, denotat pausam#lb cantus et recitationis in Choro;
    ]
    v(4pt)
    block(width: body-width, align(center, text(size: tsize)[Psalmus #text(number-type: "old-style")[1]]))
  })
  v(4pt)
  body-set(font, rw, hsize, block(width: 216pt, stroke: (bottom: 0.5pt), inset: (bottom: 2pt), text(
    fill: red,
    number-type: "old-style",
  )[
    22 #h(1fr) Dominica ad Matutinum, in I Nocturno #h(1fr)
  ]))
}

#palette(
  2,
  cell(
    [Original],
    [pp. 22],
    {
      crop("assets/crops/rubric.png", 490)
      crop("assets/crops/title.png", 320)
      crop("assets/crops/header.png", 900)
    },
    original: true,
    zoom: 115%,
  ),
  ..body-fonts.map(((f, bw, rw, lic)) => cell(f, [#rw · #lic], red-sample(f, bw, rw), zoom: 115%)),
)

// =====================================================================
= 3 · Day title — “DOMINICA”

A narrow, bold transitional capital.

#let day-fonts = (
  ("EB Garamond", 700, OFL + " · current"),
  ("Charter", 700, MAC),
  ("Times New Roman", 700, MAC),
  ("PT Serif", 700, OFL),
  ("Source Serif 4", 700, OFL),
  ("Noto Serif", 700, OFL),
  ("Libre Caslon Text", 700, OFL),
  ("Old Standard TT", 700, OFL),
  ("Brygada 1918", 700, OFL),
  ("Literata", 700, OFL),
  ("Merriweather", 700, OFL),
  ("Spectral", 700, OFL),
  ("Crimson Pro", 700, OFL),
  ("Libertinus Serif", 700, OFL),
  ("Gentium Book Plus", 700, OFL),
  ("Cardo", 700, OFL),
  ("Baskerville", 700, MAC),
  ("Georgia", 700, MAC),
  ("Bodoni 72", 700, MAC),
  ("Superclarendon", 700, MAC),
)

#let word-sample(font, weight, word, target, tracking: 0em) = context {
  let (w, st) = if type(weight) == array { weight } else { (weight, 100%) }
  let m = measure(text(font: font, weight: w, stretch: st, size: 10pt, tracking: tracking, word)).width
  text(font: font, weight: w, stretch: st, size: 10pt * (target / m), tracking: tracking, word)
}

#palette(
  4,
  cell([Original], [p. 21], crop("assets/crops/day.png", 330), original: true),
  ..day-fonts.map(((f, w, lic)) => cell(f, [#w · #lic], box(width: px(330), align(center, word-sample(
    f,
    w,
    "DOMINICA",
    66pt,
  ))))),
)

// =====================================================================
= 4 · Hour title — “Ad Matutinum”

A letter-spaced Clarendon-style slab, almost typewriter-like.

#let hour-fonts = (
  ("EB Garamond", 700, OFL + " · current"),
  ("Superclarendon", 400, MAC),
  ("Superclarendon", 700, MAC),
  ("American Typewriter", 600, MAC),
  ("American Typewriter", 700, MAC),
  ("American Typewriter", (600, 75%), MAC + " · condensed"),
  ("American Typewriter", (700, 75%), MAC + " · condensed"),
  ("Rockwell", 700, MAC),
  ("Rokkitt", 600, OFL),
  ("Rokkitt", 700, OFL),
  ("Kreon", 600, OFL),
  ("Courier Prime", 700, OFL),
  ("Courier New", 700, MAC),
  ("Zilla Slab", 600, OFL),
  ("Zilla Slab", 700, OFL),
  ("Roboto Slab", 600, OFL),
  ("Bitter", 600, OFL),
  ("Arvo", 700, OFL),
  ("Aleo", 600, OFL),
  ("Charter", 700, MAC),
  ("PT Serif", 700, OFL),
)

#palette(
  4,
  cell([Original], [p. 21], crop("assets/crops/hour.png", 330), original: true),
  ..hour-fonts.map(((f, w, lic)) => cell(f, [#(if type(w) == array { w.at(0) } else { w }) · #lic], box(
    width: px(330),
    height: px(70),
    align(center + horizon, word-sample(f, w, "Ad Matutinum", 70pt, tracking: 0.04em)),
  ))),
)

// =====================================================================
= 5 · Blackletter titles

The original sets textura lower case with *Lombardic* capitals (note the
round P, B, V, M, C). The “+ Lombardic caps” rows swap the capitals for a
Lombardic face.

#let black-fonts = (
  ("Cloister", none, "freeware · current"),
  ("Old London", none, "freeware"),
  ("UnifrakturMaguntia", none, OFL),
  ("UnifrakturCook", none, OFL),
  ("Pirata One", none, OFL),
  ("Grenze Gotisch", none, OFL),
  ("Cloister", "Lombardic", "caps: shareware"),
  ("Old London", "Lombardic", "caps: shareware"),
  ("UnifrakturMaguntia", "Lombardic", "caps: shareware"),
  ("Cloister", "Kingthings Versalis", "caps: free"),
  ("Old London", "Kingthings Versalis", "caps: free"),
  ("Cloister", "Uncial Antiqua", "caps: " + OFL),
  ("UnifrakturMaguntia", "Uncial Antiqua", "caps: " + OFL),
  ("Old London", "Luminari", "caps: " + MAC),
)

/// Blackletter with optional Lombardic capitals, sized to `target` width.
#let black-line(font, caps, body, target) = context {
  let styled(size) = {
    show regex("\p{Lu}"): it => if caps != none { text(font: caps, it) } else { it }
    text(font: font, fill: red, size: size, top-edge: "bounds", bottom-edge: "bounds", body)
  }
  let w = measure(styled(10pt)).width
  styled(10pt * (target / w))
}

#let black-sample(font, caps) = block(width: px(900), {
  set align(center)
  set block(spacing: 5pt)
  block(black-line(font, caps, "Psalterium", 84.7pt))
  block(text(font: "EB Garamond", size: 9.6pt, tracking: 0.1em)[BREVIARII ORDINIS FRATRUM])
  block(black-line(font, caps, "B. V. Mariae de Monte Carmelo", 202pt))
})

#palette(
  2,
  cell([Original], [p. 21], crop("assets/crops/blackletter.png", 900), original: true, zoom: 115%),
  ..black-fonts.map(((f, caps, lic)) => cell(
    if caps == none { f } else [#f + #caps caps],
    lic,
    black-sample(f, caps),
    zoom: 115%,
  )),
)

// =====================================================================
= 6 · Red two-line initials (versals)

The original uses Lombardic versals. Each row sets the same nine letters,
scaled to the original's height (two lines).

#let versal-fonts = (
  ("EB Garamond", 600, OFL + " · current"),
  ("Lombardic", 400, "shareware ($15 fee) · Goudy Lombardic by M. Snyder"),
  ("EasyLombardic Two", 400, "freeware?"),
  ("Kingthings Versalis", 400, "free for any use (Kevin King)"),
  ("Uncial Antiqua", 400, OFL),
  ("MedievalSharp", 400, OFL),
  ("Almendra Display", 400, OFL),
  ("Luminari", 400, MAC),
  ("Cloister", 400, "freeware"),
  ("Old London", 400, "freeware"),
  ("UnifrakturMaguntia", 400, OFL),
  ("UnifrakturCook", 700, OFL),
  ("Pirata One", 400, OFL),
  ("Grenze Gotisch", 600, OFL),
)

#let versal-sample(font, weight) = context {
  let letters = "NQCPEIJBL".clusters()
  // Scale so the tallest letter matches the original's two-line height.
  let edges = (top-edge: "bounds", bottom-edge: "bounds")
  let lh = calc.max(..letters.map(l => measure(text(font: font, weight: weight, size: 10pt, ..edges, l)).height))
  let size = 10pt * (px(67) / lh)
  set text(font: font, weight: weight, size: size, fill: red, ..edges)
  box(height: px(80), align(left + horizon, letters.map(l => box(l)).join(h(px(14)))))
}

#palette(
  2,
  cell([Original], [pp. 21–29], crop("assets/crops/initials-strip.png", 629), original: true, zoom: 115%),
  ..versal-fonts.map(((f, w, lic)) => cell(f, lic, versal-sample(f, w), zoom: 115%)),
)

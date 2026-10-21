// =====================================================================
//  Breviarium Ordinis Fratrum B. V. Mariæ de Monte Carmelo (1938)
//  Composable block library
// =====================================================================
//
//  The library is layered. Each layer only builds on the ones above it:
//
//    1. Tokens      colours, fonts, sizes and the vertical grid
//    2. Atoms       inline marks: red ink, ℣ ℟, the pause asterisk, labels
//    3. Lines       indented paragraphs ("Ant. …", "℣. … ℟. …", plain lines)
//    4. Headings    psalm titles, hour titles, nocturns, rules
//    5. Initials    woodcut and red versal drop capitals
//    6. Blocks      psalm, canticle, hymn, capitulum, invitatory, rubric
//    7. Page        page geometry, running head, two-column frame, title page
//
//  A document only needs `setup` plus layers 3–7. Everything typographic is
//  driven by the tokens in layer 1 so the whole book can be retuned in one
//  place.

#import "@preview/droplet:0.3.1": dropcap

// =====================================================================
//  1. Tokens
// =====================================================================

/// Rubrical red, sampled from the scans.
#let red = rgb(224, 53, 48)

#let fonts = (
  body: "Plantin",
  // Blackletter for the grand titles.
  black: "Cloister",
  // Black woodcut initials (Psalms 1, 8, 9 iij, 92 …).
  woodcut: "Goudy Initialen",
  // Red two-line versals. The original uses Lombardic capitals; swap this
  // for a Lombardic face when one is chosen.
  versal: "EasyLombardic Two",
  // "DOMINICA": a narrow bold transitional face (Charter Bold is close).
  day: "Old Standard TT",
  // "Ad Matutinum": a Clarendon-style slab (Superclarendon is close).
  hour: "Plantin Condensed",
)

#let sizes = (
  body: 10.3pt,
  rubric: 9pt,
  title: 10.6pt, // Psalmus 1, Hymnus, Capitulum
  head: 10.3pt, // running head
  hour: 10.4pt, // Ad Matutinum
  nocturn: 7.6pt, // IN I NOCTURNO
  day: 12.5pt, // DOMINICA
)

/// Weight of body text. The 1938 printing is inked heavily; EB Garamond
/// Medium matches its colour better than Regular.
#let body-weight = 400
/// Weight used for everything printed in red.
#let red-weight = 600

/// Baseline-to-baseline distance of body text.
#let pitch = 9.7pt
/// Baseline-to-baseline distance of rubrics.
#let rubric-pitch = 8.1pt

/// Every line box has a fixed height: `top-edge` (≈ cap height) above the
/// baseline and `bottom-edge` below, regardless of accents or stray glyphs.
/// Leading is then `pitch - line-box`, which keeps all text on a fixed grid.
#let top-edge = 0.66em
#let bottom-edge = -0.2em
#let line-box = top-edge - bottom-edge
#let leading-for(p) = p - line-box

/// First-line indent of verses, antiphons and versicles.
#let indent = 0.85em
/// Indent of the turned-over lines of a hymn verse.
#let hymn-hang = 0.9em
/// Extra indent of the short (Adonic) last line of a Sapphic stanza.
#let hymn-short = 1.4em

#let column-gutter = 6pt
#let rule-weight = 0.5pt

// =====================================================================
//  2. Atoms
// =====================================================================

/// Red ink (the rubrical colour) in the rubrical weight.
#let r(body) = text(fill: red, weight: red-weight, body)

/// Versicle and response signs.
#let V = r[℣.]
#let R = r[℟.]

/// A red label followed by a word space: "Ant.", "Invitat.", "Sacerd." …
#let lab(name) = r(name) + [ ]

/// The mediant pause. In source text write `\*`; `setup` renders it.
#let pause(fill: auto) = context box(text(
  fill: if fill == auto { text.fill } else { fill },
  size: 1.3em,
  baseline: 0.17em,
  // Contribute no height so lines with a pause keep the grid.
  top-edge: "baseline",
  bottom-edge: "baseline",
  "*",
))

/// "Amen." set flush right with a red A, closing hymns.
#let amen() = block(width: 100%, above: leading-for(pitch), align(right)[#r[A]men.#h(1.6em)])

// =====================================================================
//  3. Lines
// =====================================================================
//
//  Nearly everything in the breviary is a "line": a justified paragraph
//  whose first line is indented, optionally opened by a red label.

/// A plain indented paragraph, optionally led by a red label.
#let line-of(label: none, body) = par(first-line-indent: (amount: indent, all: true))[
  #if label != none { lab(label) }#body
]

/// A run of paragraphs, each indented (psalm verses, opening prayers).
#let lines(body) = {
  set par(first-line-indent: (amount: indent, all: true))
  body
}

/// "Ant. …"
#let antiphon(body) = line-of(label: "Ant.", body)

/// "℣. … ℟. …". With `newline: true` the response starts a new, flush line.
/// `prefix` adds a red label before the versicle, e.g. "Sacerd.".
#let versicle(v, resp, prefix: none, newline: false) = line-of(label: prefix)[
  #V #v#if newline { linebreak() } else [ ]#R #resp
]

/// A lone versicle "℣. …".
#let v-line(body) = line-of[#V #body]
/// A lone response "℟. …".
#let r-line(body) = line-of[#R #body]

/// "Pater, Ave et Credo." / "(Pater et Ave)."
#let pater-ave(credo: false, silent: false) = line-of({
  if silent {
    [#r[(]Pater #r[et] Ave#r[)].]
  } else if credo {
    [Pater, Ave #r[et] Credo.]
  } else {
    [Pater #r[et] Ave.]
  }
})

// =====================================================================
//  4. Headings
// =====================================================================

/// Red centred title: "Psalmus 1", "Hymnus", "Canticum trium Puerorum".
/// `sub` is an optional red reference line beneath ("Dan. 3, 57-88 et 56").
#let title(body, sub: none, above: 0.35em) = block(
  width: 100%,
  above: above,
  below: 0pt,
  breakable: false,
  sticky: true,
  align(center, {
    text(size: sizes.title, fill: red, weight: red-weight, body)
    if sub != none {
      linebreak()
      text(size: sizes.rubric + 0.6pt, fill: red, weight: red-weight, sub)
    }
  }),
)

/// Running-head marker: every page shows the last title set on or before it.
#let running-head(body) = [#metadata(body)<running-head>]

/// Hour title, e.g. "Ad Matutinum". `head` is the running head it opens.
#let hour(body, head: none) = {
  if head != none { running-head(head) }
  block(width: 100%, above: 0.6em, below: 0.45em, sticky: true, align(center, text(
    font: fonts.hour,
    size: sizes.hour,
    weight: 700,
    tracking: 0.06em,
    body,
  )))
}

/// "IN I NOCTURNO" — small spaced capitals.
#let nocturn(n, head: none) = {
  if head != none { running-head(head) }
  block(width: 100%, above: 0.8em, below: 0.25em, sticky: true, align(center, text(
    size: sizes.nocturn,
    tracking: 0.08em,
    upper[In #numbering("I", n) Nocturno],
  )))
}

/// Day title, e.g. "DOMINICA".
#let day(body) = align(center, text(
  font: fonts.day,
  size: sizes.day,
  weight: 700,
  upper(body),
))

/// Red double rule closing a section.
#let double-rule(width: 100%) = block(width: 100%, above: 0.7em, below: 0.7em, align(center, stack(
  spacing: 1.7pt,
  line(length: width, stroke: 1.1pt + red),
  line(length: width, stroke: 0.8pt + red),
)))

// =====================================================================
//  5. Initials
// =====================================================================

/// Height of an initial that drops `n` lines: from the top of the first
/// line box to the baseline of line `n`.
#let drop-height(n) = (n - 1) * pitch + top-edge

/// Drop capital on the first paragraph of `body`.
///
///  style: "woodcut"  black ornamented initial, three lines deep
///         "versal"   red initial, two lines deep
///         "inline"   first letter in red at text size (later hymn stanzas)
///         none       no initial
///
/// The text should be written as printed: the letter after the initial is
/// a capital ("DOmine", "BEátus").
#let initial(style: "versal", lines: auto, body) = {
  if style == none { return body }
  if style == "inline" {
    // Colour the first character only.
    let s = if type(body) == str { body } else { body.text }
    return r(s.clusters().first()) + s.clusters().slice(1).join()
  }
  let woodcut = style == "woodcut"
  let n = if lines == auto { if woodcut { 3 } else { 2 } } else { lines }
  // droplet sets the initial in an inline box, whose line then adds a
  // descender below the last line beside the initial. Measuring lines from
  // the baseline (bottom-edge 0) with the leading enlarged to match keeps
  // the paragraph on the grid; `verses` restores the descender after it.
  set par(first-line-indent: 0pt, leading: pitch - top-edge, spacing: pitch - top-edge)
  set text(bottom-edge: 0pt)
  context dropcap(
    height: drop-height(n).to-absolute(),
    gap: if woodcut { 2.5pt } else { 1.2pt },
    hanging-indent: 0.45em,
    font: if woodcut { fonts.woodcut } else { fonts.versal },
    fill: if woodcut { black } else { red },
    weight: if woodcut { 400 } else { red-weight },
    body,
  )
}

/// Split content at its first paragraph break: (first, rest).
#let split-first-par(body) = {
  if body.func() != [].func() { return (body, none) }
  let kids = body.children
  // Skip leading whitespace.
  while kids.len() > 0 and kids.first() in ([ ], parbreak()) { kids = kids.slice(1) }
  let i = kids.position(c => c.func() == parbreak)
  if i == none { return (kids.join(), none) }
  (kids.slice(0, i).join(), kids.slice(i + 1).join())
}

// =====================================================================
//  6. Blocks
// =====================================================================

/// Body of a psalm or canticle: first verse with an initial, the rest as
/// indented verses. Verses are separated by blank lines in the source.
#let verses(initial-style: "versal", body) = {
  let (first, rest) = split-first-par(body)
  block(above: 0.25em, below: leading-for(pitch) - bottom-edge, initial(style: initial-style, first))
  if rest != none { lines(rest) }
}

/// A psalm: red title + verses.
///   #psalm("Psalmus 1", initial: "woodcut")[BEátus vir … \* et …]
#let psalm(heading, sub: none, initial: "versal", body) = {
  title(heading, sub: sub)
  verses(initial-style: initial, body)
}

/// A canticle is a psalm with a source reference.
#let canticle(heading, ref, initial: "versal", body) = psalm(heading, sub: ref, initial: initial, body)

/// A rubric: small red text, first line indented. `mark` prefixes a black
/// pilcrow (¶) or another sign (❦). Use `blk[…]` for words printed black.
#let rubric(mark: none, size: sizes.rubric, body) = block(above: 0.45em, below: 0.4em, {
  set text(size: size, fill: red, weight: red-weight)
  set par(leading: leading-for(rubric-pitch), spacing: leading-for(rubric-pitch))
  line-of({
    if mark != none { text(fill: black, weight: 400, size: 0.85em, mark) + h(0.25em) }
    body
  })
})

/// Black words inside a rubric (e.g. the incipit "Glória Patri").
#let blk(body) = text(fill: black, weight: body-weight, size: sizes.rubric + 0.4pt, body)

/// A hymn. Pass a string: stanzas separated by blank lines, verse lines by
/// newlines. The first stanza gets a red versal, later stanzas a red first
/// letter; the last line of a stanza is indented as an Adonic unless
/// `short-last: false`. Closes with "Amen." when `amen: true`.
#let hymn(text-src, heading: "Hymnus", short-last: true, amen-line: true) = {
  if heading != none { title(heading) }
  let stanzas = text-src.trim().split(regex("\n\s*\n"))
  for (si, stanza) in stanzas.enumerate() {
    let verse-lines = stanza.split("\n").map(str.trim)
    block(above: if si == 0 { 0.25em } else { 0.45em }, below: 0pt, {
      set par(hanging-indent: hymn-hang, first-line-indent: 0pt)
      for (li, l) in verse-lines.enumerate() {
        let is-short = short-last and li == verse-lines.len() - 1
        let content = if li > 0 { [#l] } else if si == 0 {
          initial(style: "versal", [#l])
        } else { initial(style: "inline", l) }
        if li == 0 and si == 0 { content } else if is-short {
          par(first-line-indent: (amount: hymn-short, all: true), content)
        } else { par(content) }
      }
    })
  }
  if amen-line { amen() }
}

/// Capitulum: red "Capitulum ……… Ref." line, then the text with a versal.
#let capitulum(ref, body) = {
  block(width: 100%, above: 0.6em, below: 0.2em, sticky: true, text(size: sizes.title, fill: red, weight: red-weight)[
    Capitulum #h(1fr) #ref#h(0.2em)
  ])
  verses(initial-style: "versal", body)
}

/// Reference to a psalm and page: "Ps. 94 Veníte, exsultémus 2."
#let psalm-ref(num, incipit, page) = [#r[Ps. #num] #incipit #r[#page.]]

/// Invitatory: red seasonal rubric then "Invitat. …" with red pause marks.
#let invitatory(season: none, body) = {
  if season != none {
    block(above: 0.45em, below: 0.1em, sticky: true, line-of(text(
      size: sizes.rubric + 0.3pt,
      fill: red,
      weight: red-weight,
      season,
    )))
  }
  show "*": pause(fill: red)
  line-of(label: "Invitat.", body)
}

// =====================================================================
//  7. Page
// =====================================================================

/// Page geometry (4 × 6.5 in trim).
#let page-geometry = (
  width: 4in,
  height: 6.5in,
  margin: (inside: 31pt, outside: 27pt, top: 46.5pt, bottom: 34pt),
)

/// Marks on which page the title-page block ends, so the column rule starts
/// below it.
#let rule-start = <column-rule-start>
#let rule-end = <column-rule-end>
#let suppress-head = <no-running-head>

/// Running head: page number outside, title centred, rule below.
#let running-head-display() = context {
  let pg = here().page()
  if query(suppress-head).any(m => m.location().page() == pg) { return }
  let marks = query(<running-head>).filter(m => m.location().page() <= pg)
  let head = if marks.len() > 0 { marks.last().value } else { [] }
  let num = text(fill: red, weight: red-weight, counter(page).display())
  set text(size: sizes.head, number-type: "old-style")
  block(width: 100%, inset: (bottom: 2.4pt), stroke: (bottom: rule-weight), {
    let even = calc.even(counter(page).get().first())
    grid(
      columns: (2.2em, 1fr, 2.2em),
      align: (left, center, right),
      if even { num }, text(fill: red, weight: red-weight, tracking: 0.02em, head), if not even { num },
    )
  })
}

/// Red rule between the two columns. Starts below a title block or the
/// header rule, and stops at an explicit end mark if one is on this page.
#let column-rule() = context {
  let pg = here().page()
  let m = page-geometry.margin
  let y0 = m.top + 1pt
  let starts = query(rule-start).filter(x => x.location().page() == pg)
  if starts.len() > 0 { y0 = starts.first().location().position().y }
  let y1 = page-geometry.height - m.bottom + 1pt
  let ends = query(rule-end).filter(x => x.location().page() == pg)
  if ends.len() > 0 { y1 = ends.first().location().position().y }
  let even = calc.even(counter(page).get().first())
  let lm = if even { m.outside } else { m.inside }
  let rm = if even { m.inside } else { m.outside }
  let x = lm + (page-geometry.width - lm - rm) / 2
  place(dx: x, dy: y0, line(angle: 90deg, length: y1 - y0, stroke: rule-weight + red))
}

/// End the two-column flow here (the column rule stops on this page).
#let end-columns() = [#metadata(none)#rule-end]

/// Full-width block at the top of a page (spans both columns).
#let spanning(body) = place(
  top + center,
  scope: "parent",
  float: true,
  clearance: 0.6em,
  {
    body
    // The column rule starts where the columns do, just below this block.
    v(0.6em)
    [#metadata(none)#rule-start]
  },
)

/// Content raised by `rise` into the space above it (e.g. into the top
/// margin) while the following content keeps flowing below it.
#let raised(rise, body) = pad(top: -rise, body)

/// Title page block for a major part of the book: woodcut emblem,
/// blackletter title, order name and description, red double rule and
/// the title of the first day. The block rises into the top margin.
#let part-title(
  emblem: none,
  title: [],
  subtitle: [],
  order: [],
  description: [],
  day-title: [],
) = spanning({
  [#metadata(none)#suppress-head]
  set align(center)
  set par(justify: false)
  // Each line is a block whose top sits on the previous baseline;
  // `gap` is the distance between consecutive baselines.
  let row(gap, body) = block(above: 0pt, below: 0pt, height: gap, width: 100%, align(bottom, body))
  set text(top-edge: "cap-height", bottom-edge: "baseline")
  if emblem != none { block(below: 0pt, raised(15pt, emblem)) }
  row(26pt, text(font: fonts.black, size: 20pt, fill: red, title))
  row(19.5pt, text(size: 10.4pt, tracking: 0.1em, upper(subtitle)))
  row(21.5pt, text(font: fonts.black, size: 14.4pt, fill: red, tracking: 0.05em, order))
  set par(leading: 5.2pt)
  row(16.5pt + 12pt, text(size: 8.1pt, weight: 600, tracking: 0.07em, upper(description)))
  block(above: 7pt, below: 0pt, double-rule())
  row(29pt, day(day-title))
  v(3pt)
})

/// Document setup.
#let setup(first-page: 1, body) = {
  set document(title: "Breviarium Carmelitanum – Psalterium")
  set page(
    ..page-geometry,
    columns: 2,
    header: running-head-display(),
    header-ascent: 18%,
    background: column-rule(),
  )
  set columns(gutter: column-gutter)
  counter(page).update(first-page)

  set text(
    font: fonts.body,
    size: sizes.body,
    weight: body-weight,
    lang: "la",
    number-type: "old-style",
    top-edge: top-edge,
    bottom-edge: bottom-edge,
    hyphenate: true,
    // EB Garamond's Latin `locl` turns u into v; the breviary prints u.
    features: (locl: 0),
    // The original breaks columns anywhere, leaving widows and orphans.
    costs: (widow: 0%, orphan: 0%, hyphenation: 60%),
  )
  set par(
    justify: true,
    leading: leading-for(pitch),
    spacing: leading-for(pitch),
    linebreaks: "optimized",
    // The compositor squeezed word spaces hard and hyphenated freely.
    justification-limits: (
      spacing: (min: 66%, max: 160%),
      tracking: (min: -0.012em, max: 0.01em),
    ),
  )
  set block(spacing: leading-for(pitch))

  // Text conventions in the source.
  show "*": pause()
  show "†": r
  show "℣": it => text(fill: red, it)
  show "℟": it => text(fill: red, it)

  body
}

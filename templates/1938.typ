// ====== Imports ======

#import "@preview/droplet:0.3.1"

// ====== Helpers ======

#let parse_error(title, body) = {
  set par(justify: false)
  set text(size: 8pt, font: "DejaVu Sans Mono")
  block(fill: rgb("#ffb6b6"), stroke: 1pt + rgb("#ff6868"), inset: 8pt, radius: 4pt)[
    #title \
    #body
  ]
}

#let titlecase(string) = {
  return string.replace(
    regex("[A-Za-z]+('[A-Za-z]+)?"),
    word => upper(word.text.first()) + lower(word.text.slice(1)),
  )
}

#let hl_color = rgb(198, 57, 52)

#let two_columns(body) = {
  place(line(start: (50%, 0%), end: (50%, 100%), stroke: .75pt + hl_color))
  columns(2, body)
  // Add a line to separate the columns
}

// (H)igh(l)ight function
#let hl(body, ..text-args) = text(fill: hl_color, weight: "semibold", ..text-args, body)

#let sp1 = .6em
#let sp2 = .8em
#let sp3 = .1em

#let unimplemented() = {
  set text(blue)
  align(center)[
    \[ missing \] \
    #text(.6em)[We are still working on this Block]
  ]
}

#let dropcap(level: 1, body: "") = {
  // Highlight notes between square brackets
  let notes_regex = regex("\[(.+?)\]")
  show notes_regex: it => {
    set text(fill: hl_color, size: .8em)
    [#it.text.match(notes_regex).captures.first()]
  }

  // Don't apply a dropcap if the body is too short or numbered
  if body.len() < 2 or body.at(0) == "[" {
    [#body]
  } else if level == 1 {
    droplet.dropcap(
      height: 2,
      justify: true,
      gap: 2pt,
      fill: hl_color,
      font: "Old London",
    )[#body]
  } else if level == 2 {
    droplet.dropcap(
      height: 2,
      justify: true,
      gap: 2pt,
      fill: hl_color,
      font: "EB Garamond",
    )[#body]
  } else {
    panic("dropcap() only excepts a level of 1-2")
  }
}

// ===== Global Theme Styles =====

#let setup(title, page_number: 1, body) = {
  // context counter(page).update(page_number)

  set page(
    width: 4in,
    height: 6.375in,
    margin: (top: 30pt, bottom: 36pt, x: 30pt),
    header: [
      #set text(9pt, hl_color, weight: "semibold")
      #rect(
        width: 100%,
        inset: (x: 0pt, y: 4pt),
        stroke: (
          bottom: .6pt,
        ),
      )[
        #place(
          top + right,
          "51",
          // counter(page).display("[1]"),
        )
        #align(center, title)
      ]
    ],
  )

  set text(
    font: "EB Garamond",
    size: 10pt,
    tracking: -.2pt,
    number-type: "old-style",
    weight: "regular",
  )

  set par(
    justify: true,
    leading: .4em,
  )

  show "*": text(size: 8pt, "★")

  show heading.where(level: 1): it => {
    set align(center)
    set text(
      font: "Old London",
      size: 1.1em,
      weight: "regular",
    )
    show regex("^\p{Lu}| \p{Lu}"): set text(hl_color)
    set block(spacing: 1em)
    it
  }

  show heading.where(level: 2): it => {
    set align(center)
    set text(
      font: "EB Garamond",
      size: 9pt,
      weight: "regular",
      tracking: .05em,
    )
    set block(spacing: .4em)
    upper(it)
  }

  show heading.where(level: 3): it => {
    set align(center)
    set text(
      font: "EB Garamond",
      size: .8em,
      weight: "regular",
    )
    set block(spacing: .4em)
    upper(it)
  }

  body
}

// ===== Titles =====

#let grand-title(it) = {
  set align(center)
  set text(
    font: "Old London",
    size: 1.6em,
    weight: "regular",
  )
  show regex("^\p{Lu}| \p{Lu}"): set text(hl_color)
  set block(spacing: 1em)
  it
}

#let date-title(it) = {
  set align(center)
  set text(
    font: "EB Garamond",
    size: .8em,
    weight: "regular",
  )
  set block(spacing: .4em)
  upper(it)
}

#let redcaps-title(it) = {
  set align(center)
  set text(
    font: "EB Garamond",
    size: 1em,
    weight: "regular",
    tracking: .1em,
    fill: hl_color,
  )
  set block(spacing: .4em)
  upper(it)
}

// ===== Header Block Types =====

#let feast(title: "", designation: "", ranking: "", date: "") = {
  stack(
    spacing: 1.2em,
    date-title(date),
    grand-title(title),
    redcaps-title(ranking),
  )
  v(.8em)
}

#let temporale_feast(title: "", season: "", week: 0, weekday: 0, ranking: "", body) = {
  stack(
    spacing: 1.2em,
    date-title(season),
    grand-title(title),
    if ranking != "" {
      redcaps-title(ranking)
    },
  )
  v(.8em)
}

#let common(title: "") = {
  heading(depth: 1)[#title]
}

// ====== Block Types ======

#let hour(type: "") = {
  heading(depth: 2)[#titlecase(type)]
}

#let alia(title: "", subtitle: "") = {
  set align(center)
  stack(
    spacing: sp1,
    line(length: 25%, stroke: .75pt),
    [== #title],
    hl(subtitle),
  )
}

#let bible_preview(number: 0, title: "", book: "", chapter: 0, start_verse: 0, end_verse: 0, content: "") = {
  stack(
    spacing: .6em,
    align(center, title),
    hl[
      #title
      Lectio #numbering("i", number)
      #h(1fr)
      Cap. #chapter, #start_verse\-#end_verse
    ],
    dropcap(level: 1, body: content),
  )
}

#let lesson(number: 0, title: "", reference: "", content: "") = {
  set block(below: sp1)
  let level = if number in (1, 4, 7) { 1 } else { 2 }
  stack(
    spacing: sp1,
    align(center, stack(
      spacing: sp1,
      title,
      hl[Lectio #numbering("i", number)],
      hl(reference),
    )),
    dropcap(level: level, body: content),
  )
}

#let nocturn(number: 0) = [=== IN #numbering("I", number) NOCTURNO]

#let oration(content: "") = {
  stack(spacing: .6em, align(center, hl[Oratio]), block(spacing: 0pt, dropcap(level: 2, body: content)))
}

#let responsory(content: "") = {
  show "R. ": hl
  show "V. ": hl
  show "★": hl
  block(spacing: 0pt, content)
}

#let rubric(content) = hl(size: .8em, content)

#let sacerdotal_verse(verse: "", response: "", alleluja: 1) = [
  #hl("V.")
  #verse
  #hl("R.")
  #response
  #if alleluja == 1 [#hl[\(]alleluja#hl[\)].]
]

#let te_deum() = block(above: .4em)[#h(1em)Te Deum]

#let psalm(number: 50, show_title: true, body) = {
  if show_title {
    align(center, block(above: sp2, below: sp3)[
      #set text(weight: "semibold", fill: hl_color)
      Psalmus #number
    ])
    set par(spacing: .4em, first-line-indent: (all: true, amount: sp1))
    droplet.dropcap(
      height: 2,
      justify: true,
      gap: 2pt,
      fill: hl_color,
      // font: "Old London",
      body,
    )
  } else {
    set par(spacing: .4em, first-line-indent: (all: true, amount: sp1))
    body
  }
}

#let antiphon(body) = {
  block(above: sp2, below: sp2)[
    #stack(
      spacing: sp1,
      [#hl[Ant.] #body],
    )
  ]
}

#let capitulum(title: "", book: "", chapter: 0, start_verse: 0, end_verse: 0, body) = {
  stack(
    spacing: sp1,
    hl[
      Capitulum #h(1fr) #book #chapter,
      #if start_verse == end_verse [
        #start_verse
      ] else [
        #start_verse\-#end_verse
      ]
    ],
    droplet.dropcap(
      height: 2,
      justify: true,
      gap: 2pt,
      fill: hl_color,
      // font: "Old London",
      body,
    ),
  )
}

#let hymn(body) = {
  align(center, block(above: sp2, below: sp1)[
    #set text(weight: "semibold", fill: hl_color)
    Hymnus
  ])
  set par(spacing: sp2)
  // Style the first letter of each stanza as red using rexex and show rules
  show "Amen.": align(right, block(above: sp3)[#hl[A]men.])
  droplet.dropcap(
    height: 2,
    justify: true,
    gap: 2pt,
    fill: hl_color,
    // font: "Old London",
    body,
  )
}

#let versicle(body) = {
  show "V.": text(hl_color)[℣.]
  show "R.": text(hl_color)[℟.]
  set par(spacing: sp2)
  body
}

#let nunc(body) = {
  stack(
    spacing: sp1,
    align(center, text(hl_color, weight: "semibold")[
      Canticum Simeonis
      #linebreak()
      Luc. 2, 29-32
    ]),
    droplet.dropcap(
      height: 2,
      justify: true,
      gap: 2pt,
      fill: hl_color,
      // font: "Old London",
      body,
    ),
  )
}

#let pater_et_ave() = [
  #hl[(]Pater #hl[et] Ave#hl[)].
]

#let deus_in_adjutorium() = [
  #text(hl_color)[℣.] Deus, in adjutórium.
]

#let fragment_registry = (
  hymn: (body, amen_line: bool) => {
    body
      .split("\n")
      .map(l => {
        if l != "" { par(text(red, l.at(0)) + l.slice(1)) }
      })
      .join()
  },
)

#let parseJSON = {
  json("sample.json")
    .fragments
    .map(it => {
      if it.type in fragment_registry {
        fragment_registry.at(it.type)(..it.attributes, it.content)
      }
    })
    .join()
}

#parseJSON

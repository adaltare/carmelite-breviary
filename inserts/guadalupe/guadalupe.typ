// =====================================================================
//  Die 12 Decembris — B. Mariæ Virg. de Guadalupe
//  Insert for the 1938 Carmelite Breviary, styled after the 1938
//  office of the Assumption (assumption-reference.pdf).
//
//  Text: 1938_Our_Lady_of_Guadalupe_Appendix.tex (unchanged).
//
//  Build from the repository root:
//    typst compile --root . --font-path mvp/fonts \
//      inserts/guadalupe/guadalupe.typ inserts/guadalupe/guadalupe.pdf
// =====================================================================

#import "@preview/droplet:0.3.1": dropcap

// =====================================================================
//  Tokens — all measured from the Assumption scans
// =====================================================================

/// Path of the header woodcut. `none` draws a placeholder of the same size.
#let woodcut-image = none // e.g. "20251031_131444495.png"

#let red = rgb(226, 35, 38)

#let fonts = (
  // Plantin has no ǽ; EB Garamond supplies it.
  body: "Plantin",
  // Plantin has only lining figures; the Assumption prints old-style.
  figures: "EB Garamond",
  // ℣ ℟ (missing from Plantin).
  signs: "Cardo",
  blackletter: "Cloister",
  woodcut: "Goudy Initialen",
)

#let sizes = (
  body: 10.6pt,
  rubric: 9pt, // red rubrics, Bened., Ad Nunc dimittis
  title: 10pt, // Hymnus, Oratio, Lectio ij
  sub: 9.6pt, // De verbis Apoc. …
  head: 11pt, // running head
  hour: 9.2pt, // IN I VESPERIS, AD MATUTINUM
  nocturn: 7.9pt, // IN I NOCTURNO
  day: 8pt, // DIE 12 DECEMBRIS
  feast: 19pt, // blackletter title
  rank: 9.1pt, // DUPLEX MAJUS I CLASSIS
)

/// Baseline-to-baseline distance of body text and of rubrics.
#let pitch = 10pt
#let rubric-pitch = 8.5pt

/// Fixed line box so accents never push lines off the grid.
#let top-edge = 0.7em
#let bottom-edge = -0.25em
#let leading-for(p) = p - (top-edge - bottom-edge)

/// Extra space between paragraphs (antiphons, versicles …).
#let par-gap = 2.6pt
#let indent = 0.5em

// Sheet and trim (pt, from the crop marks of the scans).
// #let sheet = (width: 385.5pt, height: 583.9pt)
#let sheet = (width: 383pt, height: 583.9pt)
#let trim = (x0: 36.7pt, x1: 348.8pt, y0: 36.7pt, y1: 541.8pt)
#let margin = (inside: 68.3pt, outside: 66pt, top: 86.4pt, bottom: 70pt)
#let gutter = 9.2pt
#let head-baseline = 73.7pt
#let head-rule = 81.8pt

// =====================================================================
//  Inline marks
// =====================================================================

#let r(body) = text(fill: red, body)
#let blk(body) = text(fill: black, body)
#let V = r[#text(font: fonts.signs)[℣].]
#let R = r[#text(font: fonts.signs)[℟].]
/// Mediant asterisk, black (antiphons) and red (responsories).
#let star = box(text(size: 1.1em, baseline: 0.12em, "*"))
#let rstar = r(star)
/// Small capitals made from capitals (Plantin has none).
#let sc(body) = text(size: 0.8em, tracking: 0.03em, upper(body))

// =====================================================================
//  Paragraph blocks
// =====================================================================

/// Small red rubric. `blk[…]` marks words printed black.
#let rubric(indent-first: true, body) = block(above: par-gap + 1pt, below: par-gap + 1pt, {
  set text(size: sizes.rubric, fill: red, spacing: .5em)
  set par(
    leading: leading-for(rubric-pitch),
    spacing: leading-for(rubric-pitch) + par-gap,
    first-line-indent: (amount: if indent-first { indent } else { 0pt }, all: true),
  )
  par(body)
})

/// "Bened. …" — small type, red label.
#let bened(body) = rubric[Bened. #blk(body)]

/// Red title centred over the column: Hymnus, Oratio, Lectio ij.
#let title(body, above: 7pt) = block(width: 100%, above: above, below: 0pt, sticky: true, align(
  center,
  text(size: sizes.title, fill: red, body),
))

/// Lectio or Capitulum with its reference set flush right.
#let title-ref(left, right, above: 7pt) = block(width: 100%, above: above, below: 3pt, sticky: true, context {
  // Shrink slightly if the pair would not fit on one line.
  let full = text(size: sizes.title)[#left#h(0.8em)#right]
  let s = calc.min(
    sizes.title,
    sizes.title * (((sheet.width - margin.inside - margin.outside - gutter) / 2) / measure(full).width),
  )
  text(size: s, fill: red)[#box(left) #h(1fr) #box(right)]
})

/// Hour heading in spaced capitals: IN I VESPERIS, AD MATUTINUM.
#let hour(body, sub: none) = block(width: 100%, above: 5pt, below: 5pt, sticky: true, align(center, {
  text(size: sizes.hour, tracking: 0.14em, upper(body))
  if sub != none {
    linebreak()
    text(size: sizes.sub, fill: red, sub)
  }
}))

/// Nocturn heading in small spaced capitals.
#let nocturn(body) = block(width: 100%, above: 10pt, below: 5pt, sticky: true, align(center, text(
  size: sizes.nocturn,
  tracking: 0.1em,
  upper(body),
)))

/// Black centred source line (De libro …, Homilía …), optional red sub.
#let source(body, sub: none) = block(width: 100%, above: 8pt, below: 2pt, sticky: true, align(center, {
  set par(leading: leading-for(pitch), justify: false)
  body
  if sub != none {
    linebreak()
    text(size: sizes.sub, fill: red, sub)
  }
}))

/// Drop initial. `letter` is dropped; `caps` follows it in capitals.
///   style "versal": red Plantin capital, two lines
///   style "woodcut": black woodcut initial, three lines
#let initial(style: "versal", letter, caps, body) = {
  set par(first-line-indent: 0pt)
  let woodcut = style == "woodcut"
  dropcap(
    height: if woodcut { 3 } else { 2 },
    gap: if woodcut { 3pt } else { 1.5pt },
    hanging-indent: if woodcut { 0.3em } else { 0.45em },
    font: if woodcut { fonts.woodcut } else { "Plantin" },
    fill: if woodcut { black } else { red },
    letter,
    [#upper(caps)#body],
  )
}

/// Hymn. `stanzas` is an array of arrays of lines (content). The first
/// line of the first stanza takes a versal initial; give later stanzas
/// their red letter in markup.
#let hymn(letter: none, caps: "", stanzas, amen: true) = {
  set par(first-line-indent: 0pt, hanging-indent: 1em, justify: false, spacing: leading-for(pitch))
  set text(hyphenate: false)
  for (i, stanza) in stanzas.enumerate() {
    block(
      above: if i == 0 { 3pt } else { 5pt },
      below: 0pt,
      {
        if i == 0 and letter != none {
          // Two-line red versal: its cap height spans from the cap height of
          // line 1 to the baseline of line 2. Lines 1–2 are indented past it.
          context {
            let cap-h = measure(text(
              font: "Plantin",
              size: 10pt,
              top-edge: "cap-height",
              bottom-edge: "baseline",
              "H",
            )).height
            let s = (pitch + cap-h / 10pt * sizes.body) / (cap-h / 10pt)
            let cap = text(font: "Plantin", size: s, fill: red, top-edge: "cap-height", bottom-edge: "baseline", letter)
            let w = measure(cap).width + 1.5pt
            let dy = top-edge.to-absolute() - cap-h / 10pt * sizes.body
            place(left + top, dy: dy, cap)
            for (j, l) in stanza.enumerate() {
              let l = if j == 0 [#upper(caps)#l] else { l }
              if j < 2 { par(first-line-indent: (amount: w, all: true), hanging-indent: w + 1em, l) } else { par(l) }
            }
          }
        } else {
          stanza.map(l => par(l)).join()
        }
      },
    )
  }
  if amen { block(width: 100%, above: leading-for(pitch), below: par-gap + 4pt, align(right)[#r[A]men.#h(0.5em)]) }
}

/// Red rule across the column (closing the office).
#let red-rule = block(above: 6pt, below: 6pt, line(length: 100%, stroke: 0.5pt + red))

// =====================================================================
//  Page furniture
// =====================================================================

#let page-label(n) = str(n) + "*"

#let crop-marks = {
  let s = 0.4pt + black
  let gap = 8.6pt
  for x in (trim.x0, trim.x1) {
    place(dx: x, dy: 0pt, line(angle: 90deg, length: trim.y0 - gap, stroke: s))
    place(dx: x, dy: trim.y1 + gap, line(angle: 90deg, length: sheet.height - trim.y1 - gap, stroke: s))
  }
  for y in (trim.y0, trim.y1) {
    place(dx: 0pt, dy: y, line(length: trim.x0 - gap, stroke: s))
    place(dx: trim.x1 + gap, dy: y, line(length: sheet.width - trim.x1 - gap, stroke: s))
  }
}

/// Left edge and width of the text block on page `n`.
#let block-x(n) = if calc.even(n) { margin.outside } else { margin.inside }
#let block-width = sheet.width - margin.inside - margin.outside

#let running-head = context {
  let n = counter(page).get().first()
  if n == 1 { return }
  let x = block-x(n)
  let num = text(fill: red, page-label(n))
  let title = if calc.even(n) [Die 12 Decembris] else [Beatæ Mariæ Virginis de Guadalupe]
  place(dx: x, dy: head-baseline - 0.7 * sizes.head, block(width: block-width, text(
    size: sizes.head,
    top-edge: 0.7em,
    bottom-edge: "baseline",
    grid(
      columns: (2.4em, 1fr, 2.4em),
      align: (left, center, right),
      if calc.even(n) { num }, text(fill: red, title), if not calc.even(n) { num },
    ),
  )))
  place(dx: x, dy: head-rule, line(length: block-width, stroke: 0.5pt))
}

#let col-start = <column-rule-start>
#let col-end = <column-rule-end>

#let column-rule = context {
  let n = counter(page).get().first()
  let pg = here().page()
  let y0 = margin.top - 3pt
  let starts = query(col-start).filter(m => m.location().page() == pg)
  if starts.len() > 0 { y0 = starts.first().location().position().y }
  let y1 = sheet.height - margin.bottom + 1pt
  let ends = query(col-end).filter(m => m.location().page() == pg)
  let x = block-x(n) + block-width / 2
  // The rule stops early only if the office ends in the left column;
  // otherwise the full left column stands beside it.
  if ends.len() > 0 and ends.first().location().position().x < x {
    y1 = ends.first().location().position().y
  }
  place(dx: x, dy: y0, line(angle: 90deg, length: y1 - y0, stroke: 0.6pt + red))
}

// =====================================================================
//  Document setup
// =====================================================================

#set document(title: "B. Mariæ Virg. de Guadalupe — Die 12 Decembris")
#set page(
  width: sheet.width,
  height: sheet.height,
  margin: margin,
  columns: 2,
  background: crop-marks + running-head + column-rule,
)
#set columns(gutter: gutter)
#set text(
  font: fonts.body,
  size: sizes.body,
  lang: "la",
  hyphenate: true,
  top-edge: top-edge,
  bottom-edge: bottom-edge,
  costs: (widow: 0%, orphan: 0%, hyphenation: 50%),
)
#set par(
  justify: true,
  leading: leading-for(pitch),
  spacing: leading-for(pitch) + par-gap,
  first-line-indent: (amount: indent, all: true),
  linebreaks: "optimized",
)
#set block(spacing: leading-for(pitch) + par-gap)
// Old-style figures, as in the Assumption. Text set with
// `number-type: "lining"` keeps Plantin's own figures.
#show regex("[0-9]"): it => context if text.number-type == "lining" { it } else {
  text(font: fonts.figures, number-type: "old-style", size: 1.06em, it)
}

// =====================================================================
//  Title block (page 1)
// =====================================================================

#place(top + center, scope: "parent", float: true, clearance: 0pt, {
  set align(center)
  set par(justify: false, first-line-indent: 0pt)
  set text(top-edge: "cap-height", bottom-edge: "baseline")
  block(above: 0pt, below: 0pt, pad(top: -13.4pt, {
    if woodcut-image != none {
      image(woodcut-image, width: 242pt)
    } else {
      rect(width: 242pt, height: 100pt, stroke: 0.5pt, align(center + horizon, text(
        size: 8pt,
        fill: luma(120),
      )[woodcut\ 20251031\_131444495]))
    }
  }))
  v(23pt)
  text(size: sizes.day, tracking: 0em, number-type: "lining")[DIE 12 DECEMBRIS]
  v(0pt)
  let r = body => text(fill: red, body)
  text(font: fonts.blackletter, size: sizes.feast)[#r[B.] #r[M]ariæ #r[V]irg. de #r[G]uadalupe]
  v(7.4pt)
  text(size: sizes.rank, weight: 400, fill: red, tracking: 0em)[DUPLEX MAJUS I CLASSIS]
  v(15.5pt)
  [#metadata(none)#col-start]
})

// =====================================================================
//  The office
// =====================================================================


#rubric[Omnia de Communi Festorum B. Mariæ Virginis \[161\], præter ea quæ hic habentur propria.]

#hour[In I Vesperis]

#rubric[Antiphonæ de Laudibus, Psalmi ut in I Vesperis de Communi \[161\]; Capitulum, Responsorium et Hymnus item de Communi.]

#V Non fecit táliter omni natióni. #R Et judícia sua non manifestávit eis, allelúja.

#r[Ad Magnif. Ant.] Elégi et sanctificávi #star locum istum, ut sit ibi nomen meum, et permáneant óculi mei et cor meum ibi cunctis diébus.

#title[Oratio]
#initial(
  "D",
  "e",
)[us, qui sub beatíssimæ Vírginis Maríæ singulári patrocínio constitútos perpétuis benefíciis nos cumulári voluísti~: præsta supplícibus tuis; ut, cujus hódie commemoratióne lætámur in terris, ejus conspéctu perfruámur in cælis. Per Dóminum.]

#rubric[Fit Commemoratio Feriæ.]

#rubric[Completorium de Dominica.]

#rubric[In fine Hymnorum Completorii et Horarum dicitur:]
#hymn(amen: false, (
  ([#r[G]lória tibi, Dómine,], [Qui natus es de Vírgine,], [Cum Patre, et Sancto Spíritu,], [In sempitérna sǽcula.]),
))

#rubric[Ad Nunc dimittis Ant. #blk[Allelúja, Sancta.]]

#hour[Ad Matutinum]

#r[Invitat.] In honórem beatíssimæ Maríæ Vírginis #rstar Jubilémus Dómino. #r[Ps. 94] Veníte, exsultémus. #r[2.]

#title[Hymnus]
#hymn(letter: "P", caps: "r", (
  ([æclára custos Vírginum,], [Intácta Mater Núminis,], [Cæléstis aulæ jánua,], [Spes nostra, cæli gáudium.]),
  ([#r[I]nter rubéta lílium,], [Colúmba formosíssima,], [Virga e radíce gérminans], [Nostro medélam vúlneri,]),
  ([#r[T]urris dracóni impérvia,], [Amíca stella náufragis,], [Tuére nos a fráudibus,], [Tuáque luce dírige.]),
  ([#r[E]rróris umbras díscute,], [Syrtes dolósas ámove,], [Fluctus tot inter, déviis], [Tutam reclúde sémitam.]),
  ([#r[G]lória tibi, Dómine,], [Qui natus es de Vírgine,], [Cum Patre, et Sancto Spíritu,], [In sempitérna sǽcula.]),
))

#nocturn[In I Nocturno]

#r[Ant.] A solis ortu #star usque ad occásum, magnum est nomen meum in géntibus.

#rubric[Psalmi de Communi \[165\].]

#r[Ant.] Ego in altíssimis #star habitávi, et thronus meus in colúmna nubis.

#r[Ant.] Invénta sum #star a non quæréntibus me; palam appárui iis, qui me non interrogábant.

#V Notum fecit Dóminus salutáre suum. #R In conspéctu géntium revelávit glóriam suam, allelúja.

#bened[Alma Virgo vírginum intercédat pro nobis ad Dóminum.]

#source[De libro Ecclesiástici]
#title-ref([Lectio j], [Cap. 24, 5-31], above: 2pt)
#initial(
  style: "woodcut",
  "E",
  "go",
)[ ex ore Altíssimi prodívi, primogénita ante omnem creatúram: ego feci in cælis ut orirétur lumen indefíciens, et sicut nébula texi omnem terram: ego in altíssimis habitávi, et thronus meus in colúmna nubis. Gyrum cæli circuívi sola, et profúndum abýssi penetrávi, in flúctibus maris ambulávi, et in omni terra steti~: et in omni pópulo, et in omni gente primátum hábui: et ómnium excelléntium et humílium corda virtúte calcávi~: et in his ómnibus réquiem quæsívi, et in hereditáte Dómini morábor. Tunc præcépit, et dixit mihi Creátor ómnium~: et qui creávit me, requiévit in tabernáculo meo, et dixit mihi~: In Jacob inhábita, et in Israël hereditáre, et in eléctis meis mitte radíces.]

#R Vidi speciósam sicut colúmbam ascendéntem désuper rivos aquárum~: cujus inæstimábilis odor erat nimis in vestiméntis ejus~: #rstar Et sicut dies verni circúmdabant eam flores rosárum, et lília convállium. #V Quæ est ista, quæ ascéndit per desértum sicut vírgula fumi ex aromátibus myrrhæ et thuris? #r[E]t sicut dies verni.

#bened[Nos cum prole pia benedícat Virgo María.]

#title[Lectio ij]
#initial(
  "A",
  "b",
)[ inítio, et ante sǽcula creáta sum, et usque ad futúrum sǽculum non désinam, et in habitatióne sancta coram ipso ministrávi. Et sic in Sion firmáta sum, et in civitáte sanctificáta simíliter requiévi, et in Jerúsalem potéstas mea. Et radicávi in pópulo honorificáto, et in parte Dei mei heréditas illíus, et in plenitúdine sanctórum deténtio mea. Quasi cedrus exaltáta sum in Líbano, et quasi cypréssus in monte Sion: quasi palma exaltáta sum in Cades, et quasi plantátio rosæ in Jéricho: quasi olíva speciósa in campis, et quasi plátanus exaltáta sum juxta aquam in platéis. Sicut cinnamómum, et bálsamum aromatízans odórem dedi~: quasi myrrha elécta dedi suavitátem odóris: et quasi storax, et gálbanus, et úngula, et gutta, et quasi Líbanus non incísus vaporávi habitatiónem meam, et quasi bálsamum non mixtum odor meus.]

#R Quæ est ista, quæ ascéndit sicut auróra consúrgens, pulchra ut luna, elécta ut sol, #rstar Terríbilis ut castrórum ácies ordináta? #V Fília Sion, tota formósa et suávis es, pulchra ut luna, elécta ut sol. #r[T]erríbilis.

#bened[Sancta Dei Génitrix sit nobis auxiliátrix.]

#title[Lectio iij]
#initial(
  "E",
  "go",
)[ quasi terebínthus exténdi ramos meos, et rami mei honóris et grátiæ. Ego quasi vitis fructificávi suavitátem odóris~: et flores mei fructus honóris et honestátis. Ego mater pulchræ dilectiónis, et timóris, et agnitiónis, et sanctæ spei. In me grátia omnis viæ et veritátis, in me omnis spes vitæ et virtútis. Transíte ad me omnes qui concupíscitis me, et a generatiónibus meis implémini: spíritus enim meus super mel dulcis, et heréditas mea super mel et favum: memória mea in generatiónes sæculórum. Qui edunt me, adhuc esúrient~: et qui bibunt me, adhuc sítient. Qui audit me, non confundétur~: et qui operántur in me, non peccábunt. Qui elúcidant me, vitam ætérnam habébunt.]

#R Quæ est ista, quæ procéssit sicut sol, et formósa tamquam Jerúsalem? #rstar Vidérunt eam fíliæ Sion, et beátam dixérunt, et regínæ laudavérunt eam. #V Et sicut dies verni circúmdabant eam flores rosárum, et lília convállium. #r[V]idérunt. Glória Patri. #r[V]idérunt.

#nocturn[In II Nocturno]

#r[Ant.] Signum magnum #star appáruit in cælo~: múlier amícta sole, et luna sub pédibus ejus.

#r[Ant.] Pópulus qui ambulábat #star in ténebris, vidit lucem magnam~: habitántibus in regióne umbræ mortis, lux orta est eis.

#r[Ant.] Vidérunt #star omnes términi terræ salutáre Dei nostri.

#V Introíbimus in tabernáculum ejus. #R Adorábimus in loco ubi stetérunt pedes ejus, allelúja.

#bened[Précibus suæ Matris benedícat nos Fílius Dei Patris.]

#title[Lectio iv]
#initial(
  style: "woodcut",
  "A",
  "n",
)[no a reparáta salúte millésimo quingentésimo trigésimo primo, Deípara Virgo Joánni Dídaco, pio rudíque neóphyto, Méxici in colle Tepejacénsi, uti antíqua et constánti traditióne mandátur, sese vidéndam prǽbuit, eúmque peramánter álloquens, epíscopum adíre, ipsíque ædem ínibi sibi sacram excitándam nuntiáre jussit. Rei veritátem solérter exploratúrus, responsiónem dístulit Joánnes de Zumárraga, loci antístes~: ac neóphyto, beatíssimæ Vírginis aspéctu imperióque rursus permóto, legationémque lácrimis et précibus iteránti, præcépit, ut signum, quo magnæ Dei Matris ostenderétur volúntas, eníxe péteret.]

#R Signum magnum appáruit in cælo, múlier amícta sole et luna sub pédibus ejus, #rstar Et in cápite ejus coróna duódecim stellárum. #V Fundaménta ejus in móntibus sanctis, díligit Dóminus portas Sion super ómnia tabernácula Jacob. #r[E]t.

#bened[Jesus Maríæ Fílius sit nobis clemens et propítius.]

#title[Lectio v]
#initial(
  "D",
  "um",
)[ viam a colle Tepejacénsi remotiórem neóphytus arríperet, et Méxicum, ne pátruo letháli morbo corrépto extréma deéssent sacraménta, sacerdótem advocatúrus conténderet, eídem benigníssima Virgo tértio occúrrit; mæréntem de pátrui sanitáte certiórem facit; rosásque pulchérrimas, contra loci hiemísque asperitátem, recens obórtas, in ejus pállio compósitas, epíscopo deférri injúngit. Mandátis obséquitur Dídacus, cujus in pállio, rosis coram epíscopo effúsis, Maríæ sanctæ imágo qua prorsus spécie in colle prope urbem sese exhibúerat, mirum in modum depícta conspícitur. Tanto percúlsi prodígio religiósam cives effígiem in episcopáli sacéllo rite asservándam curant~: quæ, paulo post, solémni pompa ad ædem in collo Tepejacénsi exstrúctam transláta, insígni géntium cunctárum veneratióne præfúlget.]

#R Quæ est ista, quæ progréditur quasi auróra consúrgens~: #rstar Pulchra ut luna, elécta ut sol? #V Quasi arcus refúlgens inter nébulas glóriæ, et quasi flos rosárum in diébus vernis. #r[P]ulchra.

#bened[Fílius Vírginis Maríæ det nobis gáudia vitæ.]

#title[Lectio vj]
#initial(
  "M",
  "a",
)[gnífico deínceps excépta templo, cui canonicórum collégium Románi Pontífices ad divíni cultus splendórem addidérunt, Mexicánæ gentis pietátem in Deíparam summópere adáuxit; ingentíque abhinc quátuor sǽculis cólitur populórum ac miraculórum frequéntia. Quaprópter eam uti præsentíssimum advérsus públicas privatásque calamitátes præsídium archiepíscopus Mexicánus ceteríque illárum regiónum antístites, ómnium órdinum consensióne, in primáriam adlegérunt univérsæ Mexicánæ natiónis patrónam, ritéque eléctam Benedíctus décimus quartus auctoritáte apostólica declarávit, atque Offícium et Missam sub título Beátæ Vírginis Guadalupénsis recitári concéssit. Leo vero décimus tértius, iterátis Mexicanórum prǽsulum petitiónibus benígne ánnuens, novíssimum hoc Offícium, ex sacrórum Rítuum Congregatiónis consúlto, recitári indúlsit, Virginísque effígiem prodígiis atque cultu célebrem áurea coróna, suo nómine et jussu, solémni ritu condecorári decrévit. Quam quidem quarto Idus Octóbris anno millésimo octingentésimo nonagésimo quinto, coram epíscopis fere ómnibus reipúblicæ et áliis bene multis ex réliquis Américæ pártibus, máxima incolárum advenarúmque frequéntia et gratulatióne archiepíscopus Mexicánus pretiosíssimam impósuit.]

#R Elégi et sanctificávi locum istum~: #rstar Ut sit ibi nomen meum, et permáneant óculi mei, et cor meum ibi cunctis diébus. #V Non fecit táliter omni natióni, et judícia sua non manifestávit eis. #r[U]t. Glória Patri. #r[U]t.

#nocturn[In III Nocturno]

#r[Ant.] Tabernáculum Dei #star María, in médio civitátis ejus, et non commovébitur.

#r[Ant.] Egréssa es #star in salútem pópuli tui, in salútem cum Christo tuo.

#r[Ant.] Gloriósa dicta sunt #star de te, cívitas Dei~: fundávit te Dóminus in móntibus sanctis.

#V Fílii tui de longe vénient. #R Et fíliæ tuæ de látere surgent, allelúja.

#bened[Fons Evangélii répleat nos dógmate cæli.]

#source[Léctio sancti Evangélii\ secúndum Lucam]
#title-ref([Lectio vij], [Cap. 1, 39-47], above: 4pt)
#initial(
  "I",
  "n",
)[ illo témpore~: Exsúrgens María ábiit in montána cum festinatióne, in civitátem Juda. Et intrávit in domum Zacharíæ, et salutávit Elísabeth. Et réliqua.]

#source(sub: [De verbis Apoc. cap. 12, ad finem])[Homilía sancti Bernárdi Abbátis]
#initial(
  style: "woodcut",
  "M",
  "i",
)[rabátur Elísabeth persónam veniéntis, dicens~: Unde hoc mihi, ut véniat Mater Dómini mei ad me? Commendábat et vocem salutántis, adjíciens~: Ut facta est vox salutatiónis tuæ in áuribus meis, exsultávit in gáudio infans in útero meo~: et beatificábat fidem credéntis~: Beáta, ínquiens, quæ credidísti. Magna quidem præcónia; sed et devóta humílitas nihil sibi passa retinére, in eum magis univérsa refúdit, cujus in se benefícia laudabántur.]

#R Felix namque es, sacra Virgo María, et omni laude digníssima~: #rstar Quia ex te ortus est sol justítiæ, Christus, Deus noster. #V Ora pro pópulo, intérveni pro clero, intercéde pro devóto femíneo sexu~: séntiant omnes tuum juvámen, quicúmque célebrant tuam sanctam festivitátem. #r[Q]uia.

#bened[Ab hoste malígno deféndat nos Dei Génitrix Virgo.]

#title[Lectio viij]
#initial(
  "T",
  "u",
)[, inquit, magníficas Matrem Dómini, sed magníficat ánima mea Dóminum. In voce mea fílium pérhibes exsultásse in gáudio, sed exsultávit spíritus meus in Deo, salutári meo~: et ipse quoque tamquam amícus sponsi gaudet ad vocem sponsi. Beátam me esse dicis, quæ crédidi; sed credulitátis et beatitúdinis causa respéctus est supérnæ pietátis; ut ex hoc magis beátam me dicant omnes generatiónes, quia ancíllam húmilem et exíguam respéxit Deus. Verúmtamen numquid putámus, fratres, Elísabeth sanctam in eo, quod per Spíritum útique loquebátur errásse? Absit. Beáta plane quam respéxit Deus, et beáta quæ crédidit. Hic enim magnus divínæ respectiónis éxstitit fructus.]

#R Beátam me dicent omnes generatiónes~: #rstar Quia fecit mihi Dóminus magna qui potens est, et sanctum nomen ejus. #V Et misericórdia ejus a progénie in progénies timéntibus eum. #r[Q]uia.

#bened[In omni tribulatióne et angústia succúrrat nobis pia Virgo María.]

#rubric[Si dicenda sit ix Lectio de Homilia Dominicæ, erit:]

#bened[Verba Redemptóris pia sint suffrágia nobis.]

#title[Lectio ix]
#initial(
  "I",
  "n",
)[effábili síquidem artifício Spíritus supervéniens tantæ humilitáti, magnanímitas tanta in secretário virgínei cordis accéssit, ut quod vidélicet nec humílitas tanta minúerit magnanimitátem, nec magnanímitas tanta humilitátem. Sed cum in sua æstimatióne tam húmilis esset, nihilóminus et in promissiónis credulitáte magnánimis, ut quæ nihil áliud quam exíguam sese reputábat ancíllam, ad inscrutábile sacraméntum nullátenus se dubitáret eléctam, et veram Dei et hóminis Genitrícem créderet mox futúram. Jam te, Mater misericórdiæ, per ipsum sinceríssimæ tuæ mentis afféctum tuis jacens provolúta pédibus luna, mediatrícem sibi apud solem justítiæ constitútam, devótis supplicatiónibus interpéllat, ut in lúmine tuo vídeat lumen, et solis grátiam tuo mereátur obténtu, quam vere amávit præ ómnibus, et ornávit stola glóriæ índuens, et corónam pulchritúdinis ponens in cápite tuo.]

#R Christi Virgo dilectíssima, virtútum operátrix, opem fer míseris~: #rstar Súbveni, Dómina, clamántibus ad te júgiter. #V Quóniam peccatórum mole prémimur, et non est qui ádjuvet. #r[S]úbveni. Glória Patri. #r[S]úbveni.

Te Deum laudámus. #r[6.]

#r[Sacerd.] #V Ora pro nobis, sancta Dei Génitrix. #R Ut digni efficiámur promissiónibus Christi, allelúja.

#hour(sub: [et per Horas])[Ad Laudes]

#r[Ant. 1] Quæ est ista #star quæ procéssit sicut sol, et formósa tamquam Jerúsalem.

#rubric[Psalmi de Dominica #sc[i] loco.]

#r[2] Vidérunt eam #star fíliæ Sion vernántem in flóribus rosárum, et beatíssimam prædicavérunt.

#r[3] Flores apparuérunt #star in terra nostra~: te laudámus, sancta Dei Génitrix.

#r[4] Cantáte ei #star cánticum novum~: annuntiáte inter gentes glóriam ejus.

#r[5] Tu glória #star Jerúsalem, tu lætítia Israel, tu honorificéntia pópuli tui.

#title-ref([Capitulum], [Eccli. 24, 23-24])
#initial(
  "E",
  "go",
)[ quasi vitis fructificávi suavitátem odóris~: et flores mei fructus honóris et honestátis. Ego mater pulchræ dilectiónis, et timóris, et agnitiónis, et sanctæ spei.]

#title[Hymnus]
#hymn(letter: "A", caps: "l", (
  ([ma Parens, omni carens], [Corruptélæ mácula,], [Quam elégit qui confrégit], [Diræ mortis víncula.]),
  ([#r[C]lemens, præsta, ut qui festa], [Tua gaudent cólere,], [Gratuléntur et læténtur], [Veræ lucis lúmine.]),
  ([#r[P]rimum quidem nobis fidem], [Tuis auge précibus,], [Spe labéntes firma mentes,], [Caritáte róbora.]),
  ([#r[M]ater Dei, nostræ spei], [Causa et exórdium,], [Aufer bella et flagélla,], [Famem, pestem, gládium.]),
  ([#r[E]genórum et vinctórum], [Consoláre gémitum~:], [Fave votis, dans ægrótis], [Optátum remédium.]),
  ([#r[P]ax et quies nostros dies], [Fáciant lætíssimos~:], [Inimícos fac amícos,], [Seda malos hómines.]),
  ([#r[O] María, Mater pia,], [Tuum da subsídium,], [Ut regnémus et laudémus], [Tuum semper Fílium.]),
  ([#r[P]ater Deus, Fili Deus,], [Deus alme Spíritus,], [Per ætérna nos gubérna], [Sǽcula, Deus Trínitas.]),
))

#V Omnis terra adóret te, et psallat tibi. #R Psalmum dicat nómini tuo, allelúja.

#r[Ad Bened. Ant.] Quasi arcus #star refúlgens inter nébulas glóriæ, et quasi flos rosárum in diébus vernis.

#title[Oratio]
#initial(
  "D",
  "e",
)[us, qui sub beatíssimæ Vírginis Maríæ singulári patrocínio constitútos perpétuis benefíciis nos cumulári voluísti~: præsta supplícibus tuis; ut, cujus hódie commemoratióne lætámur in terris, ejus conspéctu perfruámur in cælis. Per Dóminum.]

#rubric[Et non fit Commemoratio Octavæ.]

#rubric[Fit Commemoratio Feriæ.]

#rubric[Ad Horas Antiphonæ de Laudibus, Psalmi de Dominica, ad Primam tamen ut in Festis et in Responsorio #V #blk[Qui de Vírgine dignátus es nasci.] Reliqua ut in Communi \[177\].]

#hour[In II Vesperis]

#rubric[Antiphonæ de Laudibus, Psalmi, Capitulum et Hymnus #blk[Ave, maris stella,] de Communi \[177\].]

#V Non fecit táliter omni natióni. #R Et judícia sua non manifestávit eis, allelúja.

#r[Ad Magnif. Ant.] Leva in circúitu #star óculos tuos et vide~: omnes isti congregáti sunt, venérunt tibi~: fílii tui de longe vénient, et fíliæ tuæ de látere surgent.

#rubric[Fit Commemoratio sequentis:]

#r[Ant.] In patiéntia tua #star possedísti ánimam tuam, Lúcia, sponsa Christi~: odísti quæ in mundo sunt,#colbreak() et corúscas cum Angelis~: sánguine próprio inimícum vicísti.

#V Diffúsa est grátia in lábiis tuis. #R Proptérea benedíxit te Deus in ætérnum, allelúja.

#block(above: 4pt, below: 2pt, sticky: true, par(first-line-indent: 0pt)[Orémus. #h(1fr) #r[Oratio.]])
#initial(
  "E",
  "x",
)[áudi nos, Deus, salutáris noster~: ut, sicut de beátæ Lúciæ Vírginis et Mártyris tuæ festivitáte gaudémus; ita piæ devotiónis erudiámur afféctu. Per Christum.]

#rubric[Et fit Commemoratio Feriæ.]

#rubric[Completorium de Dominica.]

#rubric[Ad Nunc dimittis Ant. #blk[Allelúja, Sancta.]]

#v(1em)

#red-rule
#align(center, text(size: 9pt, par(justify: false, first-line-indent: 0pt, leading: leading-for(
  rubric-pitch + 1pt,
))[IMPRIMATUR.\ Tornaci, die 11 Februarii 1939.\ J. #sc[Lecouvet], Vic. Gen.]))
#red-rule
#metadata(none)#col-end

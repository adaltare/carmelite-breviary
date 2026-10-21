// Psalterium — Dominica ad Matutinum et ad Laudes (pp. 21–30)
// Text: mvp/llamaparse_ocr.md, proofread against mvp/raw/page_*.jpg.

#import "templates/1938.typ": *

#show: setup.with(first-page: 21)

#part-title(
  emblem: image("assets/emblem.png", width: 95%),
  title: [Psalterium],
  subtitle: [Breviarii Ordinis Fratrum],
  order: [B. V. Mariae de Monte Carmelo],
  description: [Per omnes ac singulos hebdomadæ dies \ dispositum],
  day-title: [Dominica],
)

// ===================================================================
//  Ad Matutinum
// ===================================================================

#hour[Ad Matutinum]

#pater-ave(credo: true)
#v-line[Dómine, lábia mea.]
#v-line[Deus, in adjutórium.]
#line-of[Glória Patri. Sicut erat. Allelúja.]

#invitatory(season: [Ante Domin. I Novembris :])[
  Laudémus Dóminum Jesum Christum : \* Quia ipse est Redémptor ómnium
  sæculórum. #psalm-ref(94, [Veníte, exsultémus], 2)
]

#invitatory(season: [In Dominicis Novembris :])[
  Dóminum, qui fecit nos : \* Veníte, adorémus: #psalm-ref(94, [Veníte, exsultémus], 2)
]

#hymn("
NOcte surgéntes vigilémus omnes,
Semper in psalmis meditémur, atque
Víribus totis Dómino canámus
Dúlciter hymnos.

Ut pio Regi páriter canéntes,
Cum suis Sanctis mereámur aulam
Ingredi cæli, simul et beátam
Dúcere vitam.

Præstet hoc nobis Déitas beáta
Patris, ac Nati, paritérque Sancti
Spíritus, cujus réboat in omni
Glória mundo.
")

// ----- In I Nocturno -----------------------------------------------

#nocturn(1, head: [Dominica ad Matutinum, in I Nocturno])
#antiphon[Pro fídei méritis.]

#rubric[
  Antiphonæ cum Psalmis et Versibus assignatæ adhibentur semper, quando
  fit Officium semiduplex de Dominica.
]

#rubric(mark: "¶")[
  Asteriscus \*, in Psalmorum versibus et in aliis Officii partibus
  insertus, denotat pausam cantus et recitationis in Choro; præter quam in
  Antiphonis, in quibus nempe significat tum præintonationem Antiphonæ, tum
  Antiphonam ipsam ante Psalmum seu Canticum eousque producendam esse ad
  omnes Horas in Officio ritus duplicis minoris, semiduplicis ac simplicis,
  atque ad Horas tantum minores in omni Officio.
]

#psalm([Psalmus 1], initial: "woodcut")[
  BEátus vir, qui non ábiit in consílio impiórum, et in via peccatórum non
  stetit, \* et in cáthedra pestiléntiæ non sedit :

  Sed in lege Dómini volúntas ejus, \* et in lege ejus meditábitur die ac nocte.

  Et erit tamquam lignum, quod plantátum est secus decúrsus aquárum, \* quod
  fructum suum dabit in témpore suo :

  Et fólium ejus non défluet : \* et ómnia quæcúmque fáciet, prosperabúntur.

  Non sic ímpii, non sic : \* sed tamquam pulvis, quem prójicit ventus a fácie terræ.

  Ideo non resúrgent ímpii in judício : \* neque peccatóres in concílio justórum.

  Quóniam novit Dóminus viam justórum : \* et iter impiórum períbit.

  Glória Patri, et Fílio, \* et Spirítui Sancto.

  Sicut erat in princípio, et nunc, et semper, \* et in sǽcula sæculórum. Amen.
]

#rubric(mark: "¶")[
  Hic Versus #blk[Glória Patri] semper dicitur in fine omnium Psalmorum et
  Canticorum nisi aliter notetur.
]

#antiphon[Pro fídei méritis vocitátur jure beátus, legem qui Dómini meditátur nocte, diéque.]
#antiphon[Juste Deus.]

#psalm([Psalmus 2])[
  QUare fremuérunt gentes, \* et pópuli meditáti sunt inánia?

  Astitérunt reges terræ, et príncipes convenérunt in unum \* advérsus
  Dóminum, et advérsus Christum ejus.

  Dirumpámus víncula eórum : \* et projiciámus a nobis jugum ipsórum.

  Qui hábitat in cælis, irridébit eos : \* et Dóminus subsannábit eos.

  Tunc loquétur ad eos in ira sua, \* et in furóre suo conturbábit eos.

  Ego autem constitútus sum Rex ab eo super Sion montem sanctum ejus, \*
  prǽdicans præcéptum ejus.

  Dóminus dixit ad me : \* Fílius meus es tu, ego hódie génui te.

  Póstula a me, et dabo tibi gentes hereditátem tuam, \* et possessiónem
  tuam términos terræ.

  Reges eos in virga férrea, \* et tamquam vas fíguli confrínges eos.

  Et nunc, reges, intellígite : \* erudímini, qui judicátis terram.

  Servíte Dómino in timóre : \* et exsultáte ei cum tremóre.

  Apprehéndite disciplínam, nequándo irascátur Dóminus, \* et pereátis de via justa.

  Cum exárserit in brevi ira ejus, \* beáti omnes qui confídunt in eo.
]

#antiphon[Juste Deus, judex fortis, patiénsque, benígnus : in te sperántes muni miserándo fidéles.]
#antiphon[Surge.]

#psalm([Psalmus 3])[
  DOmine, quid multiplicáti sunt qui tríbulant me? \* multi insúrgunt advérsum me.

  Multi dicunt ánimæ meæ : \* Non est salus ipsi in Deo ejus.

  Tu autem, Dómine, suscéptor meus es, \* glória mea, et exáltans caput meum.

  Voce mea ad Dóminum clamávi : \* et exaudívit me de monte sancto suo.

  Ego dormívi, et soporátus sum : \* et exsurréxi, quia Dóminus suscépit me.

  Non timébo míllia pópuli circumdántis me : \* exsúrge, Dómine, salvum me
  fac, Deus meus.

  Quóniam tu percussísti omnes adversántes mihi sine causa : \* dentes
  peccatórum contrivísti.

  Dómini est salus : \* et super pópulum tuum benedíctio tua.
]

#antiphon[Surge, et in ætérnum serva munímine sacro, custodíque tuos, Astrípotens, fámulos.]
#versicle[Memor fui nocte nóminis tui, Dómine.][Et custodívi legem tuam.]

// ----- In II Nocturno ----------------------------------------------

#nocturn(2, head: [Dominica ad Matutinum, in II Nocturno])
#antiphon[Natúræ Génitor.]

#psalm([Psalmus 8], initial: "woodcut")[
  DOmine, Dóminus noster, \* quam admirábile est nomen tuum in univérsa terra!

  Quóniam eleváta est magnificéntia tua, \* super cælos.

  Ex ore infántium et lacténtium perfecísti laudem propter inimícos tuos, \*
  ut déstruas inimícum et ultórem.

  Quóniam vidébo cælos tuos, ópera digitórum tuórum : \* lunam et stellas,
  quæ tu fundásti.

  Quid est homo, quod memor es ejus? \* aut fílius hóminis, quóniam vísitas eum?

  Minuísti eum paulo minus ab Angelis, glória et honóre coronásti eum : \* et
  constituísti eum super ópera mánuum tuárum.

  Omnia subjecísti sub pédibus ejus, \* oves et boves univérsas : ínsuper et
  pécora campi.

  Vólucres cæli, et pisces maris, \* qui perámbulant sémitas maris.

  Dómine, Dóminus noster, \* quam admirábile est nomen tuum in univérsa terra!
]

#antiphon[Natúræ Génitor, consérva a morte redémptos, facque tuo dignos servítio fámulos.]
#antiphon[Péctora nostra.]

#psalm([Psalmus 9, j])[
  COnfitébor tibi, Dómine, in toto corde meo : \* narrábo ómnia mirabília tua.

  Lætábor et exsultábo in te : \* psallam nómini tuo, Altíssime,

  In converténdo inimícum meum retrórsum : \* infirmabúntur, et períbunt a fácie tua.

  Quóniam fecísti judícium meum et causam meam : \* sedísti super thronum,
  qui júdicas justítiam.

  Increpásti gentes, et périit ímpius : \* nomen eórum delésti in ætérnum,
  et in sǽculum sǽculi.

  Inimíci defecérunt frámeæ in finem : \* et civitátes eórum destruxísti.

  Périit memória eórum cum sónitu : \* et Dóminus in ætérnum pérmanet.

  Parávit in judício thronum suum : \* et ipse judicábit orbem terræ in
  æquitáte, judicábit pópulos in justítia.

  Et factus est Dóminus refúgium páuperi : \* adjútor in opportunitátibus,
  in tribulatióne.

  Et sperent in te qui novérunt nomen tuum : \* quóniam non dereliquísti
  quæréntes te, Dómine.
]

#antiphon[Péctora nostra tibi tu, Cónditor orbis, adúre, igne pio purgans, atque cremándo probans.]
#antiphon[Tu pópulum.]

#psalm([Psalmus 9, ij])[
  PSállite Dómino, qui hábitat in Sion : \* annuntiáte inter gentes stúdia ejus :

  Quóniam requírens sánguinem eórum recordátus est : \* non est oblítus
  clamórem páuperum.

  Miserére mei, Dómine : \* vide humilitátem meam de inimícis meis.

  Qui exáltas me de portis mortis, \* ut annúntiem omnes laudatiónes tuas in
  portis fíliæ Sion.

  Exsultábo in salutári tuo : \* infíxæ sunt gentes in intéritu, quem fecérunt.

  In láqueo isto, quem abscondérunt, \* comprehénsus est pes eórum.

  Cognoscétur Dóminus judícia fáciens : \* in opéribus mánuum suárum
  comprehénsus est peccátor.

  Convertántur peccatóres in inférnum, \* omnes gentes quæ obliviscúntur Deum.

  Quóniam non in finem oblívio erit páuperis : \* patiéntia páuperum non
  períbit in finem.

  Exsúrge, Dómine, non confortétur homo : \* judicéntur gentes in conspéctu tuo.

  Constítue, Dómine, legislatórem super eos : \* ut sciant gentes quóniam
  hómines sunt.
]

#antiphon[Tu pópulum húmilem salvásti ex hoste, Redémptor : atque supérba tuo colla premis jáculo.]
#versicle(newline: true)[Média nocte surgébam.][Ad confiténdum nómini tuo, Dómine.]

// ----- In III Nocturno ---------------------------------------------

#nocturn(3, head: [Dominica ad Matutinum, in III Nocturno])
#antiphon[Sponsus.]

#psalm([Psalmus 9, iij], initial: "woodcut")[
  UT quid, Dómine, recessísti longe, \* déspicis in opportunitátibus, in
  tribulatióne?

  Dum supérbit ímpius, incénditur pauper : \* comprehendúntur in consíliis
  quibus cógitant.

  Quóniam laudátur peccátor in desidériis ánimæ suæ : \* et iníquus benedícitur.

  Exacerbávit Dóminum peccátor, \* secúndum multitúdinem iræ suæ non quæret.

  Non est Deus in conspéctu ejus : \* inquinátæ sunt viæ illíus in omni témpore.

  Auferúntur judícia tua a fácie ejus : \* ómnium inimicórum suórum dominábitur.

  Dixit enim in corde suo : \* Non movébor a generatióne in generatiónem sine malo.

  Cujus maledictióne os plenum est, et amaritúdine, et dolo : \* sub lingua
  ejus labor et dolor.

  Sedet in insídiis cum divítibus in occúltis, \* ut interfíciat innocéntem.

  Oculi ejus in páuperem respíciunt : \* insidiátur in abscóndito, quasi leo
  in spelúnca sua.

  Insidiátur ut rápiat páuperem : \* rápere páuperem, dum áttrahit eum.

  In láqueo suo humiliábit eum : \* inclinábit se, et cadet, cum dominátus
  fúerit páuperum.

  Dixit enim in corde suo : Oblítus est Deus, \* avértit fáciem suam ne
  vídeat in finem.
]

#antiphon[Sponsus ut e thálamo, procéssit Christus in orbem : descéndens cælo jure salutífero.]
#antiphon[Auxílium nobis.]

#psalm([Psalmus 9, iv])[
  EXsúrge, Dómine Deus, exaltétur manus tua : \* ne obliviscáris páuperum.

  Propter quid irritávit ímpius Deum? \* dixit enim in corde suo : Non requíret.

  Vides quóniam tu labórem et dolórem consíderas : \* ut tradas eos in manus tuas.

  Tibi derelíctus est pauper : \* órphano tu eris adjútor.

  Cóntere bráchium peccatóris et malígni : \* quærétur peccátum illíus, et
  non inveniétur.

  Dóminus regnábit in ætérnum, et in sǽculum sǽculi : \* períbitis, gentes,
  de terra illíus.

  Desidérium páuperum exaudívit Dóminus : \* præparatiónem cordis eórum
  audívit auris tua.

  Judicáre pupíllo et húmili, \* ut non appónat ultra magnificáre se homo
  super terram.
]

#antiphon[Auxílium nobis, Salvátor, mitte salútis : et tríbuas vitam témpore perpétuo.]
#antiphon[Rex sine fine manens.]

#psalm([Psalmus 10])[
  IN Dómino confído : quómodo dícitis ánimæ meæ : \* Tránsmigra in montem
  sicut passer?

  Quóniam ecce peccatóres intendérunt arcum, paravérunt sagíttas suas in
  pháretra, \* ut sagíttent in obscúro rectos corde.

  Quóniam quæ perfecísti, destruxérunt : \* justus autem quid fecit?

  Dóminus in templo sancto suo, \* Dóminus in cælo sedes ejus :

  Oculi ejus in páuperem respíciunt : \* pálpebræ ejus intérrogant fílios hóminum.

  Dóminus intérrogat justum et ímpium : \* qui autem díligit iniquitátem,
  odit ánimam suam.

  Pluet super peccatóres láqueos : \* ignis, et sulphur, et spíritus
  procellárum pars cálicis eórum.

  Quóniam justus Dóminus, et justítias diléxit : \* æquitátem vidit vultus ejus.
]

#antiphon[Rex sine fine manens, míseris tu parce ruínis : prǽmia concédens, et tua cuncta regens.]
#versicle[Exaltáre, Dómine, in virtúte tua.][Cantábimus, et psallémus virtútes tuas.]
#versicle(prefix: "Sacerd.")[Excélsus super omnes gentes Dóminus.][Et super cælos glória ejus.]

#double-rule()

// ===================================================================
//  Ad Laudes
// ===================================================================

#hour(head: [Dominica ad Laudes])[Ad Laudes]

#pater-ave(silent: true)
#v-line[Deus, in adjutórium.]
#antiphon[Allelúja.]

#rubric(mark: "¶")[
  Antiphonæ cum Psalmis assignatæ adhibentur semper, quando fit Officium
  semiduplex de Dominica.
]

#psalm([Psalmus 92], initial: "woodcut")[
  DOminus regnávit, decórem indútus est : \* indútus est Dóminus
  fortitúdinem, et præcínxit se.

  Etenim firmávit orbem terræ, \* qui non commovébitur.

  Paráta sedes tua ex tunc : \* a sǽculo tu es.

  Elevavérunt flúmina, Dómine : \* elevavérunt flúmina vocem suam.

  Elevavérunt flúmina fluctus suos, \* a vócibus aquárum multárum.

  Mirábiles elatiónes maris : \* mirábilis in altis Dóminus.

  Testimónia tua credibília facta sunt nimis : \* domum tuam decet
  sanctitúdo, Dómine, in longitúdinem diérum.
]

#antiphon[Allelúja, Dóminus regnávit, decórem índuit, allelúja, allelúja.]
#antiphon[Jubiláte. †]

#rubric(mark: "¶")[
  Et non repetitur in Psalmo; quod semper fit, quando Antiphona incipit a
  primis Psalmi vel Cantici verbis.
]

#psalm([Psalmus 99])[
  JUbiláte † Deo, omnis terra : \* servíte Dómino in lætítia.

  Introíte in conspéctu ejus, \* in exsultatióne.

  Scitóte quóniam Dóminus ipse est Deus : \* ipse fecit nos, et non ipsi nos.

  Pópulus ejus, et oves páscuæ ejus : \* introíte portas ejus in
  confessióne, átria ejus in hymnis : confitémini illi.

  Laudáte nomen ejus : quóniam suávis est Dóminus, in ætérnum misericórdia
  ejus, \* et usque in generatiónem et generatiónem véritas ejus.
]

#antiphon[Jubiláte Deo, omnis terra, allelúja.]
#antiphon[Benedícam te.]

#psalm([Psalmus 62])[
  DEus, Deus meus, \* ad te de luce vígilo.

  Sitívit in te ánima mea, \* quam multiplíciter tibi caro mea.

  In terra desérta, et ínvia, et inaquósa : \* sic in sancto appárui tibi,
  ut vidérem virtútem tuam, et glóriam tuam.

  Quóniam mélior est misericórdia tua super vitas : \* lábia mea laudábunt te.

  Sic benedícam te in vita mea : \* et in nómine tuo levábo manus meas.

  Sicut ádipe et pinguédine repleátur ánima mea : \* et lábiis exsultatiónis
  laudábit os meum.

  Si memor fui tui super stratum meum, in matutínis meditábor in te : \*
  quia fuísti adjútor meus.

  Et in velaménto alárum tuárum exsultábo, adhǽsit ánima mea post te : \*
  me suscépit déxtera tua.

  Ipsi vero in vanum quæsiérunt ánimam meam, introíbunt in inferióra terræ :
  \* tradéntur in manus gládii, partes vúlpium erunt.

  Rex vero lætábitur in Deo, laudabúntur omnes qui jurant in eo : \* quia
  obstrúctum est os loquéntium iníqua.
]

#antiphon[Benedícam te in vita mea, Dómine : et in nómine tuo levábo manus meas, allelúja.]
#antiphon[Tres púeri.]

#canticle([Canticum trium Puerorum], [Dan. 3, 57-88 et 56])[
  BEnedícite, ómnia ópera Dómini, Dómino : \* laudáte et superexaltáte eum in sǽcula.

  Benedícite, Angeli Dómini, Dómino : \* benedícite, cæli, Dómino.

  Benedícite, aquæ omnes, quæ super cælos sunt, Dómino : \* benedícite,
  omnes virtútes Dómini, Dómino.

  Benedícite, sol et luna, Dómino : \* benedícite, stellæ cæli, Dómino.

  Benedícite, omnis imber et ros, Dómino : \* benedícite, omnes spíritus Dei, Dómino.

  Benedícite, ignis et æstus, Dómino : \* benedícite, frigus et æstus, Dómino.

  Benedícite, rores et pruína, Dómino : \* benedícite, gelu et frigus, Dómino.

  Benedícite, glácies et nives, Dómino : \* benedícite, noctes et dies, Dómino.

  Benedícite, lux et ténebræ, Dómino : \* benedícite, fúlgura et nubes, Dómino.

  Benedícat terra Dóminum : \* laudet et superexáltet eum in sǽcula.

  Benedícite, montes et colles, Dómino : \* benedícite, univérsa
  germinántia in terra, Dómino.

  Benedícite, fontes, Dómino : \* benedícite, mária et flúmina, Dómino.

  Benedícite, cete, et ómnia, quæ movéntur in aquis, Dómino : \* benedícite,
  omnes vólucres cæli, Dómino.

  Benedícite, omnes béstiæ et pécora, Dómino : \* benedícite, fílii hóminum, Dómino.

  Benedícat Israel Dóminum : \* laudet et superexáltet eum in sǽcula.

  Benedícite, sacerdótes Dómini, Dómino : \* benedícite, servi Dómini, Dómino.

  Benedícite, spíritus, et ánimæ justórum, Dómino : \* benedícite, sancti,
  et húmiles corde, Dómino.

  Benedícite, Ananía, Azaría, Mísael, Dómino : \* laudáte et superexaltáte
  eum in sǽcula.

  Benedicámus Patrem et Fílium cum Sancto Spíritu : \* laudémus et
  superexaltémus eum in sǽcula.

  Benedíctus es, Dómine, in firmaménto cæli : \* et laudábilis, et
  gloriósus, et superexaltátus in sǽcula.
]

#rubric(mark: "¶")[Hic non dicitur #blk[Glória Patri,] neque #blk[Amen.]]

#antiphon[Tres púeri jussu regis in fornácem missi sunt, non timéntes flammam ignis, dicéntes : Benedíctus Deus, allelúja.]
#antiphon[Allelúja.]

#psalm([Psalmus 148])[
  LAudáte Dóminum de cælis : \* laudáte eum in excélsis.

  Laudáte eum, omnes Angeli ejus : \* laudáte eum, omnes virtútes ejus.

  Laudáte eum, sol et luna : \* laudáte eum, omnes stellæ et lumen.

  Laudáte eum, cæli cælórum : \* et aquæ omnes, quæ super cælos sunt,
  laudent nomen Dómini.

  Quia ipse dixit, et facta sunt : \* ipse mandávit, et creáta sunt.

  Státuit ea in ætérnum, et in sǽculum sǽculi : \* præcéptum pósuit, et non
  præteríbit.

  Laudáte Dóminum de terra, \* dracónes, et omnes abýssi.

  Ignis, grando, nix, glácies, spíritus procellárum : \* quæ fáciunt verbum ejus :

  Montes, et omnes colles : \* ligna fructífera, et omnes cedri.

  Béstiæ, et univérsa pécora : \* serpéntes, et vólucres pennátæ :

  Reges terræ, et omnes pópuli : \* príncipes, et omnes júdices terræ.

  Júvenes, et vírgines : senes cum junióribus laudent nomen Dómini : \* quia
  exaltátum est nomen ejus solíus.

  Conféssio ejus super cælum et terram : \* et exaltávit cornu pópuli sui.

  Hymnus ómnibus sanctis ejus : \* fíliis Israel, pópulo appropinquánti sibi.
]

#antiphon[Allelúja, laudáte Dóminum de cælis, allelúja, allelúja.]

#capitulum([Apoc. 7, 12])[
  BEnedíctio, et cláritas, et sapiéntia, et gratiárum áctio, honor, et
  virtus, et fortitúdo Deo nostro in sǽcula sæculórum. Amen.
]
#r-line[Deo grátias.]

#hymn("
ECce, jam noctis tenuátur umbra,
Lucis auróra rútilans corúscat :
Nísibus totis rogitémus omnes
Cunctipoténtem.

Ut Deus nostri miserátus, omnem
Pellat languórem, tríbuat salútem,
Donet et nobis, pietáte Patris,
Regna polórum.

Præstet hoc nobis Déitas beáta
Patris, ac Nati, paritérque Sancti
Spíritus, cujus réboat in omni
Glória mundo.
")

#versicle(newline: true)[Dóminus regnávit.][Decórem índuit.]

#rubric(size: sizes.rubric + 0.4pt)[Antiphona ad Benedictus et Oratio ut in Proprio de Tempore.]
#rubric(size: sizes.rubric + 0.4pt)[Reliqua ut in Ordinario II.]

#rubric(mark: "¶")[
  Psalmi cum Cantico de Dominica superius appositi dicuntur etiam, sub
  Antiphonis Officio diei congruentibus, in Duplicibus majoribus I vel II
  classis, in Festis novem Lectionum Domini, B. Mariæ Virginis, Angelorum,
  S. Joannis Baptistæ, S. Joseph, Apostolorum, Evangelistarum, per Octavas
  privilegiatas et in earum Dominicis, itemque in
]
#end-columns()

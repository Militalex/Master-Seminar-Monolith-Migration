// --- Template Functions:

// --- Imports:
#import "@preview/taskize:0.2.5": tasks
#import "@preview/simple-plot:0.9.1": data, plot

// --- Custom Befehle:

// Farben
#let blue = rgb("#698CF1")
#let green = rgb("#00AE04")
#let red = rgb("#FF0000")
#let darkRed = rgb("#A30000")
#let yellow = rgb("#FEC800")
#let orange = rgb("#FF7D2E")
#let magenta = rgb("#FF00FF")
#let lightBlue = rgb("#00CDFF")
#let lightGreen = rgb("#8DD100")
#let darkBlue = rgb("#0007A3")
#let purple = rgb("#9700FF")
#let pink =  rgb("#ff6581")

#let backColor = rgb("#ccf0fd42")
#let borderColor = luma(0)
#let gridColor = rgb("#afd0fc")

// Strokes
#let border = 0.5pt + borderColor
#let gridLines = 1pt + gridColor
#let minorGridLines = 0.2pt + gridColor

// Markieren
#let mark(color: magenta, ..args) = {
  let argArr = args.pos()
  let n = argArr.len()
  if (n == 2){
    color = argArr.remove(0)
  }
  let body = argArr.join()
  text(fill: color)[*#body*]
}
#let markColor(color, ..body) = mark(color, body)

// Format
#let headingFunc(numbering: false, pBreak: true, body) = [
  #if (pBreak) {
    pagebreak()
  }
  #if (numbering == false) {
    set heading(numbering: none)
    [= #body]
  } else {
    [= #body]
  }
]

#let blockQuote(textColor: black, marks: "\"", italic: true, dist: 0.5em,quote) = align(center)[
  #v(dist)
  #if italic {
    [#mark(textColor)[_#marks#quote#marks _]]
  } else {
    mark(textColor)[#marks#quote#marks]
  }
  #v(dist)
]

//Boxen
#let stBox(width: auto, height: auto, fill: rgb("#ffffff00"), inset: 0em, alignment: left, body) = block(
  width: width,
  height: height,
  fill: fill,
  radius: 4pt,
  inset: inset,
  stroke: border,
)[#align(alignment)[#body]]

#let centering(body) = align(center)[#body]

#let imgBox(inset: 0.25em, body) = stBox(inset: inset)[#body]

// Antwort Umgebungen
#let karos(height, task: "", alignment: left, inset: 0.5em, ..body) = {
  let muster = tiling(size: (5mm, 5mm))[
    #place(rect(width: 5mm, height: 5mm, stroke: gridLines))
  ]
  block(width: 100%, height: height)[#{
      // Task Rendering
      if (task != "") {
        place[
          #if (task != "") {
            grid(
              columns: task.clusters().len(),
              gutter: 0pt,
              ..task
                .clusters()
                .map(c => {
                  if (c == "*") {
                    c = "⋅"
                  }
                  if (c == "," or c == ".") {
                    block(width: 0mm, height: 5mm, align(center + horizon, c))
                  }else {
                    block(width: 5mm, height: 5mm, align(center + horizon, c))
                  }
                })
            )
          }
        ]
      }
      // Body Rendering
      stBox(width: 100%, height: height, fill: muster)[
        #if (body.pos().len() > 0) {
          block(width: 100%, height: height, inset: inset)[
            #align(alignment)[
              #for b in body.pos() { b }
            ]
          ]
        }
      ]
    }
  ]
}

#let karopage(headerAndFooter: false, margin: 1cm, amount: 1, ..body) = {
  pagebreak()
  set page(
    ..(
      if (not headerAndFooter){
        (
          margin: margin,
          header: none,
          footer: none
        )
      } else {
        (
          margin: (
            left: margin,
            right: margin
          )
        )
      }
    ),
  )
  for i in range(0, amount){
    karos(1fr, ..body)
    if (i < amount - 1){
      pagebreak()
    }
  }
  context {
    let current = counter(page).get().first()
    let total = counter(page).final().first()
    // Nur einen Pagebreak ausführen, wenn wir NICHT auf der letzten Seite sind
    if current < total {
      pagebreak()
    }
  }
}

#let nebenrechnung(height, ..body) = karos(height)[
  #underline[Platz für Nebenrechnungen:]\
  #if (body.pos().len() > 0) {
    for b in body.pos() { b }
  }
]

#let lines(height, height-snapping: true, alignment: left, ..body) = {
  set enum(spacing: 4.5mm)
  if height-snapping and height != auto {
    height = height / 10 * 7
  }
  let muster = tiling(size: (5mm, 7mm))[
    #place(line(stroke: gridColor + 1.75pt))
  ]
  stBox(width: 100%, height: height, fill: muster)[
    // Body Rendering
    #if (body.pos().len() > 0) {
      block(width: 100%, height: height, inset: 4mm)[
        #align(alignment)[
          #set par(leading: 4.5mm)
          #for b in body.pos() { b }
        ]
      ]
    }
  ]
}

#let checkBox(checked: false, symbol: "✓", size: 9pt, body) = {
  let cBox = if checked {
    rect(width: size, height: size, stroke: 0.75pt)[
        #grid(
          columns: (1fr, auto, 1fr),
          align: center + horizon,
          [#v(1fr)],[#text(size: size * 0.9)[*#symbol*]],[#v(1fr)]
        )
      ]
    }
    else {
      rect(width: size, height: size, stroke: 0.75pt)
    }
  [
    #grid(
      columns: (auto, auto),
      align: (center + top, left),
      gutter: 0.5em,
      [#cBox], [#body],
    )
  ]
}

#let contentBox(fill: backColor, alignment: left, body) = stBox(width: 100%, inset: 0.75em, fill: fill, alignment: alignment)[#body]

// Antwortlinie
#let answer(hoehe: auto, color: blue, ..body) = {
  let pos = body.pos()
  let fixed_w = none
  let body = []

  if pos.len() == 1 {
    let arg = pos.at(0)
    if type(arg) in (content, str) {
      body = arg
    } else {
      fixed_w = arg
    }
  } else if pos.len() >= 2 {
    fixed_w = pos.at(0)
    body = pos.at(1)
  } else {
    fixed_w = 3em
  }

  // Prüfen, ob die Antwort komplett leer ist
  let ist_leer = (body == [] or body == "")

  context {
    let final_w = if fixed_w == none {
      auto
    } else if type(fixed_w) == length {
      let text_w = measure(mark(color: blue, body)).width
      if text_w > fixed_w { auto } else { fixed_w }
    } else {
      fixed_w
    }

    box(
      width: final_w,
      height: hoehe,
      stroke: (bottom: 0.5pt),
      // baseline: 20% wurde entfernt, da Typst das jetzt nativ über den Text ausrichtet
      inset: (bottom: 2pt),
    )[
      #align(center)[#mark(color)[
        // Wenn leer, tricksen wir Typst mit einem versteckten "X" aus:
        #if ist_leer { hide[X] } else { body }
      ]]
    ]
  }
}

// Versteckte Antworten
#let tape_hidden = state("tape_hidden", true)

#let tape(body) = {
  let tape_farbe = rgb(0, 102, 204, 70%)
  let streifen_farbe = rgb(0, 80, 180, 50%)

  // Washi-Tape Muster definieren
  let tape_muster = tiling(size: (10pt, 10pt))[
    #place(line(start: (0%, 100%), end: (100%, 0%), stroke: 2pt + streifen_farbe))
  ]

  // Der context-Block muss JETZT schon starten, um den State abzufragen
  context {
    let ist_versteckt = tape_hidden.get()
    // Dein optimierter Code für das versteckte Tape
    let groesse = measure(hide[#body])
    let hoehe = groesse.height + 8pt

    // Berechnung der Zacken
    let zacken_groesse = 2.5pt
    let anzahl_zacken = int(hoehe / (zacken_groesse / calc.sqrt(2)))

    // Schleife für die Zacken-Reihe
    let zacken_rand = stack(
      spacing: 0pt,
      ..range(anzahl_zacken + 1).map(_ => rotate(45deg)[#square(
        size: zacken_groesse / calc.sqrt(2),
        fill: white,
        stroke: none,
      )]),
    )
    if ist_versteckt {
      box(
        fill: tape_farbe,
        inset: (x: 8pt, y: 4pt),
        radius: 1pt,
        baseline: 10%,
        stroke: 0.3pt + backColor,
      )[
        #place(dx: -8pt, dy: -4pt, rect(width: groesse.width + 16pt, height: hoehe, fill: tape_muster, stroke: none))
        #place(dx: -9pt, dy: -4pt, zacken_rand)
        #place(dx: groesse.width + 7pt, dy: -4pt, zacken_rand)
        #hide[#body]
      ]
    } else {
      // Dein Code für den aufgedeckten Zustand
      box(
        fill: rgb("#b4d8ff"),
        inset: (x: 8pt, y: 4pt),
        baseline: 10%,
      )[
        #place(dx: -9pt, dy: -4pt, zacken_rand)
        #place(dx: groesse.width + 7pt, dy: -4pt, zacken_rand)
        #body
      ]
    }
  }
}

// Koordinatensystem
#let coordinateSystem(
  minX: 0,
  maxX: 2,
  minY: 0,
  maxY: 2,
  width: 0,
  height: 0,
  scale: 1.25,
  headline: [],
  boxWidth: auto,
  boxHeight: auto,
  show-origin: true,
  show-xticks: true,
  show-yticks: true,
  xtick-lbl: (),
  ytick-lbl: (),
  graphs: (),
  color-palette: (blue, red, green, orange, purple, magenta, color.fuchsia, color.maroon),
  ..sink,
) = {
  // Calculate Width
  if (xtick-lbl.len() >= 1) {
    maxX = xtick-lbl.len() + 1
  }
  let w = maxX - minX
  if (width != 0) {
    w = width
  }

  // Calculate Height
  if (ytick-lbl.len() >= 1) {
    maxY = ytick-lbl.len() + 1
  }
  let h = maxY - minY
  if (height != 0) {
    h = height
  }

  let plot-graphs = graphs
    .enumerate()
    .map(((i, graph)) => {
      let farb-index = calc.rem(i, color-palette.len())
      let gewaehlte-farbe = color-palette.at(farb-index)

      if type(graph) == array {
        // simple-plot akzeptiert Arrays direkt als Punkt-Listen
        (data: graph, stroke: gewaehlte-farbe + 1.5pt)
      } else if type(graph) == function {
        // WENN es eine normale Funktion ist (z. B. x => x + 2)
        (fn: graph, stroke: gewaehlte-farbe + 1.5pt)
      } else {
        graph
      }
    })

  align(center)[
    #stBox(width: boxWidth, height: boxHeight, inset: 0.75em, fill: white, alignment: center)[
      #if (headline != []) {
        headline
      }
      #plot(
        width: w,
        height: h,
        scale: scale,
        xmin: minX,
        xmax: maxX,
        ymin: minY,
        ymax: maxY,
        axis-x-extend: (0, 0),
        axis-y-extend: (0, 0),
        ..(
          if (not show-xticks) {
            (
              xtick: (),
            )
          }
        ),
        ..(
          if (not show-yticks) {
            (
              ytick: (),
            )
          }
        ),
        ..(
          if (xtick-lbl.len() > 0 and show-xticks) {
            (
              xtick: range(1, xtick-lbl.len() + 1),
              xtick-labels: xtick-lbl,
            )
          }
        ),
        ..(
          if (ytick-lbl.len() > 0 and show-yticks) {
            (
              ytick: range(1, ytick-lbl.len() + 1),
              ytick-labels: ytick-lbl,
            )
          }
        ),
        show-grid: true,
        minor-grid-step: 4,
        show-origin: show-origin,
        style: (
          grid: (
            major: (stroke: gridLines),
            minor: (stroke: minorGridLines),
          ),
        ),
        ..plot-graphs,
        ..sink,
      )
    ]
  ]
}
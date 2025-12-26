
// This is an example typst template (based on the default template that ships
// with Quarto). It defines a typst function named 'article' which provides
// various customization options. This function is called from the 
// 'typst-show.typ' file (which maps Pandoc metadata function arguments)
//
// If you are creating or packaging a custom typst template you will likely
// want to replace this file and 'typst-show.typ' entirely. You can find 
// documentation on creating typst templates and some examples here: 
//   - https://typst.app/docs/tutorial/making-a-template/
//   - https://github.com/typst/templates

#let report(
  title: none,
  subtitle: none,
  cover-note: none,
  authors: none,
  date: none,
  logo: "./_extensions/qcreport/logo.png",
  registry: none,
  abstract: none,
  header: " ",
  footer: " ",
  cols: 1,
  margin: (x: 1.0in, y: 1.0in),
  paper: "a4",
  mainfont: "STsong",
  coverfont: "STsong",
  fontsize: 12pt,
  sectionnumbering: "1.1.1",
  toc: false,
  toc-figure: false,
  doc,
) = {
  set page(paper: paper, margin: margin, fill: luma(255),)
  set par(leading: 1.5em, justify: true, linebreaks: auto, first-line-indent:(amount: 2em, all: true),)
  set text(font: mainfont, size: fontsize)
  set heading(numbering: sectionnumbering)

  show heading: it => {
  set par(first-line-indent: 0em)
    v(0.7em)
    if it.numbering != none {
      counter(heading).display()
      h(0.3em)
      }
      it.body
      parbreak()
}

  align(left)[#image(logo, height: 7%)]
  v(24%)
  if title != none {
    align(center)[#block(below:0cm, height: 20%, width:100%)[
      #text(font: coverfont, weight: "bold", fill:luma(20), size: 30pt, tracking: 0.01em)[#title#parbreak()]
      #text(font: coverfont, weight: "bold", fill:luma(40), size: 18pt, tracking: 0.01em)[#subtitle]
    ]]
  }
  
  stack(dir:ttb, spacing: 1%,
  if registry != none {
    block(above:5%, height:5%, width:100%)[
    #place(bottom+center)[#text(weight: "bold", font: coverfont,
                                fill:luma(60),
                                size: 1.4em,
                                tracking: 0.02em
                                )[#registry]]]
  },
    if registry == none{
      v(5%)
    }
  )
  
block(height: 25%, above:0cm, width: 100%)[
  #if authors != none {
    let count = authors.len()
    let ncols = calc.min(count, 3)
    place(bottom + center)[
      #grid(columns: (1fr,) * ncols,
          align: center,
          ..authors.map(author =>
            text(font: coverfont, size: 11pt, fill: luma(20))[
              #author.name \
              #author.affiliation \
              #author.email
            ]))
    ]
  }
]


place(bottom + center)[
  #stack(dir: ttb, spacing: 1.5em,
  if date != none { text(size: 1.1em, font: coverfont)[#date] },
  if cover-note != none {
  set par(leading: 0.8em, justify: false)
    block(width: 60%)[#text(font: mainfont, size: 0.9em, style: "italic", weight: 100, fill:luma(50))[#cover-note]]
  }
  )
]
pagebreak()

// Set the toc format
set page(numbering: "- 1 -")
counter(page).update(1)
if toc {
    block(above: 2em, below: 2em)[
    #set par(leading: 1.5em)
    #set text(size: 1em, font: mainfont)
    #align(center)[#outline(title: "目录", depth: 2, indent: auto)]
    ]
  pagebreak()
  }

if toc-figure {
    block(above: 2em, below: 2em)[
    #set par(leading: 1.5em)
    #set text(size: 1em, font: mainfont)
    #align(center)[#outline(title: "统计图", depth: 2, indent: auto, target:figure.where(kind: image))]
    ]
  pagebreak()
}


counter(page).update(1)
set page(
    header: context {
      let page = counter(page).get().first()
      let alignment = if calc.odd(page) { right } else { left }
      align(alignment, text(fill: luma(50), size: 0.9em)[#header])
      },
    footer: context {
      let page = counter(page).get().first()
      let body = if calc.odd(page) [#footer#h(1em)\- #page \-] else [\- #page \-#h(1em)#footer]
      let alignment = if calc.odd(page) { right } else { left }
      align(alignment, text(fill: luma(50), size: 0.9em)[#body])
      }
)


  

set text(font: mainfont)
  if abstract != none {
    block(inset: 2em, fill: luma(250), radius:1em)[
    #text(weight: "bold")[【摘要】] 
    #text(size: 0.95em)[#abstract]
    ]
  }
  
 set text(size: 1em)
  if cols == 1 {
    doc
  } else {
    columns(cols, doc)
  }
}

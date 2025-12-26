
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

#let fact(
  title: none,
  width: 1050pt,
  height: 1500pt,
  logo: "./_extensions/fact/logo.png",
  mainfont: "Times New Roman",
  registry: "",
  report: "",
  year: 2021,
  header-color: rgb("#f08a5d"),
  doc
) = {
//let header-color  = rgb("#f08a5d")
set text(fill: luma(255), size: 30pt, font: mainfont)

let bg-page = context{
  place(top,
      rect(
          fill: header-color,
          width: 100%,
          height: 150pt,
        ))
  place(bottom,
      rect(
          fill: header-color,
          width: 100%,
          height: 60pt
        ))
  }

let fact-header = {
grid(
  columns: (3fr, 1fr),
  place(horizon + left, image(logo, height: 80%)),
  align(right,
      block[#text(font: mainfont, size: 25pt, tracking: 3pt)[#registry]
            #linebreak()
            #text(font: mainfont, size: 25pt, tracking: 3pt)[#report]]
            )
)
}


let fact-footer = {
  set text(size: 15pt)
  grid(
    columns: (2fr, 1fr, 2fr),
    align: center + horizon,
    text[Cancer Registry Report (#year)],
    context(
      counter(page).display()
    ),
    align(right)[#text[Powered by canregtools | All Rights Reserved.]],
)

}

set page(
  width: width,
  height: height,
  fill: luma(255),
  margin: (top: 150pt, right: 20pt, bottom: 60pt, left: 20pt),
  background: bg-page,
  header: fact-header,
  footer: fact-footer
)

show heading: it => {
  set par(first-line-indent: 0em)
  set text(tracking: 2pt, fill: header-color)
  box[#if it.numbering != none {
         counter(heading).display()
      }
      #h(0.3em)
      #it.body
     ]
}

place(top + center,
block(fill: header-color, width: width, height: 70pt,
grid(
columns: (3fr, 1fr),
place(top + left, text(font: mainfont, size: 45pt, tracking: 5pt)[#h(0.5em)#title]),
place(top + right, text(font: mainfont, size: 45pt)[#year#h(0.5em)])
)
)
)

v(100pt)

doc

}


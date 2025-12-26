
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


#let article(
  subject: none,
  sender: none,
  recipient: none,
  date: none,
  logo: "./_extensions/letter/logo.png",
  paper: "a4",
  mainfont: "STsong",
  fontsize: 12pt,
  attachment: none,
  doc,
  ) = {
  

  set page(paper: paper,
           margin: (top: 4cm, bottom: 2.5cm, left: 3cm, right: 2.5cm),
           header: place(bottom+left, dx: -2cm, align(left)[#image(logo, height: 50%)])
           )
  set block(spacing: 3em)
  set par(leading: 1.5em, justify: true, spacing: 2em)
  set text(font: mainfont, size: fontsize, fill: luma(10))
  //标题前空2cm
  v(3em)
  //标题
  if subject != none {
    align(center, text(size: 1.3em)[#subject])
  }
  //标题后空2cm
  v(2em)
  text(weight: "extrabold", fill: luma(0))[#recipient：]
  v(1em)
  set par(first-line-indent: 2em)
  // Add body and name.
  doc
  
  set par(first-line-indent: 0em, spacing: 1.8em)
  v(1em)
  text[#h(2em)此致#linebreak()敬礼！]
  v(1.25cm)

  align(right, if sender != none {
    sender
  } else {
    hide("a")
  })

  align(right, if date != none {
    date
  } else {
    hide("a")
  })
  
if attachment != none {
    pagebreak()
    align(center, text(size: 1.2em, weight: "bold")[附#h(2em)件])
    v(1cm)
    set par(first-line-indent: 2em)
    attachment
  }

}

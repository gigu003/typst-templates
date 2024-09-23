
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


#let factsheet(
  title: none,
  doc,
) = {

let head_color = rgb(159, 70, 49)

let footer_text(term) = {
  set text(fill: luma(255), size: 15pt)
  text[#term]
}

let header_text(term, size:20pt) = {
  set text(fill: luma(255), size: size)
  text[#term]
}

let bg_header_footer = context{
    for i in (1, 2) {
      if i == 1 {
        place(top, rect(
          fill: head_color,
          width: 100%,
          height: 200pt,
        ))
      } else if i == 2 {
        place(bottom, rect(fill: head_color,
          width: 100%,
          height: 60pt
        ))
      }
    }
  }
  
let fact_header={
  table(
    columns: (2fr, 4fr, 2fr), align: horizon + center, stroke: none,
    rows: (30%, 50%, 20%),
    table.cell(rowspan: 2, align: center,inset: 10pt,)[
    #image("./_extensions/fact/logo1977.gif", height: 90%)], 
    table.cell(rowspan: 2)[#header_text(size:60pt)[#title]], [],[],
    table.cell(align: center)[#header_text[Henan Cancer Hospital]],[],
    table.cell(align: right+bottom)[#header_text[Cancer Fact Sheet]],
  )
}

let fact_footer = {
  grid(
    columns: (2fr, 1fr, 2fr),
    align: center + horizon,
    footer_text[The Henan Province Cancer Registration Report (2023)],
    counter(page).display("1/1",both: true,),
    align(right)[#footer_text[Made by Qiong Chen,  All Rights Reserved.]],
)
}

set page(
  width: 1050pt,
  height: 1486pt,
  fill: luma(250),
  margin: (top: 250pt, right: 50pt, bottom: 50pt, left: 50pt), 
  background: bg_header_footer,
  header: fact_header,
  footer: fact_footer,
)

doc

}


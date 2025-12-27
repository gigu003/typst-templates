
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
#import "@preview/alexandria:0.2.2": *
#show: alexandria(prefix: "x:", read: path => read(path))
#show: alexandria(prefix: "y:", read: path => read(path))
#let accent = rgb(0, 45, 120)
#let box-bg = rgb(235, 235, 235)
#let align_left_right(title, left_body, right_body) = {
  block[
    #text(fill: accent, weight: "extrabold")[#title]
    #linebreak()
    #box(width: 4fr)[_ #left_body _]
    #box(width: 1fr)[
      #align(right)[
        _ #right_body _
      ]
    ]
  ]
}

#let article(
  title: "Curriculum Vitae",
  author: (:),
  contacts: (:),
  date: none,
  margin: (x: 2.5cm, y: 2.5cm),
  paper: "a4",
  lang: "en",
  region: "US",
  font: "libertinus serif",
  fontsize: 11pt,
  heading-family: "libertinus serif",
  heading-weight: "bold",
  heading-style: "normal",
  heading-color: black,
  heading-line-height: 0.65em,
  sectionnumbering: none,
  pagenumbering: "1",
  doc,
) = {
  set document(
    author: author.firstname + " " + author.lastname,
    title: title,
  )
  set page(
    paper: paper,
    margin: margin,
    numbering: pagenumbering,
   header: context {
    if counter(page).get().at(0) > 1 {
      stack(
        spacing: 4pt,
        grid(
          columns: (1fr, auto),
          align: (left, right),
          [
            #text(fill: accent)[
              #h(5pt)Curriculum Vitae: #h(5pt)#author.firstname#h(5pt)#author.lastname
            ]
          ],
          [
            #text(fill: accent)[
              #counter(page).display()#h(5pt)
            ]
          ]
        ),
        line(
          length: 100%,
          stroke: 0.5pt + gray.darken(40%)
        )
      )
    }
  },
  footer: none
  )
  set par(justify: true)
  set text(lang: lang,
           region: region,
           font: font,
           size: fontsize)
  set heading(
    numbering: sectionnumbering,
    outlined: false,
    )


set text(size: fontsize, fill: accent,)
let create-logo-text(
  desc: "",
  type: "email",
  fontsize: 10pt,
  leading: 4pt,
  hanging-indent: 1.3em,
) = {
// Construct the logo according type of description
let logo = if type == "email" {
  box(baseline: 20%, image("_assets/icons/email.svg", height: 1em))
} else if type == "website" {
  box(baseline: 20%, image("_assets/icons/website.svg", height: 1em))
} else if type == "orcid" {
  box(baseline: 20%, image("_assets/icons/orcid.svg", height: 1em))
} else if type == "affiliation" {
  box(baseline: 20%, image("_assets/icons/affiliation.svg", height: 1em))
} else if type == "github" {
  box(baseline: 20%, image("_assets/icons/github.svg", height: 1em))
}

// Construct the website url of the description
let website-url = if type == "email" {
  "mailto:" + desc
} else if type == "website" {
  "https://" + desc
} else if type == "orcid" {
  "https://orcid.org/" + desc
} else if type == "github" {
  "https://github.com/" + desc
} else if type == "affiliation" {
  desc
}

// Construct full description according to the type of description
let full-description = if type == "email" {
  desc
} else {
  website-url
}


par(
  leading: leading,
  hanging-indent: hanging-indent,
  if type == "affiliation" {
    text(size: fontsize,)[#logo#h(4pt)#full-description]
  } else {
    link(website-url)[#text(size: fontsize,)[#logo#h(4pt)#full-description]]
  }
  )
}


let description = author.department + ", " + author.affiliation + ", " + author.city + ", " + author.country + "."
box(
  width: 100%,
  height: 15%,
  inset: 12pt,
  fill: box-bg,
  stroke: (paint: black, thickness: 0.6pt),
)[
  #grid(
    columns: (3fr, 4fr),
    gutter: 18pt,
    grid(
      rows: (1fr, 1fr),
      align: (horizon),
      gutter: 15pt,
      text(size: 18pt, weight: "bold")[Qiong Chen
      #text(size: 12pt,)[#linebreak()PhD, #author.position]],
      text(weight: "bold")[
        #title#linebreak()
        #text(size: 10pt)[#date]
        ]
      ),
      grid(
        rows: auto,
        align: (horizon, left),
        gutter: 4pt,
        create-logo-text(desc: description, type: "affiliation"),
        create-logo-text(desc: contacts.orcid, type: "orcid"),
        create-logo-text(desc: contacts.github, type: "github"),
        create-logo-text(desc: contacts.email, type: "email"),
        create-logo-text(desc: contacts.website, type: "website"),
      ),
  )
]


set text(size: fontsize, fill: black,)

show heading: it => {
  if it.level == 3 {
    text(
      size: 1em,
      weight: "bold",
      fill: accent,
    )[#it.body]
  } else {
    par(
      leading: 0.8em,
      text(
        size: 1.05em,
        weight: "bold",
        fill: accent,
      )[#it.body]
    )
  }
}

doc

}

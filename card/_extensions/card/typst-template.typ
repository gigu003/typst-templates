
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
  title-page: none,
  last-page: none,
  title: none,
  description: none,
  categories: none,
  series: none,
  authors: none,
  date: none,
  cols: 1,
  margin: (top: 30mm, bottom: 15mm, left: 15mm, right: 15mm),
  width: 800pt,
  height: 500pt,
  lang: "en",
  region: "US",
  font: "libertinus serif",
  fontsize: 11pt,
  heading-size: 1.5em,
  heading-family: "libertinus serif",
  heading-weight: "bold",
  heading-style: "normal",
  heading-color: black,
  heading-line-height: 1.3em,
  sectionnumbering: none,
  pagenumbering: "1",
  theme-color: red,
  doc,
) = {
  set page(
    width: width,
    height: height,
    margin: margin,
    numbering: pagenumbering,
    fill: luma(255),
    header: context[
      #place(horizon + left, dx: -10mm,
            text(fill: luma(50), tracking: 2pt, weight: 600)[
            #box(baseline: 0.2em, // 调整垂直对齐位置
                  rect(width: 0.6em, height: 1.5em, fill: theme-color)) #h(0.5em)
                  公众号: 普癌新声])
      #place(horizon + right, text(fill: luma(80), tracking: 1pt, weight:300)[
            #series
            #h(0.5em)
            #counter(page).display("P1")]
      )
    ],
  footer: place(bottom+center, rect(width:130%,
                              height:0.5em,
                              fill: gradient.linear(..color.map.crest))
                              )
  )
  
  set par(justify: true, leading: 1.5em, spacing: 2em,
          first-line-indent: (amount:2em, all:true))
  set text(lang: lang,
           region: region,
           font: font,
           tracking: 1pt,
           size: fontsize)
  set heading(numbering: sectionnumbering)

  show heading: it => {
  set par(first-line-indent: 0em)
  set text(tracking: 1pt, font: heading-family,
           weight: heading-weight, style: heading-style,
           fill: heading-color)
    v(0.5em)
    if it.numbering == 1 {
      set text(size: 1.2em)
    } else if it.numbering == 2 {
      set text(size: 1.1em)
    } else {
      set text(size: 1em)
    }
    
    if it.numbering != none {
      counter(heading).display()
      h(0.3em)
      }
  // 级别样式
  if it.level == 1 {
    underline(stroke: 1.1pt + theme-color, offset: 8pt, extent: 0pt)[#it.body]
  } else if it.level == 2 {
    [\/\/ #it.body]
  } else {
    it.body
  }
      parbreak()
}


set list(indent: 1em, spacing: 1em, )
set enum(indent: 1em, spacing: 1em, )
show strong: set text(weight: "bold", fill: theme-color)
show emph: set text(weight: "bold", fill: theme-color)

show quote.where(block: true): it => {
  grid(
  columns: (auto, auto, auto),
  h(1.5em),
  block(
    stroke: (left: 3pt + theme-color),
    [#text(style: "italic", weight: 800, fill: luma(60))[#it]]
    ),
  h(1.5em)
  )
}

if title-page != none {
    v(30%)
    if title != none {
    underline(stroke: 1.3pt + theme-color, offset: 8pt, extent: 0pt)[
    #align(center)[#block(inset: 5pt)[
      #set par(leading: heading-line-height)
      #set text(tracking: 1pt,
                font: heading-family,
                weight: heading-weight,
                style: heading-style,
                fill: heading-color)
        #text(size: heading-size)[#title]
    ]]
    ]
  }
  
  if authors != none {
    let count = authors.len()
    let ncols = calc.min(count, 3)
    v(10pt)
    grid(
      columns: (1fr,) * ncols,
      row-gutter: 1.5em,
      ..authors.map(author =>
          align(center)[
          #text(font:heading-family, size:1em, fill:luma(40), weight:"bold",)[
            #author.name\
            #h(0.2em)
            #author.affiliation
            #h(0.2em)
            #author.email
          ]
          ]
      )
    )
  }
  
  if description != none {
    v(15pt)
    set par(leading: 1.1em)
    block(inset: 5pt)[
      #text(fill: luma(80), tracking: 1pt,
            style: "oblique", weight: "light")[#description]
    ]
  }

  place(bottom)[
    #block(inset: 5pt)[
    #grid(columns: (3fr, auto),
          if categories != none {
          align(left)[#text(fill:luma(80),size:0.9em)[#h(1em)#categories]]
          },
          align(right)[#text(fill:luma(80),size:0.9em)[#date#h(0.2em)]]
          )
    ]
    #v(15pt)
  ]

  pagebreak()
  
  }
  
  
  if cols == 1 {
    doc
  } else {
    columns(cols, doc)
  }
  
  if last-page != none {
  pagebreak()
  text[
  【普癌新声】聚焦肿瘤登记、统计分析、R 语言 及 网站制作，
  我们在这里分享数据分析方法、可视化技巧与自动化报告解决方案。🚀
  ]
  v(1.5em)
  grid(
  columns: (2fr, 2fr),
  figure(
    numbering: none,
    image("_extensions/card/qsight.png", width: 90%),
    caption: [Qsight博客]),
  figure(
    numbering: none,
    image("_extensions/card/wechat.jpg", width: 90%),
    caption: [微信公众号]),
  )
  v(1.5em)
  align(center,text(fill: theme-color)[
  关注【普癌新声】，获取更多精彩内容 ！\
  💬 欢迎留言交流，期待您的意见和建议 ！\ 
 点亮右下角 ❤️ ，点赞 & 分享，一起传播有价值的内容 ！
  ])
  }
  
}

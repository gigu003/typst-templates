
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
  series: "肿瘤登记",
  logo-text: "普癌新声 - Qsight博客",
  authors: "陈琼博士",
  date: datetime.today().display(),
  cols: 1,
  margin: (top: 30mm, bottom: 25mm, left: 27mm, right: 27mm),
  width: 210mm,
  height: 297mm,
  lang: "en",
  region: "US",
  font: "STSong",
  fontsize: 12pt,
  heading-size: 1.5em,
  heading-family: "STHeiti",
  heading-weight: "bold",
  heading-style: "normal",
  heading-color: black,
  heading-line-height: 1.3em,
  sectionnumbering: none,
  pagenumbering: "1",
  theme-color: red,
  first-line-indent: 0em,
  heading-image: "bird.jpeg",
  card-image: "dog.png",
  card-bg: luma(250),
  doc,
) = {

  set document(
    title: title
  )
  set page(
    width: width,
    height: height,
    margin: margin,
    numbering: pagenumbering,
    fill: luma(255),
    header: context[
      #place(horizon + left, dx: -20mm,
            text(fill: luma(50), tracking: 2pt, weight: 600)[
            #box(baseline: 0.2em, // 调整垂直对齐位置
                  rect(width: 0.6em, height: 1.5em, fill: theme-color)) #h(0.5em)
                  ®#logo-text])
      #place(horizon + right, dx: 18mm, text(fill: luma(50), tracking: 1pt, weight:300)[
            系列#h(0.2em)\/\/#h(0.2em)#series]
      )
    ],
  footer: context[
        #place(bottom + center,
                 rect(width: 150%, height:0.6em,
                      fill: gradient.linear(..color.map.crest))
                )
        #place(horizon + center, text(fill: luma(80),
              tracking: 1pt, weight:300, size:0.8em)[
           第#counter(page).display("1")页]
      )
  
  ]
  )
  
  set par(justify: true, leading: 1.5em, spacing: 2em,
          first-line-indent: (amount: first-line-indent, all: true))
  set text(lang: lang,
           region: region,
           font: font,
           tracking: 1pt,
           size: fontsize,
           weight: 100)
  set heading(numbering: sectionnumbering)


  show heading: it => {
  set par(first-line-indent: 0em)
  set text(tracking: 1pt, font: heading-family,
           weight: heading-weight, style: heading-style,
           fill: heading-color)
    v(0.5em)
  if it.level == 1 {
      // 一级标题：编号 + 下划线文字，在一行居中
      align(center)[
        #box[
          #if it.numbering != none {
          counter(heading).display()
          }
          #h(0.3em)
          #underline(stroke: 1.1pt + theme-color,
                    offset: 8pt, extent: 0pt)[
                    #text(size: 1.1em, fill:luma(30))[#it.body]]
        ]
      ]
    } else if it.level == 2 {
      // 二级标题
      box[
        \/\/
          #if it.numbering != none {
          counter(heading).display()
          }
        #h(0.3em)
        #text(size: 1.15em, fill:luma(30))[#it.body]
      ]
    } else if it.level == 3 {
      // 三级标题
      box[
        \/\/\/
          #if it.numbering != none {
          counter(heading).display()
          }
        #h(0.3em)
        #text(size: 1.1em, fill:luma(30))[#it.body]
      ]
    } else {
      // 其他标题
      box[
        #if it.numbering != none {
          counter(heading).display()
          }
        #h(0.3em)
       #text(size: 1.05em, fill:luma(30))[#it.body]
      ]
    }

}

set list(indent: 1em, spacing: 1.5em,)
set enum(indent: 1em, spacing: 1.5em,)
show list: it => block[
  #v(0.5em)
  #it
  #v(0.5em)
]
show enum: set par(leading: 1.2em)
show enum: it => block[
  #v(0.5em)
  #it
  #v(0.5em)
]


show link: underline
show strong: set text(weight: "bold", fill: theme-color)
show emph: set text(weight: "bold", fill: theme-color)
show raw.where(block: false): text.with(
  fill: blue.darken(50%)
)
show raw.where(block: true): it => {
  set par(leading: 0.9em)
  set text(font: "Menlo", size: 0.9em)
  it
}

show quote.where(block: true): it => {
  set par(leading: 1.2em)
  grid(
  columns: (auto, auto, auto),
  h(1.2em),
  block(
    inset: (top: 1em, bottom: 1em, left: 0.1em, right: 0em),
    stroke: (left: 3pt + theme-color),
    [#text(size:0.95em, style: "italic", weight: 200, fill: luma(50))[#it]]
    ),
  h(1em)
  )
}

if heading-image != none {
  figure(
      numbering: none,
      gap: 0.2em,
      image(heading-image, width: 100%)
    )
}
  
grid(columns: (3fr, auto),
     if categories != none {
      align(left)[#text(fill:luma(80), size:1em)[#categories]]
      },
      align(right)[#text(fill:luma(80), size:1em)[#date]]
    )

v(0.5em)

  if title != none {
    underline(stroke: 1.3pt + theme-color, offset: 8pt, extent: 0pt)[
    #align(left)[#block()[
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
          align(left)[
          #text(font:font, size:1em, fill:luma(0), weight:"bold",)[
          #if author.name != none and author.name != "" {
            [️👨‍💻 #author.name]
          }
          #if author.affiliation != none and author.affiliation != "" {
            [(#author.affiliation)]
          }
            #if author.email != none and author.email != "" {
            [#h(0.3em)📬 #author.email]
          }
          ]
          ]
      )
    )
}
  
  v(2em)
  
  if description != none {
    v(15pt)
    set par(leading: 1.1em)
    block(inset: 5pt)[
      #text(fill: luma(80), tracking: 1pt,
            style: "oblique", weight: "light")[#description]
    ]
  }

  v(5mm)
  
  if cols == 1 {
    doc
  } else {
    columns(cols, doc)
  }
  
  if last-page != none {
  pagebreak()
  v(10mm)
  set par(first-line-indent: (amount: 0em, all: true), leading: 0.95em)
  
  
  block(
    inset: 6pt,
    stroke: (left: 3pt + theme-color),
    [#text(size: 1.2em, fill: luma(20), font: heading-family)[作者简介]]
    )
  grid(columns: (1fr, 3fr, auto), gutter: 0.8em,
    figure(
    numbering: none,
    image("qiong.png", width: 90%),
    caption: text(fill: luma(40))[陈#h(0.5em)琼]
  ),
  place(top)[
  #block(inset: 3pt,)[#text(fill: luma(40))[
博士，副主任医师，就职河南省癌症中心/河南省肿瘤医院，从事肿瘤登记和描述流行病相关工作和研究，
担任《河南省肿瘤登记年报》副主编。创建网站
#link("https://chenq.site")[（https://www.chenq.site）] 及微信公众号【普癌新声】，
分享肿瘤登记、数据分析、R 语言编程、可视化技巧与可重复性报告解决方案 🚀。
]]
  ],
  h(0.3em)
  
    
  )


  v(3em)
  grid(
  columns: (2fr, 2fr),
  figure(
    numbering: none,
    image("qsight.png", width: 90%),
    caption: [Qsight博客]),
  figure(
    numbering: none,
    image("wechat.jpg", width: 90%),
    caption: [微信公众号]),
  )
  v(2em)
  align(center,text(fill: theme-color)[
  扫描二维码，关注公众号，获取更多精彩内容 ！\
  💬 欢迎公众号留言交流，期待您的意见和建议 ！\ 
 请点亮 ❤️ ，点赞 & 分享，一起传播有价值的内容 ！
  ])
  
  place(bottom + left)[
      #text(size: 0.8em, fill: luma(50))[
        P.S. 本文版权归属\@陈琼博士所有，如需转载或转发，应以完整 PDF 全文形式进行，
        不得截取、删改或仅传播部分内容。]]
  
  }
  
  
  // 设置Card用于微信公众号首图
  let card-title = {
    grid(
    columns: (3fr, 6fr),
    gutter: 1.3em,
    image(card-image, width:100%),
    align(left+horizon)[
    #set par(leading: 0.9em)
    #text(tracking: 1pt, font: heading-family, weight: heading-weight,
        style: heading-style, fill: heading-color, size: heading-size)[
    #underline(stroke: 1.1pt + theme-color, offset: 8pt, extent: 3pt)[
    #title]
    ]
    ]
  )
  }
  //设置card footer
 let card-footer = {
   context[#place(horizon,
                  grid(columns: (3fr, auto),
                    if categories != none {
                          set text(fill:luma(50), size: 1em)
                          align(left)[#categories]
                          },
                          align(right)[#date]
                          )
                          )
                ]
 }
  
  pagebreak()
  set page(height: 89.4mm, footer: card-footer, fill: card-bg)
  if title != none {
    card-title
  }
  
}

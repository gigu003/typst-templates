
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
  subtitle: none,
  description: none,
  categories: none,
  series: none,
  logo-text: "河南省肿瘤医院",
  authors: none,
  date: datetime.today().display(),
  cols: 1,
  margin: (top: 20mm, bottom: 15mm, left: 20mm, right: 20mm),
  width: 338.7mm,
  height: 190.5mm,
  lang: "en",
  region: "US",
  font: "STSong",
  fontsize: 20pt,
  heading-size: 32pt,
  heading-family: "STHeiti",
  heading-weight: "bold",
  heading-style: "normal",
  heading-color: black,
  heading-line-height: 1.3em,
  sectionnumbering: none,
  pagenumbering: "1",
  theme-color: red,
  first-line-indent: 0em,
  heading-image: none,
  card-image: "dog.png",
  card-bg: luma(250),
  doc,
) = {

// 字体大小
let header-size = 0.7em

// 定义函数和变量
// 定义函数：带条形框的文本
let qbar-text(body,
              text-size: 1em,
              text-tracking: 2pt,
              text-weight: 300,
              text-color: luma(100),
              border-size: 0.5em,
              border-color: red,
              inset-y: 0.3em,
              inset-x: 0.5em,
              outset-x: 0em
              ) = {
  block(
    inset: (left: inset-x, right:inset-x, top: inset-y, bottom: inset-y),
    outset: (left: outset-x),
    stroke: (left: border-size + border-color),
    [
     #text(size: text-size, fill: text-color, tracking: text-tracking,
           weight: text-weight)[#body]
    ]
    )
}

// 定义函数：条形框qbar
let qbar(bar-width: 100%,
         bar-height: 0.2em,
         position: top + center,
         fill: gradient.linear(..color.map.crest)
         ) = { 
  place(position, rect(width: bar-width,
                       height: bar-height,
                       fill: fill
                       )
        )
}

// 定义函数：qheader
let qheader(text-size: 0.7em,
            fill: gradient.linear(..color.map.crest)
            ) = {
      qbar(bar-width: width, position: top + center, fill: fill)
      place(horizon + left, dx: -10mm,
            qbar-text(border-color: theme-color,
                      text-size: text-size,
                      border-size: 0.3em,
                      inset-y: 0.2em,
                      inset-x: 0.6em)[®#logo-text]
            )
      if series != none {
      place(horizon + right, dx: 10mm,
            text(size: text-size,
                 fill: luma(100),
                 tracking: 1pt,
                 weight: 100)[系列#h(0.2em)\/\/#h(0.2em)#series]
            )
      }
}

// 定义函数：qfooter
let qfooter(text-size: 0.7em,
            fill: gradient.linear(..color.map.crest)
            ) = {
  qbar(bar-width: width, position: bottom + center, fill: fill)
  if counter(page).get().at(0) > 1 {
      place(horizon + right,
            text(fill: luma(80),
                 tracking: 1pt,
                 weight: 200,
                 size: text-size
                 )[第#counter(page).display("1")页]
           )
    }
}


// 设置文档元数据
set document(
    title: title,
    author: "陈琼博士",
    date: auto,
    description: description,
    keywords: ()
  )

//统一页面设置
set page(width: width,
         height: height,
         margin: margin,
         numbering: pagenumbering,
         fill: luma(255),
         header: context[#qheader()],
         footer: context[#qfooter()]
         )
         
//设置段落格式
set par(justify: true,
        leading: 1.1em,
        spacing: 1.2em,
        first-line-indent: (amount: first-line-indent, all: true)
        )
//设置文本格式
set text(lang: lang,
         region: region,
         font: heading-family,
         tracking: 1pt,
         size: fontsize,
         weight: 100
         )
//设置标题序号格式
set heading(numbering: sectionnumbering)

//设置不同级别标题格式
show heading: it => {
  set par(first-line-indent: 0em)
  set text(tracking: 1pt,
           font: heading-family,
           weight: heading-weight,
           style: heading-style,
           fill: heading-color,
           size: fontsize
           )
    v(0.5em)
  if it.level == 1 {
      // 设置一级标题格式：编号 + 下划线文字，在一行居中
      pagebreak()
      set text(size: 1.6em, fill: theme-color)
      align(center+horizon)[
        #box[
          #if it.numbering != none { 
            counter(heading).display()
          }
          #h(0.3em)
          #underline(stroke: 3pt + theme-color, offset: 8pt, extent: 0pt)[
                    #it.body
                    ]
        ]
      ]
      
    } else if it.level == 2 {
      pagebreak()
      // 设置二级标题格式
      set text(size: 1.4em, fill: luma(30), weight: 800)
      box[
          #if it.numbering != none {
          counter(heading).display()
          }
        #h(0.3em)
        #it.body
      ]
    } else if it.level == 3 {
      // 设置三级标题格式
      //set text(size: 1.3em, fill: luma(30), weight: 700)
      box[
        \/\/\/
          #if it.numbering != none {
          counter(heading).display()
          }
        #h(0.3em)
        #it.body
      ]
    } else {
      // 其他标题
      set text(size: 1.1em, fill: luma(30), weight: 700)
      box[
        #if it.numbering != none {
          counter(heading).display()
          }
        #h(0.3em)
       #it.body
      ]
    }

}

set list(indent: 1em, spacing: 1.2em,)
set enum(indent: 1em, spacing: 1.2em,)
show list: it => block[
  #it
]
show enum: set par(leading: 1.2em)
show enum: it => block[
  #it
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
  set text(size:1em, style: "italic", weight: 200, fill: luma(50))
  qbar-text(inset-x: 2em, outset-x: -1.4em, inset-y: 0.7em,
            border-color: theme-color)[#it]
  set text(size: fontsize)
}


// 布置title-page
// 标题页图片
if heading-image != none {
  figure(numbering: none,
         gap: 0.1em,
         image(heading-image, width: 100%, height: 25%)
    )
} else {
  v(25%)
}
  
// 标题
if title != none {
  set par(spacing: 0.8em)
  if categories != none {
    align(left)[#text(font: heading-family,
                      fill:luma(80),
                      size: header-size*1.1)[#categories]]
}
    underline(stroke: 1.3pt + theme-color, offset: 8pt, extent: 0pt)[
    #align(left)[#block()[
      //#set par(leading: heading-line-height)
      #set text(tracking: 1pt,
                font: heading-family,
                weight: heading-weight,
                style: heading-style,
                fill: heading-color)
        #text(size: heading-size)[#title]
    ]]
    ]
  if subtitle != none {
  text(size: heading-size*0.5)[#subtitle]
  }
  set par(spacing: 2em)
  
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
          #text(font:font, size: 1em, fill:luma(70), weight: 200,)[
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

align(left)[#text(font: heading-family,
                  fill:luma(80),
                  size:0.9em)[📅 #date]]

//页面从1开始计数
counter(page).update(0)

// 正文内容  
if cols == 1 {
    doc
  } else {
    columns(cols, doc)
  }



// 设置谢谢关注页面
if last-page != none {
  set text(font: heading-family, size: 20pt, fill: luma(100))
  set page(fill: luma(250), footer: context[
  #place(bottom + center,
                 rect(width: width, height: 0.2em,
                      fill: gradient.linear(..color.map.crest))
                )
  #place(top+center)[
    #grid(
      columns: (1fr, 1fr, 1fr), gutter: 1em, align: center,
      text(size:0.8em, fill: luma(100))[ 🌎 #link("https://chenq.site")[https://www.chenq.site]],
      text(size:0.8em, fill: luma(100))[ ✍️ 微信公众号【普癌新声】],
      text(size:0.8em, fill: luma(100))[ 📬 chenq08\@126.com]
    )
    ]
  ])

  place(horizon + center,
        [#text(size: 70pt,
               fill: theme-color,
               tracking: 40pt,
               weight: 800
             )[请批评指正]
         #text(size: 30pt,
               fill: luma(100),
               tracking: 2pt,
               weight: 300
               )[#linebreak()Thanks for your attention]
        ]
             )

  pagebreak()
  set par(first-line-indent: (amount: 0em, all: true), leading: 0.95em)
  v(1em)
  align(center)[
  #text(size: 1.6em, fill: luma(80), font: heading-family, tracking: 10pt,
            weight: 500)[关注作者👀]
  #linebreak()
  #qbar-text(text-weight: 300,
             text-color: luma(60)
             )[陈琼博士#h(1em)副主任医师#h(2em)河南省癌症中心｜河南省肿瘤医院]
  ]
  
  grid(columns: (auto, 1fr, 1fr, auto), gutter: 1em,
      h(20%),
      figure(numbering: none,
             image("wechat.jpg", width: 90%),
             caption: [#text(size:0.9em)[微信公众号]]
             ),
      figure(numbering: none,
             image("qsight.png", width: 90%),
             caption: [#text(size:0.9em)[Qsight博客]]
             ),
      h(20%)
  )
  
  }
  
}


// Typst custom formats typically consist of a 'typst-template.typ' (which is
// the source code for a typst template) and a 'typst-show.typ' which calls the
// template's function (forwarding Pandoc metadata values as required)
//
// This is an example 'typst-show.typ' file (based on the default template  
// that ships with Quarto). It calls the typst function named 'article' which 
// is defined in the 'typst-template.typ' file. 
//
// If you are creating or packaging a custom typst template you will likely
// want to replace this file and 'typst-template.typ' entirely. You can find
// documentation on creating typst templates here and some examples here:
//   - https://typst.app/docs/tutorial/making-a-template/
//   - https://github.com/typst/templates
#show: doc => article(
$if(title)$
  title: [$title$],
$endif$
$if(title-page)$
  title-page: [$title-page$],
$endif$
$if(last-page)$
  last-page: [$last-page$],
$endif$
$if(description)$
  description: [$description$],
$endif$
$if(categories)$
  categories:[$for(categories)$🔖$categories$$sep$ #h(0.2em) $endfor$],
$endif$
$if(series)$
  series: [$series$],
$endif$
$if(logo-text)$
  logo-text: [$logo-text$],
$endif$
$if(by-author)$
  authors: (
$for(by-author)$
$if(it.name.literal)$
    ( name: [$it.name.literal$],
      affiliation: [$for(it.affiliations)$$it.name$$sep$, $endfor$],
      email: [$it.email$] ),
$endif$
$endfor$
    ),
$endif$
$if(date)$
  date: [$date$],
$endif$
$if(lang)$
  lang: "$lang$",
$endif$
$if(region)$
  region: "$region$",
$endif$
$if(width)$
  width: $width$,
$endif$
$if(height)$
  height: $height$,
$endif$
$if(margin)$
  margin: ($for(margin/pairs)$$margin.key$: $margin.value$,$endfor$),
$endif$
$if(papersize)$
  paper: "$papersize$",
$endif$
$if(mainfont)$
  font: ("$mainfont$",),
$elseif(brand.typography.base.family)$
  font: $brand.typography.base.family$,
$endif$
$if(fontsize)$
  fontsize: $fontsize$,
$elseif(brand.typography.base.size)$
  fontsize: $brand.typography.base.size$,
$endif$
$if(title)$
$if(brand.typography.headings.family)$
  heading-family: $brand.typography.headings.family$,
$endif$
$if(brand.typography.headings.weight)$
  heading-weight: $brand.typography.headings.weight$,
$endif$
$if(brand.typography.headings.style)$
  heading-style: "$brand.typography.headings.style$",
$endif$
$if(brand.typography.headings.decoration)$
  heading-decoration: "$brand.typography.headings.decoration$",
$endif$
$if(brand.typography.headings.color)$
  heading-color: $brand.typography.headings.color$,
$endif$
$if(brand.typography.headings.line-height)$
  heading-line-height: $brand.typography.headings.line-height$,
$endif$
$endif$
$if(heading-size)$
  heading-size: $heading-size$,
$endif$
$if(heading-image)$
  heading-image: "$heading-image$",
$endif$
$if(card-image)$
  card-image: "$card-image$",
$endif$
$if(card-bg)$
  card-bg: $card-bg$,
$endif$
$if(section-numbering)$
  sectionnumbering: "$section-numbering$",
$endif$
$if(theme-color)$
  theme-color: $theme-color$,
$endif$
$if(first-line-indent)$
  first-line-indent: $first-line-indent$,
$endif$
  pagenumbering: $if(page-numbering)$"$page-numbering$"$else$none$endif$,
  cols: $if(columns)$$columns$$else$1$endif$,
  doc,
)

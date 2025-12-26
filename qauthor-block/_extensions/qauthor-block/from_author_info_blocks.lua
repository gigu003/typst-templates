-- https://github.com/pandoc/lua-filters/commit/ca72210b453cc0d045360e0ae36448d019d7dfbf
--[[
affiliation-blocks – generate title components

Copyright © 2017–2021 Albert Krewinkel

Permission to use, copy, modify, and/or distribute this software for any purpose
with or without fee is hereby granted, provided that the above copyright notice
and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF
THIS SOFTWARE.
]]

-- from @kapsner
-- [import]
local from_utils = require "utils"
local has_key = from_utils.has_key
-- [/import]
local M = {}

-- taken from https://github.com/pandoc/lua-filters/blob/1660794b991c3553968beb993f5aabb99b317584/author-info-blocks/author-info-blocks.lua
local List = require 'pandoc.List'
local utils = require 'pandoc.utils'
local stringify = utils.stringify


-- taken from https://github.com/pandoc/lua-filters/blob/1660794b991c3553968beb993f5aabb99b317584/author-info-blocks/author-info-blocks.lua
local default_marks
local default_marks = {
  corresponding_author = FORMAT == 'latex'
    and {pandoc.RawInline('latex', '*')}
    or {pandoc.Str '†'},
  equal_contributor = FORMAT == 'latex'
    and {pandoc.RawInline('latex', '$\\dagger{}$')}
    or {pandoc.Str '*'},
}
M.default_marks = default_marks

-- modified by @kapsner
-- taken from https://github.com/pandoc/lua-filters/blob/1660794b991c3553968beb993f5aabb99b317584/author-info-blocks/author-info-blocks.lua
local function is_equal_contributor(author)
  if has_key(author, "attributes") then
    return author.attributes["equal-contributor"]
  end
  return nil
end

-- taken from https://github.com/pandoc/lua-filters/blob/1660794b991c3553968beb993f5aabb99b317584/author-info-blocks/author-info-blocks.lua
--- Create equal contributors note.
--- 生成共同作者标记
local function create_equal_contributors_block(authors, mark, lang)
  local doc_lang = "zh" -- 默认语言
  if lang then
    doc_lang = pandoc.utils.stringify(lang)
  end
  local notes
  if doc_lang:sub(1, 2) == "zh" then
    notes = "作者对本研究贡献相同"
  else
    notes = "These authors contributed equally to this work."
  end  

  local has_equal_contribs = List:new(authors):find_if(is_equal_contributor)
  if not has_equal_contribs then
    return nil
  end
  
  local contributors = {
    pandoc.Superscript(mark'equal_contributor'),
    pandoc.Space(),
    pandoc.Str(notes)
  }
  return List:new{pandoc.Para(contributors)}
end
M.create_equal_contributors_block = create_equal_contributors_block


-- taken from https://github.com/pandoc/lua-filters/blob/1660794b991c3553968beb993f5aabb99b317584/author-info-blocks/author-info-blocks.lua
local function intercalate(lists, elem)
  local result = List:new{}
  for i = 1, (#lists - 1) do
    result:extend(lists[i])
    result:extend(elem)
  end
  if #lists > 0 then
    result:extend(lists[#lists])
  end
  return result
end

-- taken from https://github.com/pandoc/lua-filters/blob/1660794b991c3553968beb993f5aabb99b317584/author-info-blocks/author-info-blocks.lua
--- Check whether the given author is a corresponding author
local function is_corresponding_author(author)
  if has_key(author, "attributes") then
    if author.attributes["corresponding"] then
      return author.email
    end
  end
  return nil
end
M.is_corresponding_author = is_corresponding_author

-- taken from https://github.com/pandoc/lua-filters/blob/1660794b991c3553968beb993f5aabb99b317584/author-info-blocks/author-info-blocks.lua
--- Generate a block element containing the correspondence information
local function create_correspondence_blocks(authors, mark, lang)
  local doc_lang = "zh" -- 默认语言
  if lang then
    doc_lang = pandoc.utils.stringify(lang)
  end
  local corresponding_authors = List:new{}
  for _, author in ipairs(authors) do
    if is_corresponding_author(author) then
      local mailto = 'mailto:' .. utils.stringify(author.email)
      local author_with_mail = List:new(
        -- modified by @kapsner
        author.name.literal .. List:new{pandoc.Str ",", pandoc.Space(),  pandoc.Str 'Email: '} ..
        author.email .. List:new{pandoc.Str ''}
      )
      local link = pandoc.Link(author_with_mail, mailto)
      table.insert(corresponding_authors, {link})
    end
  end
  if #corresponding_authors == 0 then
    return nil
  end
  
  -- 根据 Quarto 文档的语言 meta.lang 判断
  local label
  if doc_lang:sub(1,2) == "zh" then
    label = "通讯作者："
  else
    label = "Correspondence:"
  end
  
  local correspondence = List:new{
    pandoc.Superscript(mark'corresponding_author'),
    pandoc.Str(label),
    pandoc.Space()
  }
  local sep = List:new{pandoc.Str';',  pandoc.Space()}
  return {
    pandoc.Para(correspondence .. intercalate(corresponding_authors, sep))
  }
end
M.create_correspondence_blocks = create_correspondence_blocks

-- taken from https://github.com/pandoc/lua-filters/blob/1660794b991c3553968beb993f5aabb99b317584/author-info-blocks/author-info-blocks.lua
--- Create inlines for a single author (includes all author notes)
local function author_inline_generator (get_mark)
  return function (author)
    local author_marks = List:new{}

    local idx_str
    for _, idx in ipairs(author.affiliations) do
      if type(idx) ~= 'table' then
        idx_str = tostring(idx)
      else
        idx_str = stringify(idx)
      end
      author_marks[#author_marks + 1] = {pandoc.Str(idx_str)}
    end
    
    -- modified by @kapsner
    if has_key(author, "attributes") then
      if author.attributes["equal-contributor"] then
        author_marks[#author_marks + 1] = get_mark 'equal_contributor'
      end
    end
    
    if is_corresponding_author(author) then
      ---author_marks[#author_marks + 1] = get_mark 'corresponding_author'
      table.insert(author_marks, get_mark 'corresponding_author')
    end
    -- modified by @kapsner
    if FORMAT:match 'latex' then
      ---author.name.literal[#author.name.literal + 1] = pandoc.Superscript(intercalate(author_marks, {pandoc.Str ','}))
      author.name.literal[#author.name.literal + 1] = pandoc.Superscript(intercalate(author_marks, {}))
      return author
    else
      local res = List.clone(author.name.literal)
      res[#res + 1] = pandoc.Superscript(intercalate(author_marks, {pandoc.Str ','}))
      return res
    end
  end
end
M.author_inline_generator = author_inline_generator

-- taken from https://github.com/pandoc/lua-filters/blob/1660794b991c3553968beb993f5aabb99b317584/author-info-blocks/author-info-blocks.lua
--- Generate a list of inlines containing all authors.
local function create_authors_inlines(authors, mark, lang)
  local doc_lang = "zh" -- 默认语言
  if lang then
    doc_lang = pandoc.utils.stringify(lang)
  end
  local inlines_generator = author_inline_generator(mark)
  local inlines = List:new(authors):map(inlines_generator)
  ---local and_str = List:new{pandoc.Space(), pandoc.Str'  ', pandoc.Space()}
  local and_str
  if doc_lang:sub(1,2) == "zh" then
    and_str = List:new{pandoc.Space(),pandoc.Space(),pandoc.Space()}  -- 中文作者之间只加空格
  else
    and_str = List:new{pandoc.Space(), pandoc.Str'and', pandoc.Space()}
  end
  local last_author = inlines[#inlines]
  inlines[#inlines] = nil
  --- 添加最后一个作者前的间隔符号
  local result = intercalate(inlines, {pandoc.Space(), pandoc.Space(), pandoc.Space()})
  if #authors > 1 then
    if #authors == 2 then
      result:extend(and_str)
    else 
      result:extend(List:new{pandoc.Str ""} .. and_str)
    end
  end
  result:extend(last_author)
  return result
end
M.create_authors_inlines = create_authors_inlines

-- taken from https://github.com/pandoc/lua-filters/blob/1660794b991c3553968beb993f5aabb99b317584/author-info-blocks/author-info-blocks.lua
--- Generate a block list all affiliations, marked with arabic numbers.
local function create_affiliations_blocks(affiliations)
  local affil_lines = List:new(affiliations):map(
    function (affil, i)
      local num_inlines = List:new{
        pandoc.Superscript{pandoc.Str(affil.number)},
        pandoc.Space()
      }
      return num_inlines .. affil.name
    end
  )
  return {pandoc.Para(intercalate(affil_lines, {pandoc.LineBreak()}))}
end
M.create_affiliations_blocks = create_affiliations_blocks

return M

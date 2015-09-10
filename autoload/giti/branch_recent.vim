" File:    branch_recent.vim
" Author:  Fumihiro Ito <fmhrit@gmail.com>
" Version: 0.0.1
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

function! giti#branch_recent#recent() "{{{
  return s:build_formatted_branch_data(
\   s:get_recent_updated_branches('refs/heads/'))
endfunction "}}}

function! s:get_recent_updated_branches(target) "{{{
  return split(
\   giti#system('for-each-ref --sort=-committerdate --count=30 --format="%(refname:short),%(committerdate:relative),%(objectname:short),%(contents:subject)" ' . a:target),
\   '\n')
endfunction "}}}

function! s:build_formatted_branch_data(branch_list) "{{{
  let branch_data = map(
\   a:branch_list,
\   's:build_branch_data_from_formatted_line(v:val)'
\ )
  let name_width = s:calc_max_width(branch_data, "name")
  let date_width = s:calc_max_width(branch_data, "relativedate")

  return map(
\   branch_data, '{
\    "name" : s:align_in_width_with_whitespace(v:val.name, name_width),
\    "relativedate" : s:align_in_width_with_whitespace(v:val.relativedate, date_width),
\    "objectname"   : v:val.objectname,
\    "message"      : v:val.message,
\ }')
endfunction "}}}

function! s:calc_max_width(datas, key) "{{{
  let max_width = 0
  for data in a:datas
    if strlen(get(data, a:key, "")) > max_width
      let max_width = strlen(get(data, a:key, ""))
    endif
  endfor

  return max_width
endfunction "}}}

function! s:align_in_width_with_whitespace(val, width) "{{{
  return printf('%-'.(a:width + 1).'s', a:val)
endfunction "}}}

function! s:build_branch_data_from_formatted_line(line) "{{{
  let splitted = split(a:line, ",")
  return {
\   'name'         : splitted[0],
\   'relativedate' : splitted[1],
\   'objectname'   : splitted[2],
\   'message'      : join(splitted[3:], ","),
\ }
endfunction "}}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__

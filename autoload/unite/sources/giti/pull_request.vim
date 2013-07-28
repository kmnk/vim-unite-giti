" File:    pull_request.vim
" Author:  alpaca-tc <alprhcp666@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#giti#pull_request#define() "{{{
  return [s:define_source('base'), s:define_source('head')]
endfunction"}}}

function! s:define_source(base_or_head) "{{{
  let base_or_head = a:base_or_head
  let source = {
  \ 'name' : 'giti/pull_request/' . base_or_head,
  \ 'description' : 'select '. base_or_head .' repository',
  \ 'source__base_or_head' : base_or_head,
  \}

  function! source.gather_candidates(args, context) 
    let selected_repo = empty(a:args) ? '' : a:args[0]
    let base_or_head = self.source__base_or_head
    call s:print_message(a:args, base_or_head)

    return s:get_candidates(base_or_head, selected_repo)
  endfunction

  return source
endfunction"}}}

function! s:get_candidates(base_or_head, selected_repo) "{{{
  let branches = giti#branch#github_list_all()
  let candidates = map(branches, 's:remote2candidate(v:val, a:base_or_head, a:selected_repo)')
  let message_candidate = { 
        \ 'word': '-- Please select ' . a:base_or_head. ' repository --', 
        \ 'is_selected' : 1,
        \ 'is_dummy' : 1,
        \ }
  call insert(candidates, message_candidate, 0)

  return candidates
endfunction"}}}

function! s:remote2candidate(branch, base_or_head, selected_repo) "{{{
  let remote_name = a:branch.remote_name
  let name = a:branch.name_with_remote_name
  let abbr = printf('%-12s %s', '[' . a:branch.remote_name . ']', name)

  let [base_repo, head_repo] = a:base_or_head == 'base' ? 
        \ [name, a:selected_repo] : [a:selected_repo, name]

  return {
        \ 'word' : name,
        \ 'abbr' : abbr,
        \ 'kind' : 'giti/pull_request',
        \ 'action__base_repo': base_repo,
        \ 'action__head_repo': head_repo
        \ }
endfunction"}}}

function! s:print_message(args, base_or_head) "{{{
  if empty(a:args)
    let message = 'Select ' . a:base_or_head . ' repository'
  elseif a:base_or_head == 'base'
    let message = 'HEAD: ' . a:args[0]
  elseif a:base_or_head == 'head'
    let message = 'BASE: ' . a:args[0]
  endif

  call unite#print_message('[giti/pull_request] ' . message)
endfunction"}}}

" context getter {{{
function! s:get_SID()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfunction
let s:SID = s:get_SID()
delfunction s:get_SID

function! unite#sources#giti#pull_request#__context__()
  return { 'sid': s:SID, 'scope': s: }
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__

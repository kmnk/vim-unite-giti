" File:    pull_request.vim
" Author:  alpaca-tc <alprhcp666@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#giti#pull_request#define() "{{{
  if s:enabled_hub_command()
    return [s:define_source('base'), s:define_source('head')]
  else
    return []
  endif
endfunction "}}}

let s:source = {
      \ 'name' : '',
      \ 'description' : '',
      \ 'source__base_or_head' : '',
      \ }

function! s:source.gather_candidates(args, context) "{{{
  let selected_repo = empty(a:args) ? '' : a:args[0]
  let base_or_head = self.source__base_or_head
  call s:print_message(a:args, base_or_head)

  let branches = giti#branch#github_list_all()
  let candidates = map(branches, 's:remote2candidate(v:val, base_or_head, selected_repo)')
  let message_candidate = {
        \ 'word': '-- Please select ' . base_or_head. ' repository --',
        \ 'is_selected' : 1,
        \ 'is_dummy' : 1,
        \ }
  call insert(candidates, message_candidate, 0)

  return candidates
endfunction "}}}

function! s:enabled_hub_command() "{{{
  if !exists('s:enabled_hub')
    let s:enabled_hub = system(g:giti_git_command) =~ 'hub'
  endif

  return s:enabled_hub
endfunction "}}}

function! s:define_source(base_or_head) "{{{
  let source = copy(s:source)
  let source.name = 'giti/pull_request/' . a:base_or_head
  let source.description = 'select '. a:base_or_head .' repository'
  let source.source__base_or_head = a:base_or_head

  return source
endfunction "}}}

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
endfunction "}}}

function! s:remote2candidate(branch, base_or_head, selected_repo) "{{{
  let name = a:branch.head_name
  let abbr = printf('%-15s %-35s (%s)', '[' . a:branch.remote.name . ']', name, a:branch.remote.url)

  let [base_repo, head_repo] = a:base_or_head == 'base' ?
        \ [name, a:selected_repo] : [a:selected_repo, name]

  return {
        \ 'word' : name,
        \ 'abbr' : abbr,
        \ 'kind' : 'giti/pull_request',
        \ 'action__base_repo': base_repo,
        \ 'action__head_repo': head_repo
        \ }
endfunction "}}}

function! s:print_message(args, base_or_head) "{{{
  if empty(a:args)
    let message = 'Select ' . a:base_or_head . ' repository'
  elseif a:base_or_head == 'base'
    let message = 'HEAD: ' . a:args[0]
  elseif a:base_or_head == 'head'
    let message = 'BASE: ' . a:args[0]
  endif

  call unite#print_message('[giti/pull_request] ' . message)
endfunction "}}}

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

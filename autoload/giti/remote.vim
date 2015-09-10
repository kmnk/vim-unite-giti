" File:    remote.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

function! giti#remote#show() "{{{
  let ret = giti#system('remote show')
  if type(ret) == 0
    " the operation has canceled
    return []
  endif
  return split(ret, "\n")
endfunction "}}}

function! giti#remote#show_verbose() "{{{
  return split(giti#system('remote --verbose show'), "\n")
endfunction "}}}

function! giti#remote#list_all() "{{{
  let remote_list = []
  for line in giti#remote#show_verbose()
    let remote = {}
    let [remote.name, url_with_type] = split(line, '\t')
    let [remote.url, remote.type] = split(url_with_type, ' ')
    if remote.url =~ 'github\.com.\+\(\.git\)\?' || remote.url =~ '[^/:]\+/[^/:]\+\(\.git\)\?$'
      let github = {}
      let github.full_name = matchstr(remote.url, '\(.\+[/:]\)\@=[^/:]\+/[^/:]\+\(\.git\)\?$')
      let [github.account, github.name] = split(github.full_name, '/')
      let remote.is_github = 1
      let remote.github = github
    else
      let remote.is_github = 0
      let remote.github = {}
    end

    call add(remote_list, remote)
  endfor

  return remote_list
endfunction "}}}

function! giti#remote#github_list() "{{{
  let remote_list = giti#remote#list_all()
  return filter(remote_list, 'v:val.is_github')
endfunction "}}}

function! giti#remote#add(param) "{{{
  if !has_key(a:param, 'name') || strlen(a:param.name) <= 0
    throw 'name required'
  endif
  if !has_key(a:param, 'url') || strlen(a:param.url) <= 0
    throw 'url required'
  endif
  let name = a:param.name
  let url  = a:param.url

  let branch  = has_key(a:param, 'branch') ? a:param.branch : ''
  let master  = has_key(a:param, 'master') ? a:param.master : ''
  let fetch   = has_key(a:param, 'fetch')  ? a:param.fetch  : 0
  let tags    = has_key(a:param, 'tags')   ? a:param.tags   : 0
  let no_tags = !tags && has_key(a:param, 'no_tags') ? a:param.no_tags : 0
  let mirror  = has_key(a:param, 'mirror') ? a:param.mirror : ''

  return giti#system(printf('remote add %s %s %s %s %s %s %s',
\   strlen(branch) > 0 ? '-t ' . branch       : '',
\   strlen(master) > 0 ? '-m ' . master       : '',
\   fetch              ? '-f'                 : '',
\   tags               ? '--tags'
\ : no_tags            ? '--no-tags'          : '',
\   strlen(mirror) > 0 ? '--mirror=' . mirror : '',
\   name,
\   url
\ ))
endfunction "}}}

function! giti#remote#rename(param) "{{{
  if !has_key(a:param, 'old') || strlen(a:param.old) <= 0
    throw 'old required'
  endif
  if !has_key(a:param, 'new') || strlen(a:param.new) <= 0
    throw 'new required'
  endif

  return giti#system_with_specifics({
\   'command' : printf('remote rename %s %s',
\     a:param.old, a:param.new
\   ),
\   'with_confirm' : 1,
\ })
endfunction "}}}

function! giti#remote#rm(name) "{{{
  if strlen(a:name) <= 0
    throw 'name required'
  endif
  return giti#system_with_specifics({
\   'command' : printf('remote rm %s', a:name),
\   'with_confirm' : 1,
\ })
endfunction "}}}

function! giti#remote#prune(param) "{{{
  if !has_key(a:param, 'name') || strlen(a:param.name) <= 0
    throw 'name required'
  endif
  let dry_run = has_key(a:param, 'dry_run') ? a:param.dry_run : 0
  return giti#system_with_specifics({
\   'command' : printf('remote prune %s %s',
\     dry_run ? '--dry-run' : '',
\     a:param.name,
\   ),
\   'with_confirm' : 1,
\ })
endfunction "}}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__

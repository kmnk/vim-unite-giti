function! giti#pull_request#run(base, head) "{{{
  let issue = input('Issue:#')
  if !empty(issue)
    let issue = '-i ' . issue
  endif

  let command = 'pull-request -b '.a:base.' -h ' . a:head . ' ' . issue
  if giti#is_confirmed({ 'command': command })
    let url = s:execute_command(command)
    return url
  endif
endfunction "}}}

function! s:execute_command(command) "{{{
  let old_dir = getcwd()
  let old_editor = $GIT_EDITOR

  try
    let command = []
    let $GIT_EDITOR = $VIM
    call add(command, 'env GIT_EDITOR=vim')
    call add(command, g:giti_git_command .' '. a:command)
    let result = s:execute(join(command, ' '))
  finally
    let $GIT_EDITOR = old_editor
    lcd `=old_dir`
  endtry

  if exists(result)
    return result
  endif
endfunction "}}}

function! s:execute(command) "{{{
  silent! noautocmd execute '!' . a:command
endfunction "}}}

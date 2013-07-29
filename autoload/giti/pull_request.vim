function! giti#pull_request#run(base, head, message) "{{{
  let message_option = empty(a:message) ? '' : string(a:message)
  if empty(message_option)
    let message_option = string(input('Pull-Request message: '))
  endif

  let url = giti#system_with_specifics({
  \ 'command' : 'pull-request -b '.a:base.' -h ' . a:head . ' ' . message_option,
  \ 'with_confirm' : 1
  \ })
  return url
endfunction"}}}

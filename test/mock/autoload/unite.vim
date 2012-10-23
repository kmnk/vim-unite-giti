let s:save_cpo = &cpo
set cpo&vim

" variables {{{
" }}}

function! unite#print_message(message)"{{{
  return 'mocked unite#print_message'
endfunction"}}}

function! unite#custom_action(kind, name, action)"{{{
  return 'mocked unite#custom_action'
endfunction"}}}

" local functions {{{
" }}}


let &cpo = s:save_cpo
unlet s:save_cpo
" __END__

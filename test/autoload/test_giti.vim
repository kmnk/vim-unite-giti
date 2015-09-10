let s:tc = unittest#testcase#new('autoload/giti.vim')

function! s:tc.test_is_git_repository() "{{{
  call self.assert(giti#is_git_repository())
  call self.assert(giti#is_git_repository('./'))
  call self.assert_not(giti#is_git_repository('/foo/bar/baz'))
endfunction "}}}

function! s:tc.test_dir() "{{{
  call self.assert_match('vim-unite-giti/mocked_system',
\                        giti#dir())
  call self.assert_throw('E118', 'call giti#dir("")')
endfunction "}}}

function! s:tc.setup_edit_command() "{{{
  if exists('g:giti_edit_command')
    unlet g:giti_edit_command
  endif
endfunction "}}}
function! s:tc.teardown_edit_command() "{{{
  unlet g:giti_edit_command
endfunction "}}}
function! s:tc.test_edit_command() "{{{
  call self.assert_equal(giti#edit_command(), 'tabnew')
  let g:giti_edit_command = 'hoge'
  call self.assert_equal(giti#edit_command(), 'hoge')
  call self.assert_throw('E118', 'call giti#edit_command("")')
endfunction "}}}

function! s:tc.test_add_ignore() "{{{
  call self.assert_not(giti#add_ignore([]))
  call giti#add_ignore(['hoge', 'fuga'])
  call self.assert_match('gitignore', b:execute_called_with)
  call self.assert_equal(["hoge\nfuga", ''], b:put_called_with_list)
  call self.assert_throw('E118', 'call giti#add_ignore("", "")')
  call self.assert_throw('E119', 'call giti#add_ignore()')
endfunction "}}}

function! s:tc.setup_new_buffer() "{{{
  if exists('g:giti_edit_command')
    unlet g:giti_edit_command
  endif
endfunction "}}}
function! s:tc.teardown_new_buffer() "{{{
  unlet g:giti_edit_command
endfunction "}}}
function! s:tc.test_new_buffer() "{{{
  call self.assert(giti#new_buffer({}))
  call self.assert_equal(b:execute_called_with, 'delete')
  call giti#new_buffer({'method' : 'foo'})
  call self.assert_equal(b:execute_called_with, 'delete')
  call giti#new_buffer({'method' : 'foo', 'file' : 'hoge fuga'})
  call self.assert_equal(b:execute_called_with, 'delete')

  call giti#new_buffer({'string' : 'bar'})
  call self.assert_equal(b:put_called_with_list, ['bar', ''])

  call giti#new_buffer({'filetype' : 'baz'})
  call self.assert_equal(b:execute_called_with, 'setlocal filetype=baz')

  call giti#new_buffer({'buftype' : 'qux'})
  call self.assert_equal(b:execute_called_with, 'setlocal buftype=qux')

  call self.assert_throw('E118', 'call giti#new_buffer("", "")')
  call self.assert_throw('E119', 'call giti#new_buffer()')
endfunction "}}}

unlet s:tc

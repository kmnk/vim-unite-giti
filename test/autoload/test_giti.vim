let s:tc = unittest#testcase#new('autoload/giti.vim')

function! s:tc.test_is_git_repository()"{{{
  call self.assert(giti#is_git_repository())
  call self.assert(giti#is_git_repository('./'))
  call self.assert_not(giti#is_git_repository('/foo/bar/baz'))
endfunction"}}}

function! s:tc.setup_system()"{{{
  let paths = split(globpath(&rtp, 'autoload/giti.vim'), '\n')
  execute 'source ' . paths[0]
endfunction"}}}
function! s:tc.teardown_system()"{{{
  function! giti#system(command)"{{{
    let b:system_called_with = a:command
    return 'mocked_system'
  endfunction"}}}
endfunction"}}}
function! s:tc.test_system()"{{{
  call self.assert_match('git version \d\+\.\d\+\.\d\+',
\                        giti#system('version'))
  call self.assert_throw('System error: git hoge', 'call giti#system("hoge")')
endfunction"}}}

function! s:tc.setup_system_with_specifics()"{{{
  let paths = split(globpath(&rtp, 'autoload/giti.vim'), '\n')
  execute 'source ' . paths[0]
endfunction"}}}
function! s:tc.teardown_system_with_specifics()"{{{
  function! giti#system_with_specifics(arg)"{{{
    let b:system_with_specifics_called_with = a:arg
    return 'mocked_system_with_specifics'
  endfunction"}}}
endfunction"}}}
function! s:tc.test_system_with_specifics()"{{{
  call self.assert_match('git version \d\+\.\d\+\.\d\+',
\                        giti#system_with_specifics({
\                           'command' : 'version',
\                           'ignore_error' : 1,
\                        }))
  call self.assert_match('not a git command',
\                        giti#system_with_specifics({
\                          'command' : 'hoge',
\                          'ignore_error' : 1,
\                        }))
  call self.assert_throw('E118', 'call giti#system_with_specifics("", "")')
  call self.assert_throw('E119', 'call giti#system_with_specifics()')
endfunction"}}}

function! s:tc.test_dir()"{{{
  call self.assert_match('vim-unite-giti/mocked_system',
\                        giti#dir())
  call self.assert_throw('E118', 'call giti#dir("")')
endfunction"}}}

function! s:tc.setup_edit_command()"{{{
  if exists('g:giti_edit_command')
    unlet g:giti_edit_command
  endif
endfunction"}}}
function! s:tc.teardown_edit_command()"{{{
  unlet g:giti_edit_command
endfunction"}}}
function! s:tc.test_edit_command()"{{{
  call self.assert_equal(giti#edit_command(), 'tabnew')
  let g:giti_edit_command = 'hoge'
  call self.assert_equal(giti#edit_command(), 'hoge')
  call self.assert_throw('E118', 'call giti#edit_command("")')
endfunction"}}}

function! s:tc.test_add_ignore()"{{{
  call self.assert_not(giti#add_ignore([]))
  call giti#add_ignore(['hoge', 'fuga'])
  call self.assert_match('gitignore', b:execute_called_with)
  call self.assert_equal(["hoge\nfuga", ''], b:put_called_with_list)
  call self.assert_throw('E118', 'call giti#add_ignore("", "")')
  call self.assert_throw('E119', 'call giti#add_ignore()')
endfunction"}}}

function! s:tc.setup_new_buffer()"{{{
  if exists('g:giti_edit_command')
    unlet g:giti_edit_command
  endif
endfunction"}}}
function! s:tc.teardown_new_buffer()"{{{
  unlet g:giti_edit_command
endfunction"}}}
function! s:tc.test_new_buffer()"{{{
  call self.assert(giti#new_buffer({}))
  call self.assert_equal(b:execute_called_with, 'tabnew')
  call giti#new_buffer({'method' : 'foo'})
  call self.assert_equal(b:execute_called_with, 'foo')

  call giti#new_buffer({'string' : 'bar'})
  call self.assert_equal(b:put_called_with_list, ['bar', 1])

  call giti#new_buffer({'filetype' : 'baz'})
  call self.assert_equal(b:execute_called_with, 'setlocal filetype=baz')

  call giti#new_buffer({'buftype' : 'qux'})
  call self.assert_equal(b:execute_called_with, 'setlocal buftype=qux')

  call self.assert_throw('E118', 'call giti#new_buffer("", "")')
  call self.assert_throw('E119', 'call giti#new_buffer()')
endfunction"}}}

unlet s:tc

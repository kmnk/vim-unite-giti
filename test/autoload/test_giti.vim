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
  call self.assert_throw('Vim(echoerr)', 'call giti#system("hoge")')
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
  call self.assert_match('hoge', b:put_called_with)
  call self.assert_throw('E118', 'call giti#add_ignore("", "")')
  call self.assert_throw('E119', 'call giti#add_ignore()')
endfunction"}}}

unlet s:tc

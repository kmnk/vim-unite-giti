let s:tc = unittest#testcase#new('autoload/giti/diff_tree.vim',
\                                unite#kinds#giti#branch#__context__())

function! s:tc.SETUP() "{{{
endfunction "}}}
function! s:tc.TEARDOWN() "{{{
endfunction "}}}

function! s:tc.setup_changed_files() "{{{
  function! giti#system(command) "{{{
    let b:system_called_with = a:command
    return "hoge\nfuga\npiyo"
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_changed_files() "{{{
  function! giti#system(command) "{{{
    let b:system_called_with = a:command
    return 'mocked_system'
  endfunction "}}}
endfunction "}}}
function! s:tc.test_changed_files() "{{{
  let arg = { 'from' : 'foo', 'to' : 'bar' }
  call self.assert_equal(
\   giti#diff_tree#changed_files(arg),
\   ['hoge', 'fuga', 'piyo']
\ )
  call self.assert_equal(b:system_called_with,
\                        printf('diff-tree -r --name-only --no-commit-id %s..%s',
\                               arg.from, arg.to))

  let arg = { 'from' : 'foo', 'to' : 'foo' }
  call self.assert_equal(
\   giti#diff_tree#changed_files(arg),
\   ['hoge', 'fuga', 'piyo']
\ )
  call self.assert_equal(b:system_called_with,
\                        printf('diff-tree -r --name-only --no-commit-id %s', arg.from))

  let arg = { 'from' : '', 'to' : 'foo' }
  call self.assert_equal(
\   giti#diff_tree#changed_files(arg),
\   ['hoge', 'fuga', 'piyo']
\ )
  call self.assert_equal(b:system_called_with,
\                        printf('diff-tree -r --name-only --no-commit-id %s', arg.to))

  call self.assert_throw('E119', 'call giti#diff_tree#changed_files()')
  call self.assert_throw('E118', 'call giti#diff_tree#changed_files("", "")')
endfunction "}}}

unlet s:tc

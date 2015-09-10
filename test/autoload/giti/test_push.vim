let s:tc = unittest#testcase#new('arg/giti/push.vim')

function! s:tc.SETUP() "{{{
endfunction "}}}
function! s:tc.TEARDOWN() "{{{
endfunction "}}}

function! s:tc.test_run() "{{{
  call self.assert_equal(
\   giti#push#run({
\     'repository' : 'hoge',
\     'refspec'    : 'fuga',
\   }),
\   'mocked_system_with_specifics',
\ )
  call self.assert_equal(b:system_with_specifics_called_with,
\                        {'command' : 'push hoge fuga', 'with_confirm' : 1})
  call giti#push#run({})
  call self.assert_equal(b:system_with_specifics_called_with,
\                        {'command' : 'push  ', 'with_confirm' : 1})
  call giti#push#run({ 'repository' : 'hoge' })
  call self.assert_equal(b:system_with_specifics_called_with,
\                        {'command' : 'push hoge ', 'with_confirm' : 1})
  call giti#push#run({ 'refspec' : 'fuga' })
  call self.assert_equal(b:system_with_specifics_called_with,
\                        {'command' : 'push  fuga', 'with_confirm' : 1})
  call self.assert_throw('E118', 'call giti#push#run("", "")')
  call self.assert_throw('E119', 'call giti#push#run()')
endfunction "}}}

function! s:tc.test_set_upstream() "{{{
  call self.assert_equal(
\   giti#push#set_upstream({
\     'repository' : 'hoge',
\     'refspec'    : 'fuga',
\   }),
\   'mocked_system_with_specifics',
\ )
  call self.assert_equal(b:system_with_specifics_called_with,
\                        {'command' : 'push -u hoge fuga', 'with_confirm' : 1})
  call giti#push#set_upstream({})
  call self.assert_equal(b:system_with_specifics_called_with,
\                        {'command' : 'push -u  ', 'with_confirm' : 1})
  call giti#push#set_upstream({ 'repository' : 'hoge' })
  call self.assert_equal(b:system_with_specifics_called_with,
\                        {'command' : 'push -u hoge ', 'with_confirm' : 1})
  call giti#push#set_upstream({ 'refspec' : 'fuga' })
  call self.assert_equal(b:system_with_specifics_called_with,
\                        {'command' : 'push -u  fuga', 'with_confirm' : 1})
  call self.assert_throw('E118', 'call giti#push#set_upstream("", "")')
  call self.assert_throw('E119', 'call giti#push#set_upstream()')
endfunction "}}}

function! s:tc.test_delete_remote_branch() "{{{
  call self.assert_equal(
\   giti#push#delete_remote_branch({
\     'repository' : 'hoge',
\     'branch'     : 'fuga',
\   }),
\   'mocked_system_with_specifics',
\ )
  call self.assert_equal(b:system_with_specifics_called_with,
\                        {'command' : 'push hoge :fuga', 'with_confirm' : 1})
  call self.assert_throw('branch required', '
\   call giti#push#delete_remote_branch({
\     "repository" : "hoge",
\   })
\ ')
  call self.assert_throw('branch required', '
\   call giti#push#delete_remote_branch({
\     "repository" : "hoge",
\     "branch"     : "",
\   })
\ ')

  call self.assert_throw('E118', 'call giti#push#delete_remote_branch("", "")')
  call self.assert_throw('E119', 'call giti#push#delete_remote_branch()')
endfunction "}}}

unlet s:tc

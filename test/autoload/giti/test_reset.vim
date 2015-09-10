let s:tc = unittest#testcase#new('autoload/giti/reset.vim')

function! s:tc.SETUP() "{{{
endfunction "}}}
function! s:tc.TEARDOWN() "{{{
endfunction "}}}

function! s:tc.test_hard() "{{{
  call self.assert_equal(
\   giti#reset#hard({
\     'hash'  : 'hoge',
\     'files' : ['foo', 'bar'],
\   }),
\   'mocked_system_with_specifics',
\ )
  call self.assert_equal(b:system_with_specifics_called_with,
\                        {'command' : 'reset --hard hoge foo bar', 'with_confirm' : 1})
  call giti#reset#hard({'hash' : 'hoge'})
  call self.assert_equal(b:system_with_specifics_called_with,
\                        {'command' : 'reset --hard hoge ', 'with_confirm' : 1})
  call giti#reset#hard({'hash' : 'hoge', 'files' : []})
  call self.assert_equal(b:system_with_specifics_called_with,
\                        {'command' : 'reset --hard hoge ', 'with_confirm' : 1})
  call self.assert_throw('E118', 'call giti#reset#head("", "")')
  call self.assert_throw('E119', 'call giti#reset#head()')
endfunction "}}}

function! s:tc.head() "{{{
  call self.assert_equal(giti#reset#head({'files' : ['foo', 'bar']}),
\                        'mocked_system')
  call self.assert_equal(b:system_called_with,
\                        'reset HEAD foo bar')
  call giti#reset#head({})
  call self.assert_equal(b:system_called_with,
\                        'reset HEAD .')
  call giti#reset#head({'files' : []})
  call self.assert_equal(b:system_called_with,
\                        'reset HEAD .')
  call self.assert_throw('E118', 'call giti#reset#hard("", "")')
  call self.assert_throw('E119', 'call giti#reset#hard()')
endfunction "}}}

unlet s:tc

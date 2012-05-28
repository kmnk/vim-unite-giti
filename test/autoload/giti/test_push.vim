let s:tc = unittest#testcase#new('arg/giti/push.vim')

function! s:tc.SETUP()"{{{
endfunction"}}}
function! s:tc.TEARDOWN()"{{{
endfunction"}}}

function! s:tc.test_run()"{{{
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
endfunction"}}}

unlet s:tc

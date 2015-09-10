let s:tc = unittest#testcase#new('autoload/giti/rm.vim')

function! s:tc.SETUP() "{{{
endfunction "}}}
function! s:tc.TEARDOWN() "{{{
endfunction "}}}

function! s:tc.test_run() "{{{
  call self.assert_equal(giti#rm#run({'files' : ['hoge', 'fuga']}),
\                        'mocked_system_with_specifics')
  call self.assert_equal(
\   b:system_with_specifics_called_with,
\   {
\     'command'      : 'rm -- hoge fuga',
\     'with_confirm' : 1,
\   }
\ )
  call self.assert_throw('E118', 'call giti#rm#run("", "")')
  call self.assert_throw('E119', 'call giti#rm#run()')
endfunction "}}}

function! s:tc.test_cached() "{{{
  call self.assert_equal(giti#rm#cached({'files' : ['hoge', 'fuga']}),
\                        'mocked_system_with_specifics')
  call self.assert_equal(
\   b:system_with_specifics_called_with,
\   {
\     'command'      : 'rm --cached -- hoge fuga',
\     'with_confirm' : 1,
\   }
\ )
  call self.assert_throw('E118', 'call giti#rm#cached("", "")')
  call self.assert_throw('E119', 'call giti#rm#cached()')
endfunction "}}}

unlet s:tc

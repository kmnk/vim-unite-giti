let s:tc = unittest#testcase#new('autoload/giti/revert.vim')

function! s:tc.SETUP() "{{{
endfunction "}}}
function! s:tc.TEARDOWN() "{{{
  setlocal filetype=unittest bufhidden=hide
endfunction "}}}

function! s:tc.test_run() "{{{
  call giti#revert#run(['hoge', 'fuga'])
  call self.assert_equal(
\   b:system_with_specifics_called_with,
\   {
\     'command' : 'revert hoge fuga',
\     'ignore_error' : 1,
\   },
\ )
  call self.assert_throw('E118', 'call giti#revert#run("", "")')
  call self.assert_throw('E119', 'call giti#revert#run()')
endfunction "}}}

unlet s:tc

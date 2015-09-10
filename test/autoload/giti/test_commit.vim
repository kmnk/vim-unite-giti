let s:tc = unittest#testcase#new('autoload/giti/commit.vim')

function! s:tc.SETUP() "{{{
endfunction "}}}
function! s:tc.TEARDOWN() "{{{
  setlocal filetype=unittest bufhidden=hide
endfunction "}}}

function! s:tc.test_run() "{{{
  call giti#commit#run(['hoge', 'fuga'])
  call self.assert_equal(
\   b:system_with_specifics_called_with,
\   {
\     'command' : 'commit -- hoge fuga',
\     'ignore_error' : 1,
\   }
\ )
  call self.assert_throw('E118', 'call giti#commit#run("", "")')
  call self.assert_throw('E119', 'call giti#commit#run()')
endfunction "}}}

function! s:tc.test_dry_run() "{{{
  call giti#commit#dry_run(['hoge', 'fuga'])
  call self.assert_equal(
\   b:system_with_specifics_called_with,
\   {
\     'command' : 'commit --dry-run -- hoge fuga',
\     'ignore_error' : 1,
\   }
\ )
  call self.assert_throw('E118', 'call giti#commit#dry_run("", "")')
  call self.assert_throw('E119', 'call giti#commit#dry_run()')
endfunction "}}}


function! s:tc.test_amend() "{{{
  call giti#commit#amend(['hoge', 'fuga'])
  call self.assert_equal(
\   b:system_with_specifics_called_with,
\   {
\     'command' : 'commit --amend -- hoge fuga',
\     'ignore_error' : 1,
\   }
\ )
  call self.assert_throw('E118', 'call giti#commit#amend("", "")')
  call self.assert_throw('E119', 'call giti#commit#amend()')
endfunction "}}}

unlet s:tc

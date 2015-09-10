let s:tc = unittest#testcase#new('autoload/giti/merge.vim')

function! s:tc.SETUP() "{{{
endfunction "}}}
function! s:tc.TEARDOWN() "{{{
endfunction "}}}

function! s:tc.test_run() "{{{
  call self.assert_equal(giti#merge#run({'branch_name' : 'hoge'}),
\                        'mocked_system_with_specifics')
  call self.assert_equal(b:system_with_specifics_called_with, {
\   'command' : 'merge  hoge'
\ })

  call self.assert_equal(giti#merge#run({'branch_name' : 'hoge', 'squash' : 1}),
\                        'mocked_system_with_specifics')
  call self.assert_equal(b:system_with_specifics_called_with, {
\   'command' : 'merge --squash hoge'
\ })

  call self.assert_throw('branch_name required',
\                        'call giti#merge#run({})')

  call self.assert_throw('E118', 'call giti#merge#run("", "")')
  call self.assert_throw('E119', 'call giti#merge#run()')
endfunction "}}}

unlet s:tc

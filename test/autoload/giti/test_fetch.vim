let s:tc = unittest#testcase#new('autoload/giti/fetch.vim')

function! s:tc.SETUP() "{{{
endfunction "}}}
function! s:tc.TEARDOWN() "{{{
endfunction "}}}

function! s:tc.test_run() "{{{
  call self.assert_equal(giti#fetch#run(), 'mocked_system')
  call self.assert_equal(b:system_called_with, 'fetch ')
  call giti#fetch#run({})
  call self.assert_equal(b:system_called_with, 'fetch ')
  call giti#fetch#run({ 'repository' : 'hoge' })
  call self.assert_equal(b:system_called_with, 'fetch hoge')
endfunction "}}}

unlet s:tc

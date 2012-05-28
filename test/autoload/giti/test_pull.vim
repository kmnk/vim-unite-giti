let s:tc = unittest#testcase#new('autoload/giti/pull.vim')

function! s:tc.SETUP()"{{{
endfunction"}}}
function! s:tc.TEARDOWN()"{{{
endfunction"}}}

function! s:tc.test_pull()"{{{
  call self.assert_equal(
\   giti#pull#run({
\     'repository' : 'hoge',
\     'refspec'    : 'fuga',
\   }),
\   'mocked_system_with_specifics',
\ )
  call self.assert(1)
endfunction"}}}

unlet s:tc

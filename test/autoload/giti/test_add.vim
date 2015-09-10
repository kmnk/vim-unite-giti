let s:tc = unittest#testcase#new('autoload/giti/add.vim')

function! s:tc.test_run() "{{{
  call giti#add#run(['hoge', 'fuga'])
  call self.assert_match('add hoge fuga', b:system_called_with)
  call self.assert_throw('E118', 'call giti#add#run("", "")')
  call self.assert_throw('E119', 'call giti#add#run()')
endfunction "}}}

function! s:tc.test_patch() "{{{
  call giti#add#patch(['hoge', 'fuga'])
  call self.assert_match('! git add -p hoge fuga', b:execute_called_with)
  call self.assert_throw('E118', 'call giti#add#patch("", "")')
  call self.assert_throw('E119', 'call giti#add#patch()')
endfunction "}}}

unlet s:tc

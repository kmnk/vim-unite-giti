let s:tc = unittest#testcase#new('autoload/giti/add.vim')

function! s:tc.test_run()"{{{
  call giti#add#run(['hoge', 'fuga'])
  call self.assert_match('add hoge fuga', b:system_called_with)
  call self.assert_throw('E118', 'call giti#add#run("", "")')
  call self.assert_throw('E119', 'call giti#add#run()')
endfunction"}}}

unlet s:tc

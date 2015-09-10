let s:tc = unittest#testcase#new('autoload/giti/rebase.vim')

function! s:tc.test_run() "{{{
  call self.assert_equal('mocked_system_with_specifics',
\                        giti#rebase#run({'upstream' : 'hoge',
\                                         'onto'     : 'fuga'}))
  call self.assert_equal({'command' : 'rebase --onto fuga hoge',
\                         'with_confirm' : 1},
\                        b:system_with_specifics_called_with)

  call giti#rebase#run({'upstream' : 'hoge'})
  call self.assert_equal({'command' : 'rebase  hoge',
\                         'with_confirm' : 1},
\                        b:system_with_specifics_called_with)

  call giti#rebase#run({'onto' : 'fuga'})
  call self.assert_equal({'command' : 'rebase --onto fuga ',
\                         'with_confirm' : 1},
\                        b:system_with_specifics_called_with)

  call giti#rebase#run({})
  call self.assert_equal({'command' : 'rebase  ',
\                         'with_confirm' : 1},
\                        b:system_with_specifics_called_with)

  call self.assert_throw('E118', 'call giti#rebase#run("", "")')
  call self.assert_throw('E119', 'call giti#rebase#run()')
endfunction "}}}

function! s:tc.test_interactive() "{{{
  call self.assert_equal('mocked_execute',
\                        giti#rebase#interactive({'upstream' : 'hoge',
\                                                 'onto'     : 'fuga'}))
  call self.assert_equal('! git rebase -i --onto fuga hoge', b:execute_called_with)

  call giti#rebase#interactive({'upstream' : 'hoge'})
  call self.assert_match('! git rebase -i  hoge', b:execute_called_with)

  call giti#rebase#interactive({'onto' : 'fuga'})
  call self.assert_equal('! git rebase -i --onto fuga ', b:execute_called_with)

  call giti#rebase#interactive({})
  call self.assert_equal('! git rebase -i  ', b:execute_called_with)

  call self.assert_throw('E118', 'call giti#rebase#interactive("", "")')
  call self.assert_throw('E119', 'call giti#rebase#interactive()')
endfunction "}}}

function! s:tc.test_continue() "{{{
  call self.assert_equal('mocked_system', giti#rebase#continue())
  call self.assert_equal('rebase --continue', b:system_called_with)
  call self.assert_throw('E118', 'call giti#rebase#continue("")')
endfunction "}}}

function! s:tc.test_skip() "{{{
  call self.assert_equal('mocked_system', giti#rebase#skip())
  call self.assert_equal('rebase --skip', b:system_called_with)
  call self.assert_throw('E118', 'call giti#rebase#skip("")')
endfunction "}}}

function! s:tc.test_abort() "{{{
  call self.assert_equal('mocked_system', giti#rebase#abort())
  call self.assert_equal('rebase --abort', b:system_called_with)
  call self.assert_throw('E118', 'call giti#rebase#abort("")')
endfunction "}}}

unlet s:tc

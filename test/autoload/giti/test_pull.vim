let s:tc = unittest#testcase#new('autoload/giti/pull.vim')

function! s:tc.SETUP() "{{{
endfunction "}}}
function! s:tc.TEARDOWN() "{{{
endfunction "}}}

function! s:tc.test_run() "{{{
  call self.assert_equal(
\   giti#pull#run({
\     'repository' : 'hoge',
\     'refspec'    : 'fuga',
\   }),
\   'mocked_system_with_specifics',
\ )
  call self.assert_equal(b:system_with_specifics_called_with,
\                        {'command' : 'pull hoge fuga', 'with_confirm' : 1})
  call giti#pull#run({})
  call self.assert_equal(b:system_with_specifics_called_with,
\                        {'command' : 'pull  ', 'with_confirm' : 1})
  call giti#pull#run({ 'repository' : 'hoge' })
  call self.assert_equal(b:system_with_specifics_called_with,
\                        {'command' : 'pull hoge ', 'with_confirm' : 1})
  call giti#pull#run({ 'refspec' : 'fuga' })
  call self.assert_equal(b:system_with_specifics_called_with,
\                        {'command' : 'pull  fuga', 'with_confirm' : 1})
  call self.assert_throw('E118', 'call giti#pull#run("", "")')
  call self.assert_throw('E119', 'call giti#pull#run()')
endfunction "}}}

function! s:tc.test_squash() "{{{
  call self.assert_equal(
\   giti#pull#squash({
\     'repository' : 'hoge',
\     'refspec'    : 'fuga',
\   }),
\   'mocked_system_with_specifics',
\ )
  call self.assert_equal(b:system_with_specifics_called_with,
\                        {'command'      : 'pull --squash hoge fuga',
\                         'with_confirm' : 1})
  call giti#pull#squash({})
  call self.assert_equal(b:system_with_specifics_called_with,
\                        {'command'      : 'pull --squash  ',
\                         'with_confirm' : 1})
  call giti#pull#squash({ 'repository' : 'hoge' })
  call self.assert_equal(b:system_with_specifics_called_with,
\                        {'command'      : 'pull --squash hoge ',
\                         'with_confirm' : 1})
  call giti#pull#squash({ 'refspec' : 'fuga' })
  call self.assert_equal(b:system_with_specifics_called_with,
\                        {'command'      : 'pull --squash  fuga',
\                         'with_confirm' : 1})
  call self.assert_throw('E118', 'call giti#pull#squash("", "")')
  call self.assert_throw('E119', 'call giti#pull#squash()')
endfunction "}}}

function! s:tc.test_rebase() "{{{
  call self.assert_equal(
\   giti#pull#rebase({
\     'repository' : 'hoge',
\     'refspec'    : 'fuga',
\   }),
\   'mocked_system_with_specifics',
\ )
  call self.assert_equal(b:system_with_specifics_called_with,
\                        {'command'      : 'pull --rebase hoge fuga',
\                         'with_confirm' : 1})
  call giti#pull#rebase({})
  call self.assert_equal(b:system_with_specifics_called_with,
\                        {'command'      : 'pull --rebase  ',
\                         'with_confirm' : 1})
  call giti#pull#rebase({ 'repository' : 'hoge' })
  call self.assert_equal(b:system_with_specifics_called_with,
\                        {'command'      : 'pull --rebase hoge ',
\                         'with_confirm' : 1})
  call giti#pull#rebase({ 'refspec' : 'fuga' })
  call self.assert_equal(b:system_with_specifics_called_with,
\                        {'command'      : 'pull --rebase  fuga',
\                         'with_confirm' : 1})
  call self.assert_throw('E118', 'call giti#pull#rebase("", "")')
  call self.assert_throw('E119', 'call giti#pull#rebase()')
endfunction "}}}

unlet s:tc

let s:tc = unittest#testcase#new('autoload/giti/stash.vim')

function! s:tc.SETUP()"{{{
endfunction"}}}
function! s:tc.TEARDOWN()"{{{
endfunction"}}}

function! s:tc.test_list()"{{{
  call self.assert_equal('mocked_system', giti#stash#list())
  call self.assert_equal('stash list', b:system_called_with)
  call self.assert_throw('E118', 'call giti#stash#list("")')
endfunction"}}}

function! s:tc.setup_built_list()"{{{
  function! giti#system(command)"{{{
    let b:system_called_with = a:command
    return '::stash@{012}::aaaa::cccc<cc@cc.cc>[cc/cc/cc cc:cc:cc]::dddd<dd@dd.dd>[dd/dd/dd dd:dd:dd]::eeee'
  endfunction"}}}
endfunction
function! s:tc.teardown_built_list()"{{{
  function! giti#system(command)"{{{
    let b:system_called_with = a:command
    return 'mocked_system'
  endfunction"}}}
endfunction
function! s:tc.test_built_list()"{{{
  call self.assert_equal(giti#stash#built_list(), [{
\   'stash'     : 'stash@{012}',
\   'hash'      : 'aaaa',
\   'author'    : {'name' : 'cccc', 'mail' : 'cc@cc.cc', 'date' : 'cc/cc/cc cc:cc:cc'},
\   'committer' : {'name' : 'dddd', 'mail' : 'dd@dd.dd', 'date' : 'dd/dd/dd dd:dd:dd'},
\   'comment'   : 'eeee',
\ }])
  call self.assert_match(
\   'stash list --date=relative --pretty=format:".\+"',
\   b:system_called_with
\ )
  call self.assert_throw('E118', 'call giti#stash#built_list("")')
endfunction"}}}

function! s:tc.test_show()"{{{
  call self.assert_equal(giti#stash#show({'stash' : 'hoge'}), 'mocked_system')
  call self.assert_equal('stash show hoge', b:system_called_with)
  call self.assert_equal(giti#stash#show({}), 'mocked_system')
  call self.assert_equal('stash show ', b:system_called_with)
  call self.assert_throw('E118', 'call giti#stash#show("", "")')
  call self.assert_throw('E119', 'call giti#stash#show()')
endfunction"}}}

function! s:tc.test_drop()"{{{
  call self.assert_equal(giti#stash#drop({'stash' : 'hoge'}), 'mocked_system')
  call self.assert_equal('stash drop hoge', b:system_called_with)
  call self.assert_equal(giti#stash#drop({}), 'mocked_system')
  call self.assert_equal('stash drop ', b:system_called_with)
  call self.assert_throw('E118', 'call giti#stash#drop("", "")')
  call self.assert_throw('E119', 'call giti#stash#drop()')
endfunction"}}}

function! s:tc.test_pop()"{{{
  call self.assert_equal(giti#stash#pop({'stash' : 'hoge'}), 'mocked_system')
  call self.assert_equal('stash pop hoge', b:system_called_with)
  call self.assert_equal(giti#stash#pop({}), 'mocked_system')
  call self.assert_equal('stash pop ', b:system_called_with)
  call self.assert_throw('E118', 'call giti#stash#pop("", "")')
  call self.assert_throw('E119', 'call giti#stash#pop()')
endfunction"}}}

function! s:tc.test_apply()"{{{
  call self.assert_equal(giti#stash#apply({'stash' : 'hoge'}), 'mocked_system')
  call self.assert_equal('stash apply hoge', b:system_called_with)
  call self.assert_equal(giti#stash#apply({}), 'mocked_system')
  call self.assert_equal('stash apply ', b:system_called_with)
  call self.assert_throw('E118', 'call giti#stash#apply("", "")')
  call self.assert_throw('E119', 'call giti#stash#apply()')
endfunction"}}}

function! s:tc.test_branch()"{{{
  call self.assert_equal(
\   giti#stash#branch({'stash' : 'hoge', 'branchname' : 'fuga'}),
\   'mocked_system'
\ )
  call self.assert_equal('stash branch fuga hoge', b:system_called_with)
  call self.assert_equal(giti#stash#branch({'branchname' : 'fuga'}), 'mocked_system')
  call self.assert_equal('stash branch fuga ', b:system_called_with)
  call self.assert_throw('branchname required', 'call giti#stash#branch({})')
  call self.assert_throw('E118', 'call giti#stash#branch("", "")')
  call self.assert_throw('E119', 'call giti#stash#branch()')
endfunction"}}}

function! s:tc.test_save()"{{{
  call self.assert(1)
endfunction"}}}

function! s:tc.test_clear()"{{{
  call self.assert(1)
endfunction"}}}

unlet s:tc

let s:tc = unittest#testcase#new('autoload/giti/branch.vim')

function! s:tc.SETUP() "{{{
  function! giti#checkout#create(param) "{{{
    let b:checkout_create_called_with = a:param
    return 'mocked_checkout_create'
  endfunction "}}}
  function! giti#checkout#switch(param) "{{{
    let b:checkout_switch_called_with = a:param
    return 'mocked_checkout_switch'
  endfunction "}}}
  function! giti#push#delete_remote_branch(branch) "{{{
    let b:push_delete_remote_branch_called_with = a:branch
    return 'mocked_push_delete_remote_branch'
  endfunction "}}}
endfunction "}}}
function! s:tc.TEARDOWN() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/checkout.vim'), '\n')
  execute 'source ' . paths[0]
  let paths = split(globpath(&rtp, 'autoload/giti/push.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}

function! s:tc.test_list() "{{{
  call self.assert_equal(
\   [{
\     'full_name'  : 'mocked_system',
\     'name'       : 'mocked_system',
\     'is_current' : 0,
\     'is_remote'  : 0,
\   }],
\   giti#branch#list(),
\ )
  call self.assert_equal('branch', b:system_called_with)
  call self.assert_throw('E118', 'call giti#branch#list("")')
endfunction "}}}

function! s:tc.test_list_all() "{{{
  call self.assert_equal(
\   [{
\     'full_name'  : 'mocked_system',
\     'name'       : 'mocked_system',
\     'is_current' : 0,
\     'is_remote'  : 0,
\   }],
\   giti#branch#list_all(),
\ )
  call self.assert_equal('branch -a', b:system_called_with)
  call self.assert_throw('E118', 'call giti#branch#list_all("")')
endfunction "}}}

function! s:tc.test_delete() "{{{
  call self.assert_equal(giti#branch#delete(['hoge', 'fuga']), 'mocked_system_with_specifics')
  call self.assert_equal({'command' : 'branch -d hoge fuga', 'with_confirm' : 1},
\                        b:system_with_specifics_called_with)
  call self.assert_throw('E118', 'call giti#branch#delete("", "")')
  call self.assert_throw('E119', 'call giti#branch#delete()')
endfunction "}}}

function! s:tc.test_delete_force() "{{{
  call self.assert_equal(giti#branch#delete_force(['hoge', 'fuga']), 'mocked_system_with_specifics')
  call self.assert_equal({'command' : 'branch -D hoge fuga', 'with_confirm' : 1},
\                        b:system_with_specifics_called_with)
  call self.assert_throw('E118', 'call giti#branch#delete_force("", "")')
  call self.assert_throw('E119', 'call giti#branch#delete_force()')
endfunction "}}}

function! s:tc.test_delete_remote() "{{{
  call self.assert_equal(
\   giti#branch#delete_remote([
\     {'repository' : 'hoge', 'branch' : 'hoge'},
\     {'repository' : 'fuga', 'branch' : 'fuga'}
\   ]),
\   ['mocked_push_delete_remote_branch',
\    'mocked_push_delete_remote_branch']
\ )
  call self.assert_equal(b:push_delete_remote_branch_called_with,
\                        {'repository' : 'fuga', 'branch' : 'fuga'})
  call self.assert_not(giti#branch#delete_remote([]))
  call self.assert_throw('branch required', '
\   call giti#branch#delete_remote([{}])
\ ')
  call self.assert_throw('branch required', '
\   call giti#branch#delete_remote([{"branch" : ""}])
\ ')
  call self.assert_throw('E118', 'call giti#branch#delete_remote("", "")')
  call self.assert_throw('E119', 'call giti#branch#delete_remote()')
endfunction "}}}

function! s:tc.test_create() "{{{
  call self.assert_equal(giti#branch#create('hoge'), 'mocked_checkout_create')
  echo b:checkout_create_called_with
  call self.assert_equal(b:checkout_create_called_with, {'name' : 'hoge'})
  call self.assert_throw('E118', 'call giti#branch#create("", "")')
  call self.assert_throw('E119', 'call giti#branch#create()')
endfunction "}}}

function! s:tc.test_switch() "{{{
  call self.assert_equal(giti#branch#switch('hoge'), 'mocked_checkout_switch')
  call self.assert_equal(b:checkout_switch_called_with, {'name' : 'hoge'})
  call self.assert_throw('E118', 'call giti#branch#switch("", "")')
  call self.assert_throw('E119', 'call giti#branch#switch()')
endfunction "}}}

unlet s:tc

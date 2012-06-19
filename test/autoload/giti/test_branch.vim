let s:tc = unittest#testcase#new('autoload/giti/branch.vim')

function! s:tc.SETUP()"{{{
  function! giti#checkout#create(branch)"{{{
    return 'mocked_checkout_create'
  endfunction"}}}
  function! giti#checkout#switch(branch)"{{{
    return 'mocked_checkout_switch'
  endfunction"}}}
endfunction"}}}
function! s:tc.TEARDOWN()"{{{
  let paths = split(globpath(&rtp, 'autoload/giti/checkout.vim'), '\n')
  execute 'source ' . paths[0]
endfunction"}}}

function! s:tc.test_list()"{{{
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
endfunction"}}}

function! s:tc.test_list_all()"{{{
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
endfunction"}}}

function! s:tc.test_delete()"{{{
  call self.assert_equal(giti#branch#delete('hoge'), 'mocked_system_with_specifics')
  call self.assert_equal({'command' : 'branch -d hoge', 'with_confirm' : 1},
\                        b:system_with_specifics_called_with)
  call self.assert_throw('E118', 'call giti#branch#delete("", "")')
  call self.assert_throw('E119', 'call giti#branch#delete()')
endfunction"}}}

function! s:tc.test_delete_force()"{{{
  call self.assert_equal(giti#branch#delete_force('hoge'), 'mocked_system_with_specifics')
  call self.assert_equal({'command' : 'branch -D hoge', 'with_confirm' : 1},
\                        b:system_with_specifics_called_with)
  call self.assert_throw('E118', 'call giti#branch#delete_force("", "")')
  call self.assert_throw('E119', 'call giti#branch#delete_force()')
endfunction"}}}

function! s:tc.test_create()"{{{
  call self.assert_equal(giti#branch#create('hoge'), 'mocked_checkout_create')
  call self.assert_throw('E118', 'call giti#branch#create("", "")')
  call self.assert_throw('E119', 'call giti#branch#create()')
endfunction"}}}
function! s:tc.test_switch()"{{{
  call self.assert_equal(giti#branch#switch('hoge'), 'mocked_checkout_switch')
  call self.assert_throw('E118', 'call giti#branch#switch("", "")')
  call self.assert_throw('E119', 'call giti#branch#switch()')
endfunction"}}}

unlet s:tc

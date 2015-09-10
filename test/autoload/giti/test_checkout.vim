let s:tc = unittest#testcase#new('autoload/giti/checkout.vim')

function! s:tc.SETUP() "{{{
endfunction "}}}
function! s:tc.TEARDOWN() "{{{
endfunction "}}}

function! s:tc.test_run() "{{{
  call self.assert_equal(giti#checkout#run(['hoge', 'fuga']), 'mocked_system')
  call self.assert_equal('checkout -- hoge fuga', b:system_called_with)
  call self.assert_throw('E118', 'call giti#checkout#run("", "")')
  call self.assert_throw('E119', 'call giti#checkout#run()')
endfunction "}}}

function! s:tc.test_switch() "{{{
  call self.assert_equal(giti#checkout#switch({'name' : 'hoge'}), 'mocked_system')
  call self.assert_equal('checkout  hoge', b:system_called_with)

  call self.assert_equal(giti#checkout#switch({'name' : 'hoge', 'track' : 0}), 'mocked_system')
  call self.assert_equal('checkout --no-track hoge', b:system_called_with)

  call self.assert_equal(giti#checkout#switch({'name' : 'hoge', 'track' : 1}), 'mocked_system')
  call self.assert_equal('checkout --track hoge', b:system_called_with)

  call self.assert_equal(giti#checkout#switch({'name' : 'hoge', 'track' : 'hoge'}), 'mocked_system')
  call self.assert_equal('checkout  hoge', b:system_called_with)

  call self.assert_throw('E118', 'call giti#checkout#switch("", "")')
  call self.assert_throw('E119', 'call giti#checkout#switch()')
endfunction "}}}

function! s:tc.test_create() "{{{
  call self.assert_equal(
\   giti#checkout#create({'name' : 'hoge', 'start_point' : 'fuga'}),
\   'mocked_system'
\ )
  call self.assert_equal('checkout -b  hoge fuga', b:system_called_with)

  call self.assert_equal(
\   giti#checkout#create({'name' : 'hoge', 'start_point' : 'fuga', 'track' : 1}),
\   'mocked_system'
\ )
  call self.assert_equal('checkout -b --track hoge fuga', b:system_called_with)

  call self.assert_equal(
\   giti#checkout#create({'name' : 'hoge', 'start_point' : 'fuga', 'track' : 0}),
\   'mocked_system'
\ )
  call self.assert_equal('checkout -b --no-track hoge fuga', b:system_called_with)

  call self.assert_equal(
\   giti#checkout#create({'name' : 'hoge', 'start_point' : 'fuga', 'track' : 'hoge'}),
\   'mocked_system'
\ )
  call self.assert_equal('checkout -b  hoge fuga', b:system_called_with)

  call self.assert_throw('E118', 'call giti#checkout#create("", "")')
  call self.assert_throw('E119', 'call giti#checkout#create()')
endfunction "}}}

unlet s:tc

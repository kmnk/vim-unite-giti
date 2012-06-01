let s:tc = unittest#testcase#new('autoload/git/config.vim')

function! s:tc.SETUP()"{{{
endfunction"}}}
function! s:tc.TEARDOWN()"{{{
endfunction"}}}

function! s:tc.setup_list()"{{{
  function! giti#system_with_specifics(command)"{{{
    let b:system_with_specifics_called_with = a:command
    return 'hoge=fuga'
  endfunction"}}}
endfunction"}}}

function! s:tc.test_list()"{{{
  call self.assert_equal(giti#config#list(), [
\   {'key' : 'hoge', 'value' : 'fuga', 'location' : 'global'},
\   {'key' : 'hoge', 'value' : 'fuga', 'location' : 'system'},
\   {'key' : 'hoge', 'value' : 'fuga', 'location' : 'local' },
\ ])
  call self.assert_throw('E118', 'call giti#config#list("")')
endfunction"}}}

function! s:tc.setup_list_error()"{{{
  function! giti#system_with_specifics(command)"{{{
    let b:system_with_specifics_called_with = a:command
    return 'mocked_system_with_specifics'
  endfunction"}}}
endfunction"}}}

function! s:tc.test_list_error()"{{{
  call self.assert_throw('Vim(echoerr)', 'call giti#config#list()')
endfunction"}}}

function! s:tc.test_read()"{{{
  call self.assert_equal(giti#config#read({'key' : 'hoge'}), 'mocked_system')
  call self.assert_equal(b:system_called_with, 'config  hoge')

  call giti#config#read({'key' : 'hoge', 'location' : 'foobar'})
  call self.assert_equal(b:system_called_with, 'config --foobar hoge')

  call self.assert_throw('E118', 'call giti#config#read("", "")')
  call self.assert_throw('E119', 'call giti#config#read()')
endfunction"}}}

function! s:tc.test_write()"{{{
  call self.assert_equal(giti#config#write({'key' : 'hoge', 'value' : 'fuga'}), 'mocked_system_with_specifics')
  call self.assert_equal(
\   b:system_with_specifics_called_with,
\   {
\     'command' : 'config  hoge fuga',
\     'with_confirm' : 1,
\   }
\ )

  call giti#config#write({'key' : 'hoge', 'value' : 'fuga', 'location' : 'foobar'})
  call self.assert_equal(
\   b:system_with_specifics_called_with,
\   {
\     'command' : 'config --foobar hoge fuga',
\     'with_confirm' : 1,
\   }
\ )

  call self.assert_throw('E118', 'call giti#config#write("", "")')
  call self.assert_throw('E119', 'call giti#config#write()')
endfunction"}}}

function! s:tc.test_remove()"{{{
  call self.assert_equal(giti#config#remove({'key' : 'hoge'}), 'mocked_system_with_specifics')
  call self.assert_equal(
\   b:system_with_specifics_called_with,
\   {
\     'command' : 'config --unset  hoge',
\     'with_confirm' : 1,
\   }
\ )

  call giti#config#remove({'key' : 'hoge', 'location' : 'foobar'})
  call self.assert_equal(
\   b:system_with_specifics_called_with,
\   {
\     'command' : 'config --unset --foobar hoge',
\     'with_confirm' : 1,
\   }
\ )

  call self.assert_throw('E118', 'call giti#config#remove("", "")')
  call self.assert_throw('E119', 'call giti#config#remove()')
endfunction"}}}

function! s:tc.test_add()"{{{
  call self.assert_equal(giti#config#add({'key' : 'hoge', 'value' : 'fuga'}), 'mocked_system_with_specifics')
  call self.assert_equal(
\   b:system_with_specifics_called_with,
\   {
\     'command' : 'config --add  hoge fuga',
\     'with_confirm' : 1,
\   }
\ )

  call giti#config#add({'key' : 'hoge', 'value' : 'fuga', 'location' : 'foobar'})
  call self.assert_equal(
\   b:system_with_specifics_called_with,
\   {
\     'command' : 'config --add --foobar hoge fuga',
\     'with_confirm' : 1,
\   }
\ )

  call self.assert_throw('E118', 'call giti#config#add("", "")')
  call self.assert_throw('E119', 'call giti#config#add()')
endfunction"}}}

unlet s:tc
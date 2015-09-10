let s:tc = unittest#testcase#new('autoload/unite/kinds/giti.vim',
\                                unite#kinds#giti#__context__())

function! s:tc.SETUP() "{{{
endfunction "}}}
function! s:tc.TEARDOWN() "{{{
endfunction "}}}

function! s:tc.test_define() "{{{
  call self.assert_equal(
\   type([]),
\   type(unite#kinds#giti#define()),
\ )
  call self.assert_throw('E118', 'call self.call("unite#kinds#giti#define", [""])')
endfunction "}}}

function! s:tc.test_script_get_commands() "{{{
  call self.assert_equal(type([]), type(self.call('s:get_commands', [])))
endfunction "}}}

function! s:tc.test_script_define_func() "{{{
  call self.assert_equal(self.call('s:to_define_func', ['hoge']),
\                        'unite#kinds#giti#hoge#define')
  call self.assert_throw('E118', 'call self.call("s:to_define_func", ["", ""])')
  call self.assert_throw('E119', 'call self.call("s:to_define_func", [])')
endfunction "}}}

unlet s:tc

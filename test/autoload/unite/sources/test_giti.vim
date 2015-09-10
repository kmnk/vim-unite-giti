let s:tc = unittest#testcase#new('autoload/unite/sources/test_giti.vim',
\                                unite#sources#giti#__context__())

function! s:tc.SETUP() "{{{
endfunction "}}}
function! s:tc.TEARDOWN() "{{{
endfunction "}}}

function! s:tc.test_define() "{{{
  call self.assert_equal(
\   type([]),
\   type(unite#sources#giti#define()),
\ )
  call self.assert_throw('E118', 'call self.call("unite#sources#giti#define", [""])')
endfunction "}}}

function! s:tc.source_should_have() "{{{
  let source = self.get('s:source')
  call self.assert_equal(type({}), type(source))
  call self.assert(type(''), type(source.name))
  call self.assert(type([]), type(source.description))
  call self.assert(type(function('tr')), type(source.gather_candidates))
endfunction "}}}

function! s:tc.test_source_gather_candidate() "{{{
  let source = self.get('s:source')
  let candidates = source.gather_candidates('', '')
  call self.assert_equal(type([]), type(candidates))
  call self.assert(has_key(candidates[0], 'word'))
  call self.assert(has_key(candidates[0], 'source'))
  call self.assert(has_key(candidates[0], 'kind'))
  call self.assert(has_key(candidates[0], 'action__source_name'))
  call self.assert_equal(candidates[0].source, source.name)
endfunction "}}}

function! s:tc.test_script_get_commands() "{{{
  call self.assert_equal(type([]), type(self.call('s:get_commands', [])))
endfunction "}}}

function! s:tc.test_script_to_define_func() "{{{
  call self.assert_equal(self.call('s:to_define_func', ['hoge']),
\                        'unite#sources#giti#hoge#define')
  call self.assert_throw('E118', 'call self.call("s:to_define_func", ["", ""])')
  call self.assert_throw('E119', 'call self.call("s:to_define_func", [])')
endfunction "}}}


unlet s:tc

let s:tc = unittest#testcase#new(
\ 'autoload/unite/sources/giti/branch_recent.vim',
\ unite#sources#giti#branch#__context__()
\)

function! s:tc.SETUP() "{{{
endfunction "}}}
function! s:tc.TEARDOWN() "{{{
endfunction "}}}

function! s:tc.test_define() "{{{
  call self.assert_equal(
\   type([]),
\   type(unite#sources#giti#branch_recent#define()),
\ )
  call self.assert_throw('E118', 'call self.call("unite#sources#giti#branch_recent#define", [""])')
endfunction "}}}

function! s:tc.source_should_have() "{{{
  let source = self.get('s:source')
  call self.assert_equal(type({}), type(source))
  call self.assert_equal(type(''), type(source.name))
  call self.assert_equal(type(''), type(source.description))
  call self.assert_equal(type(function('tr')), type(source.gather_candidates))
  call self.assert_equal(type(function('tr')), type(source.change_candidates))
endfunction "}}}

function! s:tc.test_source_gather_candidate() "{{{
  let source = self.get('s:source')
  let candidates = source.gather_candidates('', '')
  call self.assert_equal(type([]), type(candidates))
  call self.assert(has_key(candidates[0], 'word'))
  call self.assert(has_key(candidates[0], 'source'))
  call self.assert(has_key(candidates[0], 'kind'))
  call self.assert(has_key(candidates[0], 'action__name'))
  call self.assert(has_key(candidates[0], 'action__is_new'))
endfunction "}}}

function! s:tc.test_source_change_candidate() "{{{
  let source = self.get('s:source')
  let candidates = source.change_candidates('', {'input' : 'hoge'})
  call self.assert(len(candidates), 2)
  call self.assert_equal(type([]), type(candidates))
  call self.assert(has_key(candidates[0], 'word'))
  call self.assert(has_key(candidates[0], 'source'))
  call self.assert(has_key(candidates[0], 'kind'))
  call self.assert(has_key(candidates[0], 'action__name'))
  call self.assert(has_key(candidates[0], 'action__is_new'))
endfunction "}}}

unlet s:tc

let s:tc = unittest#testcase#new('autoload/unite/sources/giti/remote.vim',
\                                unite#sources#giti#remote#__context__())

let s:list = ['hoge']

function! s:tc.SETUP() "{{{
  function! giti#remote#show() "{{{
    return s:list
  endfunction "}}}
endfunction "}}}
function! s:tc.TEARDOWN() "{{{
  let paths = split(globpath(&rtp, 'autoload/unite/sources/giti/remote.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}

function! s:tc.test_define() "{{{
  call self.assert_equal(
\   type({}),
\   type(unite#sources#giti#remote#define()),
\ )
  call self.assert_throw('E118', 'call self.call("unite#sources#giti#remote#define", [""])')
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
  call self.assert_equal(len(candidates), len(s:list))
endfunction "}}}

function! s:tc.test_source_change_candidate() "{{{
  let source = self.get('s:source')
  let candidates = source.change_candidates('', {'input' : 'hoge'})
  call self.assert_equal(type([]), type(candidates))
  call self.assert(has_key(candidates[0], 'word'))
  call self.assert(has_key(candidates[0], 'source'))
  call self.assert(has_key(candidates[0], 'kind'))
  call self.assert(has_key(candidates[0], 'action__name'))
  call self.assert(has_key(candidates[0], 'action__is_new'))
  call self.assert_equal(len(candidates), len(s:list))
endfunction "}}}

unlet s:tc

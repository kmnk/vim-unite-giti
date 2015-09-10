let s:tc = unittest#testcase#new('autoload/unite/sources/giti/log.vim',
\                                unite#sources#giti#log#__context__())

let s:list = [{
\ 'graph' : 'foo',
\ 'hash'  : 'barbarbarbarbar',
\ 'author' : {
\   'name' : 'hogehogehogehogehoge',
\   'date' : 'fuga',
\   'time' : '12345',
\ },
\ 'subject' : 'baz',
\}]

function! s:tc.SETUP() "{{{
  function! giti#log#list(param) "{{{
    return s:list
  endfunction "}}}
endfunction "}}}
function! s:tc.TEARDOWN() "{{{
  let paths = split(globpath(&rtp, 'autoload/unite/sources/giti/log.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}

function! s:tc.test_define() "{{{
  call self.assert_equal(
\   type({}),
\   type(unite#sources#giti#log#define()),
\ )
  call self.assert_throw('E118', 'call self.call("unite#sources#giti#log#define", [""])')
endfunction "}}}

function! s:tc.source_should_have() "{{{
  let source = self.get('s:source')
  call self.assert_equal(type({}), type(source))
  call self.assert_equal(type(''), type(source.name))
  call self.assert_equal(type(''), type(source.description))
  call self.assert_equal(type(function('tr')), type(source.gather_candidates))
endfunction "}}}

function! s:tc.test_source_gather_candidate() "{{{
  let source = self.get('s:source')
  let candidates = source.gather_candidates('', '')
  call self.assert_equal(type([]), type(candidates))
  call self.assert(has_key(candidates[0], 'word'))
  call self.assert(has_key(candidates[0], 'source'))
  call self.assert(has_key(candidates[0], 'kind'))
  call self.assert(has_key(candidates[0], 'action__data'))
  call self.assert(has_key(candidates[0], 'action__file'))
  call self.assert_equal(len(candidates), len(s:list))
endfunction "}}}

unlet s:tc

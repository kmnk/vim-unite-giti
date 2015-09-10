let s:tc = unittest#testcase#new('autoload/unite/sources/giti/status.vim',
\                                unite#sources#giti#status#__context__())

function! s:tc.SETUP() "{{{
  function! giti#status#list() "{{{
    return [{
\     'path1' : 'foo',
\     'path2' : 'bar',
\     'index' : 'baz',
\     'work'  : 'qux',
\     'description' : 'hogefuga',
\   }]
  endfunction "}}}
endfunction "}}}
function! s:tc.TEARDOWN() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/status.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}

function! s:tc.test_define() "{{{
  call self.assert_equal(
\   type({}),
\   type(unite#sources#giti#status#define()),
\ )
  call self.assert_throw('E118', 'call self.call("unite#sources#giti#status#define", [""])')
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
  call self.assert(has_key(candidates[0], 'action__path'))
  call self.assert(has_key(candidates[0], 'action__paths'))
  call self.assert(has_key(candidates[0], 'action__line'))
endfunction "}}}

unlet s:tc

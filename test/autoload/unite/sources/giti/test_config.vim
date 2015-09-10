let s:tc = unittest#testcase#new('autoload/unite/sources/giti/config.vim',
\                                unite#sources#giti#config#__context__())

function! s:tc.SETUP() "{{{
  function! giti#config#list() "{{{
    return [{
\     'key'      : 'hoge',
\     'value'    : 'fuga',
\     'location' : 'piyo',
\   }]
  endfunction "}}}
endfunction "}}}
function! s:tc.TEARDOWN() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/config.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}

function! s:tc.test_define() "{{{
  call self.assert_equal(
\   type({}),
\   type(unite#sources#giti#config#define()),
\ )
  call self.assert_throw('E118', 'call self.call("unite#sources#giti#config#define", [""])')
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
  call self.assert(has_key(candidates[0], 'action__key'))
  call self.assert(has_key(candidates[0], 'action__location'))
  call self.assert(has_key(candidates[0], 'action__value'))
  call self.assert(has_key(candidates[0], 'action__is_new'))
endfunction "}}}

function! s:tc.test_source_change_candidate() "{{{
  let source = self.get('s:source')
  let candidates = source.change_candidates('', {'input' : 'hoge'})
  call self.assert(len(candidates), 1)
  call self.assert_equal(type([]), type(candidates))
  call self.assert(has_key(candidates[0], 'word'))
  call self.assert(has_key(candidates[0], 'source'))
  call self.assert(has_key(candidates[0], 'kind'))
  call self.assert(has_key(candidates[0], 'action__key'))
  call self.assert(has_key(candidates[0], 'action__location'))
  call self.assert(has_key(candidates[0], 'action__value'))
  call self.assert(has_key(candidates[0], 'action__is_new'))
endfunction "}}}

unlet s:tc

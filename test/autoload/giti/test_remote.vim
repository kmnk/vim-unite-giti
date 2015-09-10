let s:tc = unittest#testcase#new('autoload/giti/remote.vim')

function! s:tc.SETUP() "{{{
endfunction "}}}
function! s:tc.TEARDOWN() "{{{
endfunction "}}}

function! s:tc.test_show() "{{{
  call self.assert_equal(['mocked_system'], giti#remote#show())
  call self.assert_equal('remote show', b:system_called_with)
  call self.assert_throw('E118', 'call giti#branch#list("")')
endfunction "}}}

function! s:tc.test_show_verbose() "{{{
  call self.assert_equal(['mocked_system'], giti#remote#show_verbose())
  call self.assert_equal('remote --verbose show', b:system_called_with)
  call self.assert_throw('E118', 'call giti#branch#list("")')
endfunction "}}}

function! s:tc.test_add() "{{{
  call self.assert_equal('mocked_system', giti#remote#add({
\   'branch'  : 'foo',
\   'master'  : 'bar',
\   'fetch'   : 1,
\   'tags'    : 1,
\   'no_tags' : 1,
\   'mirror'  : 'fetch',
\   'name'    : 'baz',
\   'url'     : 'qux',
\ }))
  call self.assert_equal(
\   'remote add -t foo -m bar -f --tags --mirror=fetch baz qux',
\   b:system_called_with
\ )
  call self.assert_equal('mocked_system', giti#remote#add({
\   'name' : 'baz',
\   'url'  : 'qux',
\ }))
  call self.assert_equal(
\   'remote add      baz qux',
\   b:system_called_with
\ )
  call self.assert_throw('name required', 'call giti#remote#add({
\   "url"  : "qux",
\ })')
  call self.assert_throw('url required', 'call giti#remote#add({
\   "name" : "baz",
\ })')
  call self.assert_throw('E118', 'call giti#remote#add("", "")')
  call self.assert_throw('E119', 'call giti#remote#add()')
endfunction "}}}

function! s:tc.test_rename() "{{{
  call self.assert_equal('mocked_system_with_specifics', giti#remote#rename({
\   'old' : 'foo',
\   'new' : 'bar',
\ }))
  call self.assert_equal(
\   {'command' : 'remote rename foo bar', 'with_confirm' : 1},
\   b:system_with_specifics_called_with,
\ )
  call self.assert_throw('new required', 'call giti#remote#rename({
\   "old" : "foo",
\ })')
  call self.assert_throw('old required', 'call giti#remote#rename({
\   "new" : "bar",
\ })')
  call self.assert_throw('E118', 'call giti#remote#rename("", "")')
  call self.assert_throw('E119', 'call giti#remote#rename()')
endfunction "}}}

function! s:tc.test_rm() "{{{
  call self.assert_equal('mocked_system_with_specifics', giti#remote#rm('foo'))
  call self.assert_equal(
\   {'command' : 'remote rm foo', 'with_confirm' : 1},
\   b:system_with_specifics_called_with,
\ )
  call self.assert_throw('name required', 'call giti#remote#rm("")')
  call self.assert_throw('E118', 'call giti#remote#rm("", "")')
  call self.assert_throw('E119', 'call giti#remote#rm()')
endfunction "}}}

function! s:tc.test_set_head() "{{{
  call self.assert(1)
endfunction "}}}

function! s:tc.test_set_branches() "{{{
  call self.assert(1)
endfunction "}}}

function! s:tc.test_set_url() "{{{
  call self.assert(1)
endfunction "}}}

function! s:tc.test_prune() "{{{
  call self.assert_equal('mocked_system_with_specifics', giti#remote#prune({
\   'name' : 'foo',
\ }))
  call self.assert_equal(
\   {'command' : 'remote prune  foo', 'with_confirm' : 1},
\   b:system_with_specifics_called_with,
\ )
  call self.assert_equal('mocked_system_with_specifics', giti#remote#prune({
\   'name'    : 'foo',
\   'dry_run' : 1,
\ }))
  call self.assert_equal(
\   {'command' : 'remote prune --dry-run foo', 'with_confirm' : 1},
\   b:system_with_specifics_called_with,
\ )
  call self.assert_throw('name required', 'call giti#remote#prune({})')
  call self.assert_throw('E118', 'call giti#remote#prune("", "")')
  call self.assert_throw('E119', 'call giti#remote#prune()')
endfunction "}}}

function! s:tc.test_update() "{{{
  call self.assert(1)
endfunction "}}}

unlet s:tc

let s:tc = unittest#testcase#new('autoload/unite/kinds/giti/remote.vim',
\                                unite#kinds#giti#remote#__context__())

function! s:tc.SETUP() "{{{
endfunction "}}}
function! s:tc.TEARDOWN() "{{{
endfunction "}}}

function! s:tc.test_define() "{{{
  call self.assert_equal(
\   type({}),
\   type(unite#kinds#giti#remote#define()),
\ )
  call self.assert_throw('E118', 'call self.call("unite#kinds#giti#remote#define", [""])')
endfunction "}}}

function! s:tc.kind_should_have() "{{{
  let kind = self.get('s:kind')
  call self.assert_equal(type({}), type(kind))
  call self.assert_equal('giti/remote', kind.name)
  call self.assert_equal(type(''), type(kind.default_action))
  call self.assert_equal(type({}), type(kind.action_table))
  call self.assert_equal(type({}), type(kind.alias_table))
endfunction "}}}

function! s:tc.setup_kind_action_run() "{{{
  function! giti#remote#add(param) "{{{
    let b:remote_add_called_with = a:param
    return 'mocked giti#remote#add'
  endfunction "}}}
  function! giti#fetch#run(param) "{{{
    let b:fetch_run_called_with = a:param
    return 'mocked giti#fetch#run'
  endfunction "}}}
  function! giti#input(prompt, ...) "{{{
    return 'mocked giti#input'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_kind_action_run() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/remote.vim'), '\n')
  execute 'source ' . paths[0]
  let paths = split(globpath(&rtp, 'autoload/giti/fetch.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}
function! s:tc.test_kind_action_run() "{{{
  let kind = self.get('s:kind')
  let run = kind.action_table.run
  call self.assert_equal(type({}), type(run))
  call self.assert_equal(type(''), type(run.description))
  call self.assert_equal(run.is_selectable, 0)
  call self.assert_equal(run.is_quit, 0)
  call self.assert_equal(run.is_invalidate_cache, 0)
  call self.assert_equal(type(function('tr')), type(run.func))

  let candidate = {
\   'action__name'   : 'hoge',
\   'action__is_new' : 1,
\ }
  call run.func(candidate)
  call self.assert_equal(
\   {
\     'name' : candidate.action__name,
\     'url'  : 'mocked giti#input'
\   },
\   b:remote_add_called_with
\ )

  let candidate.action__is_new = 0
  call run.func(candidate)
  call self.assert_equal(
\   { 'repository' : candidate.action__name },
\   b:fetch_run_called_with
\ )
endfunction "}}}

function! s:tc.setup_kind_action_rm() "{{{
  function! giti#remote#rm(param) "{{{
    let b:remote_rm_called_with = a:param
    return 'mocked giti#remote#rm'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_kind_action_rm() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/remote.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}
function! s:tc.test_kind_action_rm() "{{{
  let kind = self.get('s:kind')
  let rm = kind.action_table.rm
  call self.assert_equal(type({}), type(rm))
  call self.assert_equal(type(''), type(rm.description))
  call self.assert_equal(rm.is_selectable, 0)
  call self.assert_equal(rm.is_quit, 1)
  call self.assert_equal(rm.is_invalidate_cache, 0)
  call self.assert_equal(rm.is_listed, 1)
  call self.assert_equal(type(function('tr')), type(rm.func))

  let candidate = {'action__name' : 'hoge'}
  call rm.func(candidate)
  call self.assert_equal(candidate.action__name, b:remote_rm_called_with)
endfunction "}}}

function! s:tc.setup_kind_action_rename() "{{{
  function! giti#remote#rename(param) "{{{
    let b:remote_rename_called_with = a:param
    return 'mocked giti#remote#rename'
  endfunction "}}}
  function! giti#input(prompt, ...) "{{{
    return 'mocked giti#input'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_kind_action_rename() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/remote.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}
function! s:tc.test_kind_action_rename() "{{{
  let kind = self.get('s:kind')
  let rename = kind.action_table.rename
  call self.assert_equal(type({}), type(rename))
  call self.assert_equal(type(''), type(rename.description))
  call self.assert_equal(rename.is_selectable, 0)
  call self.assert_equal(rename.is_quit, 1)
  call self.assert_equal(rename.is_invalidate_cache, 0)
  call self.assert_equal(rename.is_listed, 1)
  call self.assert_equal(type(function('tr')), type(rename.func))

  let candidate = {'action__name' : 'hoge'}
  call rename.func(candidate)
  call self.assert_equal(
\   {
\     'old' : candidate.action__name,
\     'new' : 'mocked giti#input'
\   },
\   b:remote_rename_called_with
\ )
endfunction "}}}

function! s:tc.test_kind_alias_table_has() "{{{
  let kind = self.get('s:kind')
  let table = kind.alias_table
  call self.assert_equal(table.fetch, 'run')
  call self.assert_equal(table.default, 'run')
  call self.assert_equal(table.delete, 'rm')
endfunction "}}}

unlet s:tc

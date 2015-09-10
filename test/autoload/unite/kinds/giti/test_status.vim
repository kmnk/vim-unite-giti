let s:tc = unittest#testcase#new('autoload/unite/kinds/giti/status.vim',
\                                unite#kinds#giti#status#__context__())

function! s:tc.SETUP() "{{{
endfunction "}}}
function! s:tc.TEARDOWN() "{{{
endfunction "}}}

function! s:tc.test_define() "{{{
  call self.assert_equal(
\   type({}),
\   type(unite#kinds#giti#status#define()),
\ )
  call self.assert_throw('E118', 'call self.call("unite#kinds#giti#status#define", [""])')
endfunction "}}}

function! s:tc.kind_should_have() "{{{
  let kind = self.get('s:kind')
  call self.assert_equal(type({}), type(kind))
  call self.assert_equal('giti/status', kind.name)
  call self.assert_equal(type(''), type(kind.default_action))
  call self.assert_equal(type({}), type(kind.action_table))
  call self.assert_equal(type({}), type(kind.alias_table))
endfunction "}}}

function! s:tc.setup_kind_action_add() "{{{
  function! giti#add#run(param) "{{{
    let b:add_run_called_with = a:param
    return 'mocked giti#add#run'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_kind_action_add() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/add.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}
function! s:tc.test_kind_action_add() "{{{
  let kind = self.get('s:kind')
  let add = kind.action_table.add
  call self.assert_equal(type({}), type(add))
  call self.assert_equal(type(''), type(add.description))
  call self.assert_equal(add.is_selectable, 1)
  call self.assert_equal(add.is_quit, 0)
  call self.assert_equal(add.is_invalidate_cache, 1)
  call self.assert_equal(type(function('tr')), type(add.func))

  let candidates = [{ 'action__path' : 'hoge' }]
  call self.assert_equal(add.func(candidates), 'mocked giti#add#run')
  call self.assert_equal([ candidates[0].action__path ], b:add_run_called_with)
endfunction "}}}

function! s:tc.setup_kind_action_add_patch() "{{{
  function! giti#add#patch(param) "{{{
    let b:add_patch_called_with = a:param
    return 'mocked giti#add#patch'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_kind_action_add_patch() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/add.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}
function! s:tc.test_kind_action_add_patch() "{{{
  let kind = self.get('s:kind')
  let add_patch = kind.action_table.add_patch
  call self.assert_equal(type({}), type(add_patch))
  call self.assert_equal(type(''), type(add_patch.description))
  call self.assert_equal(add_patch.is_selectable, 1)
  call self.assert_equal(add_patch.is_quit, 0)
  call self.assert_equal(add_patch.is_invalidate_cache, 1)
  call self.assert_equal(type(function('tr')), type(add_patch.func))

  let candidates = [{ 'action__path' : 'hoge' }]
  call self.assert_equal(add_patch.func(candidates), 'mocked giti#add#patch')
  call self.assert_equal([ candidates[0].action__path ], b:add_patch_called_with)
endfunction "}}}

function! s:tc.setup_kind_action_reset_head() "{{{
  function! giti#reset#head(param) "{{{
    let b:reset_head_called_with = a:param
    return 'mocked giti#reset#head'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_kind_action_reset_head() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/reset.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}
function! s:tc.test_kind_action_reset_head() "{{{
  let kind = self.get('s:kind')
  let reset_head = kind.action_table.reset_head
  call self.assert_equal(type({}), type(reset_head))
  call self.assert_equal(type(''), type(reset_head.description))
  call self.assert_equal(reset_head.is_selectable, 1)
  call self.assert_equal(reset_head.is_quit, 0)
  call self.assert_equal(reset_head.is_invalidate_cache, 1)
  call self.assert_equal(type(function('tr')), type(reset_head.func))

  let candidates = [{ 'action__path' : 'hoge' }]
  call self.assert_equal('mocked giti#reset#head', reset_head.func(candidates))
  call self.assert_equal({ 'files' : [ candidates[0].action__path ] },
\                        b:reset_head_called_with)
endfunction "}}}

function! s:tc.setup_kind_action_commit() "{{{
  function! giti#commit#run(param) "{{{
    let b:commit_run_called_with = a:param
    return 'mocked giti#commit#run'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_kind_action_commit() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/commit.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}
function! s:tc.test_kind_action_commit() "{{{
  let kind = self.get('s:kind')
  let commit = kind.action_table.commit
  call self.assert_equal(type({}), type(commit))
  call self.assert_equal(type(''), type(commit.description))
  call self.assert_equal(commit.is_selectable, 1)
  call self.assert_equal(type(function('tr')), type(commit.func))

  let candidates = [{ 'action__paths' : [ 'hoge', 'fuga' ] }]
  call self.assert_equal('mocked giti#commit#run', commit.func(candidates))
  call self.assert_equal([
\   candidates[0].action__paths[0],
\   candidates[0].action__paths[1]
\ ], b:commit_run_called_with)
endfunction "}}}

function! s:tc.setup_kind_action_amend() "{{{
  function! giti#commit#amend(param) "{{{
    let b:commit_amend_called_with = a:param
    return 'mocked giti#commit#amend'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_kind_action_amend() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/commit.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}
function! s:tc.test_kind_action_amend() "{{{
  let kind = self.get('s:kind')
  let amend = kind.action_table.amend
  call self.assert_equal(type({}), type(amend))
  call self.assert_equal(type(''), type(amend.description))
  call self.assert_equal(amend.is_selectable, 1)
  call self.assert_equal(type(function('tr')), type(amend.func))

  let candidates = [{ 'action__paths' : [ 'hoge', 'fuga' ] }]
  call self.assert_equal('mocked giti#commit#amend', amend.func(candidates))
  call self.assert_equal([
\   candidates[0].action__paths[0],
\   candidates[0].action__paths[1]
\ ], b:commit_amend_called_with)
endfunction "}}}

function! s:tc.setup_kind_action_checkout() "{{{
  function! giti#checkout#run(param) "{{{
    let b:checkout_run_called_with = a:param
    return 'mocked giti#checkout#run'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_kind_action_checkout() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/checkout.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}
function! s:tc.test_kind_action_checkout() "{{{
  let kind = self.get('s:kind')
  let checkout = kind.action_table.checkout
  call self.assert_equal(type({}), type(checkout))
  call self.assert_equal(type(''), type(checkout.description))
  call self.assert_equal(checkout.is_selectable, 1)
  call self.assert_equal(checkout.is_quit, 0)
  call self.assert_equal(checkout.is_invalidate_cache, 1)
  call self.assert_equal(type(function('tr')), type(checkout.func))

  let candidates = [{ 'action__path' : 'hoge' }]
  call self.assert_equal('mocked giti#checkout#run', checkout.func(candidates))
  call self.assert_equal([ candidates[0].action__path ], b:checkout_run_called_with)
endfunction "}}}

function! s:tc.setup_kind_action_diff() "{{{
  function! giti#diff#run(param) "{{{
    let b:diff_run_called_with = a:param
    return 'mocked giti#diff#run'
  endfunction "}}}
  function! giti#diff#view_git_diff(param) "{{{
    let b:diff_view_git_diff_called_with = a:param
    return 'mocked giti#diff#view_git_diff'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_kind_action_diff() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/diff.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}
function! s:tc.test_kind_action_diff() "{{{
  let kind = self.get('s:kind')
  let diff = kind.action_table.diff
  call self.assert_equal(type({}), type(diff))
  call self.assert_equal(type(''), type(diff.description))
  call self.assert_equal(diff.is_selectable, 1)
  call self.assert_equal(type(function('tr')), type(diff.func))

  let candidates = [{ 'action__path' : 'hoge' }]
  call diff.func(candidates)
  call self.assert_equal(
\   {'files' : [ candidates[0].action__path ]},
\   b:diff_run_called_with
\ )
  call self.assert_equal(
\   'mocked giti#diff#run',
\   b:diff_view_git_diff_called_with
\ )
endfunction "}}}

function! s:tc.setup_kind_action_diff_cached() "{{{
  function! giti#diff#cached(param) "{{{
    let b:diff_cached_called_with = a:param
    return 'mocked giti#diff#cached'
  endfunction "}}}
  function! giti#diff#view_git_diff(param) "{{{
    let b:diff_view_git_diff_called_with = a:param
    return 'mocked giti#diff#view_git_diff'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_kind_action_diff_cached() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/diff.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}
function! s:tc.test_kind_action_diff_cached() "{{{
  let kind = self.get('s:kind')
  let diff_cached = kind.action_table.diff_cached
  call self.assert_equal(type({}), type(diff_cached))
  call self.assert_equal(type(''), type(diff_cached.description))
  call self.assert_equal(diff_cached.is_selectable, 1)
  call self.assert_equal(type(function('tr')), type(diff_cached.func))

  let candidates = [{ 'action__path' : 'hoge' }]
  call diff_cached.func(candidates)
  call self.assert_equal(
\   {'files' : [ candidates[0].action__path ]},
\   b:diff_cached_called_with
\ )
  call self.assert_equal(
\   'mocked giti#diff#cached',
\   b:diff_view_git_diff_called_with
\ )
endfunction "}}}

function! s:tc.setup_kind_action_diff_head() "{{{
  function! giti#diff#head(param) "{{{
    let b:diff_head_called_with = a:param
    return 'mocked giti#diff#head'
  endfunction "}}}
  function! giti#diff#view_git_diff(param) "{{{
    let b:diff_view_git_diff_called_with = a:param
    return 'mocked giti#diff#view_git_diff'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_kind_action_diff_head() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/diff.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}
function! s:tc.test_kind_action_diff_head() "{{{
  let kind = self.get('s:kind')
  let diff_head = kind.action_table.diff_head
  call self.assert_equal(type({}), type(diff_head))
  call self.assert_equal(type(''), type(diff_head.description))
  call self.assert_equal(diff_head.is_selectable, 1)
  call self.assert_equal(type(function('tr')), type(diff_head.func))

  let candidates = [{ 'action__path' : 'hoge' }]
  call diff_head.func(candidates)
  call self.assert_equal(
\   {'files' : [ candidates[0].action__path ]},
\   b:diff_head_called_with
\ )
  call self.assert_equal(
\   'mocked giti#diff#head',
\   b:diff_view_git_diff_called_with
\ )
endfunction "}}}

function! s:tc.setup_kind_action_vimdiff_head() "{{{
  function! giti#diff#view_vim_diff(param) "{{{
    let b:diff_view_vim_diff_called_with = a:param
    return 'mocked giti#diff#view_vim_diff'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_kind_action_vimdiff_head() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/diff.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}
function! s:tc.test_kind_action_vimdiff_head() "{{{
  let kind = self.get('s:kind')
  let vimdiff_head = kind.action_table.vimdiff_head
  call self.assert_equal(type({}), type(vimdiff_head))
  call self.assert_equal(type(''), type(vimdiff_head.description))
  call self.assert_equal(vimdiff_head.is_selectable, 0)
  call self.assert_equal(vimdiff_head.is_quit, 1)
  call self.assert_equal(vimdiff_head.is_invalidate_cache, 0)
  call self.assert_equal(vimdiff_head.is_listed, 1)
  call self.assert_equal(type(function('tr')), type(vimdiff_head.func))

  let candidate = { 'action__path' : 'hoge' }
  call self.assert_equal('mocked giti#diff#view_vim_diff', vimdiff_head.func(candidate))
  call self.assert_equal(
\   {
\     'file' : candidate.action__path,
\     'from' : 'HEAD',
\     'to'   : ''
\   },
\   b:diff_view_vim_diff_called_with
\ )
endfunction "}}}

function! s:tc.setup_kind_action_rm_cached() "{{{
  function! giti#rm#cached(param) "{{{
    let b:rm_cached_called_with = a:param
    return 'mocked giti#rm#cached'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_kind_action_rm_cached() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/rm.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}
function! s:tc.test_kind_action_rm_cached() "{{{
  let kind = self.get('s:kind')
  let rm_cached = kind.action_table.rm_cached
  call self.assert_equal(type({}), type(rm_cached))
  call self.assert_equal(type(''), type(rm_cached.description))
  call self.assert_equal(rm_cached.is_selectable, 1)
  call self.assert_equal(rm_cached.is_quit, 0)
  call self.assert_equal(rm_cached.is_invalidate_cache, 1)
  call self.assert_equal(type(function('tr')), type(rm_cached.func))

  let candidates = [{ 'action__path' : 'hoge' }]
  call self.assert_equal('mocked giti#rm#cached', rm_cached.func(candidates))
  call self.assert_equal(
\   {'files' : [ candidates[0].action__path ] },
\   b:rm_cached_called_with
\ )
endfunction "}}}

function! s:tc.setup_kind_action_ignore() "{{{
endfunction "}}}
function! s:tc.teardown_kind_action_ignore() "{{{
endfunction "}}}
function! s:tc.test_kind_action_ignore() "{{{
  let kind = self.get('s:kind')
  let ignore = kind.action_table.ignore
  call self.assert_equal(type({}), type(ignore))
  call self.assert_equal(type(''), type(ignore.description))
  call self.assert_equal(ignore.is_selectable, 1)
  call self.assert_equal(ignore.is_quit, 1)
  call self.assert_equal(ignore.is_invalidate_cache, 0)
  call self.assert_equal(ignore.is_listed, 1)
  call self.assert_equal(type(function('tr')), type(ignore.func))

  let candidates = [{ 'action__path' : 'hoge' }, { 'action__path' : 'fuga' }]
  call ignore.func(candidates)
  call self.assert_equal(["hoge\nfuga", ''], b:put_called_with_list)
endfunction "}}}

function! s:tc.test_kind_alias_table_has() "{{{
  let kind = self.get('s:kind')
  let table = kind.alias_table
  call self.assert_equal(table.stage, 'add')
  call self.assert_equal(table.reset, 'reset_head')
  call self.assert_equal(table.undo, 'reset_head')
  call self.assert_equal(table.unstage, 'reset_head')
  call self.assert_equal(table.ci, 'commit')
  call self.assert_equal(table.di, 'diff')
  call self.assert_equal(table.dic, 'diff_cached')
  call self.assert_equal(table.dih, 'diff_head')
  call self.assert_equal(table.vdih, 'vimdiff_head')
  call self.assert_equal(table.vdi, 'vimdiff_head')
  call self.assert_equal(table.rmc, 'rm_cached')
endfunction "}}}

unlet s:tc

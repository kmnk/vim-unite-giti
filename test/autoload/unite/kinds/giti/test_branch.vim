let s:tc = unittest#testcase#new('autoload/unite/kinds/giti/branch.vim',
\                                unite#kinds#giti#branch#__context__())

function! s:tc.SETUP() "{{{
endfunction "}}}
function! s:tc.TEARDOWN() "{{{
endfunction "}}}

function! s:tc.test_define() "{{{
  call self.assert_equal(
\   type([]),
\   type(unite#kinds#giti#branch#define()),
\ )
  call self.assert_throw('E118', 'call self.call("unite#kinds#giti#branch#define", [""])')
endfunction "}}}

function! s:tc.kind_should_have() "{{{
  let kind = self.get('s:kind')
  call self.assert_equal(type({}), type(kind))
  call self.assert_equal(type(''), type(kind.name))
  call self.assert_equal(type(''), type(kind.default_action))
  call self.assert_equal(type({}), type(kind.action_table))
  call self.assert_equal(type({}), type(kind.alias_table))
endfunction "}}}

function! s:tc.setup_kind_action_run() "{{{
  function! giti#checkout#switch(param) "{{{
    let b:checkout_switch_called_with = a:param
    return 'mocked giti#checkout#switch'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_kind_action_run() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/checkout.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}
function! s:tc.test_kind_action_run() "{{{
  let kind = self.get('s:kind')
  let run = kind.action_table.run
  call self.assert_equal(type({}), type(run))
  call self.assert_equal(type(''), type(run.description))
  call self.assert_equal(run.is_selectable, 0)
  call self.assert_equal(run.is_quit, 1)
  call self.assert_equal(type(function('tr')), type(run.func))

  let candidate = {
\   'action__is_new' : 0,
\   'action__name'   : 'hoge',
\ }
  call self.assert_equal(run.func(candidate), 'mocked giti#checkout#switch')
  call self.assert_equal(b:checkout_switch_called_with,
\                        {'name' : candidate.action__name})

  let candidate.action__is_new = 1
  call self.assert_equal(run.func(candidate), 'mocked unite#start')
  call self.assert_equal(b:unite_start_called_with,
\                        [[['giti/branch/new', candidate.action__name]], {'input' : ''}])
endfunction "}}}

function! s:tc.setup_kind_action_checkout_tracking() "{{{
  function! giti#checkout#switch(param) "{{{
    let b:checkout_switch_called_with = a:param
    return 'mocked giti#checkout#switch'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_kind_action_checkout_tracking() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/checkout.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}
function! s:tc.test_kind_action_checkout_tracking() "{{{
  let kind = self.get('s:kind')
  let checkout_tracking = kind.action_table.checkout_tracking
  call self.assert_equal(type({}), type(checkout_tracking))
  call self.assert_equal(type(''), type(checkout_tracking.description))
  call self.assert_equal(checkout_tracking.is_selectable, 0)
  call self.assert_equal(checkout_tracking.is_quit, 1)
  call self.assert_equal(type(function('tr')), type(checkout_tracking.func))

  let candidate = {
\   'action__is_new' : 0,
\   'action__name'   : 'hoge',
\ }
  call self.assert_equal(checkout_tracking.func(candidate), 'mocked giti#checkout#switch')
  call self.assert_equal(b:checkout_switch_called_with,
\                        {'name' : candidate.action__name,
\                         'track' : 1})
endfunction "}}}

function! s:tc.setup_kind_action_checkout_no_tracking() "{{{
  function! giti#checkout#switch(param) "{{{
    let b:checkout_switch_called_with = a:param
    return 'mocked giti#checkout#switch'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_kind_action_checkout_no_tracking() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/checkout.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}
function! s:tc.test_kind_action_checkout_no_tracking() "{{{
  let kind = self.get('s:kind')
  let checkout_no_tracking = kind.action_table.checkout_no_tracking
  call self.assert_equal(type({}), type(checkout_no_tracking))
  call self.assert_equal(type(''), type(checkout_no_tracking.description))
  call self.assert_equal(checkout_no_tracking.is_selectable, 0)
  call self.assert_equal(checkout_no_tracking.is_quit, 1)
  call self.assert_equal(type(function('tr')), type(checkout_no_tracking.func))

  let candidate = {
\   'action__is_new' : 0,
\   'action__name'   : 'hoge',
\ }
  call self.assert_equal(checkout_no_tracking.func(candidate), 'mocked giti#checkout#switch')
  call self.assert_equal(b:checkout_switch_called_with,
\                        {'name' : candidate.action__name,
\                         'track' : 0})
endfunction "}}}

function! s:tc.setup_kind_action_delete() "{{{
  function! giti#has_shell_error() "{{{
    return 0
  endfunction "}}}
  function! giti#input(prompt, ...) "{{{
    return 'y'
  endfunction "}}}
  function! giti#branch#delete(branches) "{{{
    let b:branch_delete_called_with = a:branches
    return 'mocked giti#branch#delete'
  endfunction "}}}
  function! giti#branch#delete_remote(branches) "{{{
    let b:branch_delete_remote_called_with = a:branches
    return 'mocked giti#branch#delete_remote'
  endfunction "}}}
  function! giti#config#read(param) "{{{
    return 'mocked giti#config#read'
  endfunction "}}}
endfunction "}}}

function! s:tc.teardown_kind_action_delete() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/branch.vim'), '\n')
  execute 'source ' . paths[0]
  let paths = split(globpath(&rtp, 'autoload/giti/config.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}
function! s:tc.test_kind_action_delete() "{{{
  let kind = self.get('s:kind')
  let delete = kind.action_table.delete
  call self.assert_equal(type({}), type(delete))
  call self.assert_equal(type(''), type(delete.description))
  call self.assert_equal(delete.is_selectable, 1)
  call self.assert_equal(delete.is_quit, 1)
  call self.assert_equal(type(function('tr')), type(delete.func))

  let candidates = [{
\   'action__name' : 'hoge',
\ }]
  call self.assert_equal(delete.func(candidates), 'mocked giti#branch#delete')
  call self.assert_equal(b:branch_delete_called_with,
\                        [candidates[0].action__name])
endfunction "}}}

function! s:tc.setup_kind_action_delete_force() "{{{
  function! giti#has_shell_error() "{{{
    return 0
  endfunction "}}}
  function! giti#input(prompt, ...) "{{{
    return 'y'
  endfunction "}}}
  function! giti#branch#delete_force(branches) "{{{
    let b:branch_delete_called_with = a:branches
    return 'mocked giti#branch#delete_force'
  endfunction "}}}
  function! giti#branch#delete_remote(branches) "{{{
    let b:branch_delete_remote_called_with = a:branches
    return 'mocked giti#branch#delete_remote'
  endfunction "}}}
  function! giti#config#read(param) "{{{
    return 'mocked giti#config#read'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_kind_action_delete_force() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/branch.vim'), '\n')
  execute 'source ' . paths[0]
  let paths = split(globpath(&rtp, 'autoload/giti/config.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}
function! s:tc.test_kind_action_delete_force() "{{{
  let kind = self.get('s:kind')
  let delete_force = kind.action_table.delete_force
  call self.assert_equal(type({}), type(delete_force))
  call self.assert_equal(type(''), type(delete_force.description))
  call self.assert_equal(delete_force.is_selectable, 1)
  call self.assert_equal(delete_force.is_quit, 1)
  call self.assert_equal(type(function('tr')), type(delete_force.func))

  let candidates = [{
\   'action__name' : 'hoge',
\ }]
  call self.assert_equal('mocked giti#branch#delete_force', delete_force.func(candidates))
  call self.assert_equal(b:branch_delete_called_with,
\                        [candidates[0].action__name])
endfunction "}}}

function! s:tc.setup_kind_action_delete_remote() "{{{
  function! giti#has_shell_error() "{{{
    return 0
  endfunction "}}}
  function! giti#input(prompt, ...) "{{{
    return 'y'
  endfunction "}}}
  function! giti#branch#delete(branches) "{{{
    let b:branch_delete_called_with = a:branches
    return 'mocked giti#branch#delete'
  endfunction "}}}
  function! giti#branch#delete_remote(branches) "{{{
    let b:branch_delete_remote_called_with = a:branches
    return 'mocked giti#branch#delete_remote'
  endfunction "}}}
  function! giti#config#read(param) "{{{
    return 'mocked giti#config#read'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_kind_action_delete_remote() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/branch.vim'), '\n')
  execute 'source ' . paths[0]
  let paths = split(globpath(&rtp, 'autoload/giti/config.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}
function! s:tc.test_kind_action_delete_remote() "{{{
  let kind = self.get('s:kind')
  let delete_remote = kind.action_table.delete_remote
  call self.assert_equal(type({}), type(delete_remote))
  call self.assert_equal(type(''), type(delete_remote.description))
  call self.assert_equal(delete_remote.is_selectable, 1)
  call self.assert_equal(delete_remote.is_quit, 1)
  call self.assert_equal(type(function('tr')), type(delete_remote.func))

  let candidates = [{
\   'action__name' : 'hoge',
\ }]
  call self.assert_equal(delete_remote.func(candidates), 'mocked giti#branch#delete')
  call self.assert_equal(b:branch_delete_called_with,
\                        [candidates[0].action__name])
  call self.assert_equal(b:branch_delete_remote_called_with,
\                        [{'repository' : 'mocked giti#config#read',
\                          'branch' : candidates[0].action__name}])
endfunction "}}}

function! s:tc.setup_kind_action_delete_remote_force() "{{{
  function! giti#has_shell_error() "{{{
    return 0
  endfunction "}}}
  function! giti#input(prompt, ...) "{{{
    return 'y'
  endfunction "}}}
  function! giti#branch#delete_force(branches) "{{{
    let b:branch_delete_called_with = a:branches
    return 'mocked giti#branch#delete_force'
  endfunction "}}}
  function! giti#branch#delete_remote(branches) "{{{
    let b:branch_delete_remote_called_with = a:branches
    return 'mocked giti#branch#delete_remote'
  endfunction "}}}
  function! giti#config#read(param) "{{{
    return 'mocked giti#config#read'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_kind_action_delete_remote_force() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/branch.vim'), '\n')
  execute 'source ' . paths[0]
  let paths = split(globpath(&rtp, 'autoload/giti/config.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}
function! s:tc.test_kind_action_delete_remote_force() "{{{
  let kind = self.get('s:kind')
  let delete_remote_force = kind.action_table.delete_remote_force
  call self.assert_equal(type({}), type(delete_remote_force))
  call self.assert_equal(type(''), type(delete_remote_force.description))
  call self.assert_equal(delete_remote_force.is_selectable, 1)
  call self.assert_equal(delete_remote_force.is_quit, 1)
  call self.assert_equal(type(function('tr')), type(delete_remote_force.func))

  let candidates = [{
\   'action__name' : 'hoge',
\ }]
  call self.assert_equal('mocked giti#branch#delete_force', delete_remote_force.func(candidates))
  call self.assert_equal(b:branch_delete_called_with,
\                        [candidates[0].action__name])
  call self.assert_equal(b:branch_delete_remote_called_with,
\                        [{'repository' : 'mocked giti#config#read',
\                          'branch' : candidates[0].action__name}])
endfunction "}}}

function! s:tc.setup_kind_action_merge() "{{{
  function! giti#merge#run(param) "{{{
    let b:merge_run_called_with = a:param
    return 'mocked giti#merge#run'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_kind_action_merge() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/merge.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}
function! s:tc.test_kind_action_merge() "{{{
  let kind = self.get('s:kind')
  let merge = kind.action_table.merge
  call self.assert_equal(type({}), type(merge))
  call self.assert_equal(type(''), type(merge.description))
  call self.assert_equal(merge.is_selectable, 0)
  call self.assert_equal(merge.is_quit, 1)
  call self.assert_equal(merge.is_invalidate_cache, 0)
  call self.assert_equal(merge.is_listed, 1)
  call self.assert_equal(type(function('tr')), type(merge.func))

  let candidate = {
\   'action__name' : 'hoge',
\ }
  call merge.func(candidate)
  call self.assert_equal(b:print_called_with, 'mocked giti#merge#run')
  call self.assert_equal(b:merge_run_called_with, {'branch_name' : candidate.action__name})
endfunction "}}}

function! s:tc.setup_kind_action_merge_squash() "{{{
  function! giti#merge#run(param) "{{{
    let b:merge_run_called_with = a:param
    return 'mocked giti#merge#run'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_kind_action_merge_squash() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/merge.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}
function! s:tc.test_kind_action_merge_squash() "{{{
  let kind = self.get('s:kind')
  let merge_squash = kind.action_table.merge_squash
  call self.assert_equal(type({}), type(merge_squash))
  call self.assert_equal(type(''), type(merge_squash.description))
  call self.assert_equal(merge_squash.is_selectable, 0)
  call self.assert_equal(merge_squash.is_quit, 1)
  call self.assert_equal(merge_squash.is_invalidate_cache, 0)
  call self.assert_equal(merge_squash.is_listed, 1)
  call self.assert_equal(type(function('tr')), type(merge_squash.func))

  let candidate = {
\   'action__name' : 'hoge',
\ }
  call merge_squash.func(candidate)
  call self.assert_equal(b:print_called_with, 'mocked giti#merge#run')
  call self.assert_equal(b:merge_run_called_with, {'branch_name' : candidate.action__name, 'squash' : 1})
endfunction "}}}

function! s:tc.setup_kind_action_rebase() "{{{
  function! giti#rebase#run(param) "{{{
    let b:rebase_run_called_with = a:param
    return 'mocked giti#rebase#run'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_kind_action_rebase() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/rebase.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}
function! s:tc.test_kind_action_rebase() "{{{
  let kind = self.get('s:kind')
  let rebase = kind.action_table.rebase
  call self.assert_equal(type({}), type(rebase))
  call self.assert_equal(type(''), type(rebase.description))
  call self.assert_equal(rebase.is_selectable, 0)
  call self.assert_equal(rebase.is_quit, 1)
  call self.assert_equal(rebase.is_invalidate_cache, 0)
  call self.assert_equal(rebase.is_listed, 1)
  call self.assert_equal(type(function('tr')), type(rebase.func))

  let candidate = {
\   'action__name' : 'hoge',
\ }
  call rebase.func(candidate)
  call self.assert_equal(b:print_called_with, 'mocked giti#rebase#run')
  call self.assert_equal(b:rebase_run_called_with, {'upstream' : candidate.action__name})
endfunction "}}}

function! s:tc.setup_kind_action_rebase_interactive() "{{{
  function! giti#rebase#interactive(param) "{{{
    let b:rebase_interactive_run_called_with = a:param
    return 'mocked giti#rebase#interactive'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_kind_action_rebase_interactive() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/rebase.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}
function! s:tc.test_kind_action_rebase_interactive() "{{{
  let kind = self.get('s:kind')
  let rebase_interactive = kind.action_table.rebase_interactive
  call self.assert_equal(type({}), type(rebase_interactive))
  call self.assert_equal(type(''), type(rebase_interactive.description))
  call self.assert_equal(rebase_interactive.is_selectable, 0)
  call self.assert_equal(rebase_interactive.is_quit, 1)
  call self.assert_equal(rebase_interactive.is_invalidate_cache, 0)
  call self.assert_equal(rebase_interactive.is_listed, 1)
  call self.assert_equal(type(function('tr')), type(rebase_interactive.func))

  let candidate = {
\   'action__name' : 'hoge',
\ }
  call rebase_interactive.func(candidate)
  call self.assert_equal(b:print_called_with, 'mocked giti#rebase#interactive')
  call self.assert_equal(b:rebase_interactive_run_called_with,
\                        {'upstream' : candidate.action__name})
endfunction "}}}

function! s:tc.test_kind_alias_table_has() "{{{
  let kind = self.get('s:kind')
  let table = kind.alias_table
  call self.assert_equal(table.switch, 'run')
  call self.assert_equal(table.sw, 'run')
  call self.assert_equal(table.new, 'run')
  call self.assert_equal(table.rm, 'delete')
endfunction "}}}

unlet s:tc

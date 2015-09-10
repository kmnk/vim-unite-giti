let s:tc = unittest#testcase#new('autoload/unite/kinds/giti/log.vim',
\                                unite#kinds#giti#log#__context__())

function! s:tc.SETUP() "{{{
endfunction "}}}
function! s:tc.TEARDOWN() "{{{
endfunction "}}}

function! s:tc.test_define() "{{{
  call self.assert_equal(
\   type({}),
\   type(unite#kinds#giti#log#define()),
\ )
  call self.assert_throw('E118', 'call self.call("unite#kinds#giti#log#define", [""])')
endfunction "}}}

function! s:tc.kind_should_have() "{{{
  let kind = self.get('s:kind')
  call self.assert_equal(type({}), type(kind))
  call self.assert_equal('giti/log', kind.name)
  call self.assert_equal(type(''), type(kind.default_action))
  call self.assert_equal(type({}), type(kind.action_table))
  call self.assert_equal(type({}), type(kind.alias_table))
endfunction "}}}

function! s:tc.test_kind_action_view() "{{{
  let kind = self.get('s:kind')
  let view = kind.action_table.view
  call self.assert_equal(type({}), type(view))
  call self.assert_equal(type(''), type(view.description))
  call self.assert_equal(view.is_selectable, 0)
  call self.assert_equal(view.is_quit, 0)
  call self.assert_equal(view.is_invalidate_cache, 0)
  call self.assert_equal(type(function('tr')), type(view.func))

  let candidate = {
\   'action__data' : {
\     'hash'        : 'hoge',
\     'parent_hash' : 'fuga',
\     'author'      : {'name' : 'foo', 'mail' : 'bar', 'date' : 'baz'},
\     'committer'   : {'name' : 'foo', 'mail' : 'bar', 'date' : 'baz'},
\     'subject'     : 'piyo',
\   }
\ }
  call view.func(candidate)
endfunction "}}}

function! s:tc.setup_kind_action_diff() "{{{
  function! giti#diff#specify(param) "{{{
    let b:diff_specify_called_with = a:param
    return 'mocked giti#diff#specify'
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
  call self.assert_equal(diff.is_quit, 1)
  call self.assert_equal(diff.is_invalidate_cache, 0)
  call self.assert_equal(type(function('tr')), type(diff.func))

  let candidates = map(range(2), '
\   {
\     "action__data" : {
\       "hash"        : "hoge" . v:val,
\       "parent_hash" : "fuga" . v:val,
\       "author"      : {"name" : "foo" . v:val, "mail" : "bar" . v:val, "date" : "baz" . v:val},
\       "committer"   : {"name" : "foo" . v:val, "mail" : "bar" . v:val, "date" : "baz" . v:val},
\       "subject"     : "piyo" . v:val,
\     },
\     "action__file" : "qux" . v:val
\   }
\ ')
  call self.assert(diff.func([candidates[0]]))
  call self.assert_equal(
\   { 'from'  : candidates[0].action__data.parent_hash,
\     'to'    : candidates[0].action__data.hash,
\     'files' : [candidates[0].action__file]
\   },
\   b:diff_specify_called_with
\ )

  call self.assert(diff.func(candidates))
  call self.assert_equal(
\   { 'from'  : candidates[1].action__data.hash,
\     'to'    : candidates[0].action__data.hash,
\     'files' : [candidates[0].action__file]
\   },
\   b:diff_specify_called_with
\ )
endfunction "}}}

function! s:tc.setup_kind_action_revert() "{{{
  function! giti#revert#run(hashes) "{{{
    let b:revert_run_called_with = a:hashes
    return 'mocked giti#revert#run'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_kind_action_revert() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/revert.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}
function! s:tc.test_kind_action_revert() "{{{
  let kind = self.get('s:kind')
  let revert = kind.action_table.revert
  call self.assert_equal(type({}), type(revert))
  call self.assert_equal(type(''), type(revert.description))
  call self.assert_equal(revert.is_selectable, 0)
  call self.assert_equal(revert.is_quit, 1)
  call self.assert_equal(revert.is_invalidate_cache, 0)
  call self.assert_equal(type(function('tr')), type(revert.func))

  let candidate = {
\   "action__data" : {
\     "hash"        : "hoge",
\   },
\ }
  call revert.func(candidate)
  call self.assert_equal(
\   [ candidate.action__data.hash ],
\   b:revert_run_called_with
\ )
endfunction "}}}

function! s:tc.setup_kind_action_vimdiff() "{{{
  function! giti#diff#view_vim_diff(hashes) "{{{
    let b:diff_view_vim_diff_called_with = a:hashes
    return 'mocked giti#diff#view_vim_diff'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_kind_action_vimdiff() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/diff.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}
function! s:tc.test_kind_action_vimdiff() "{{{
  let kind = self.get('s:kind')
  let vimdiff = kind.action_table.vimdiff
  call self.assert_equal(type({}), type(vimdiff))
  call self.assert_equal(type(''), type(vimdiff.description))
  call self.assert_equal(vimdiff.is_selectable, 1)
  call self.assert_equal(vimdiff.is_quit, 1)
  call self.assert_equal(vimdiff.is_invalidate_cache, 0)
  call self.assert_equal(type(function('tr')), type(vimdiff.func))

  let candidates = map(range(2), '
\   {
\     "action__data" : {
\       "hash"        : "hoge" . v:val,
\       "parent_hash" : "fuga" . v:val,
\       "author"      : {"name" : "foo" . v:val, "mail" : "bar" . v:val, "date" : "baz" . v:val},
\       "committer"   : {"name" : "foo" . v:val, "mail" : "bar" . v:val, "date" : "baz" . v:val},
\       "subject"     : "piyo" . v:val,
\     },
\     "action__file" : "qux" . v:val
\   }
\ ')
  call vimdiff.func([candidates[0]])
  call self.assert_equal(
\   { 'from' : candidates[0].action__data.parent_hash,
\     'to'   : candidates[0].action__data.hash,
\     'file' : candidates[0].action__file
\   },
\   b:diff_view_vim_diff_called_with
\ )

  call vimdiff.func(candidates)
  call self.assert_equal(
\   { 'from' : candidates[1].action__data.hash,
\     'to'   : candidates[0].action__data.hash,
\     'file' : candidates[0].action__file
\   },
\   b:diff_view_vim_diff_called_with
\ )
endfunction "}}}

function! s:tc.setup_kind_action_reset_hard() "{{{
  function! giti#reset#hard(param) "{{{
    let b:reset_hard_called_with = a:param
    return 'mocked giti#reset#hard'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_kind_action_reset_hard() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/reset.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}
function! s:tc.test_kind_action_reset_hard() "{{{
  let kind = self.get('s:kind')
  let reset_hard = kind.action_table.reset_hard
  call self.assert_equal(type({}), type(reset_hard))
  call self.assert_equal(type(''), type(reset_hard.description))
  call self.assert_equal(reset_hard.is_selectable, 0)
  call self.assert_equal(reset_hard.is_quit, 1)
  call self.assert_equal(reset_hard.is_invalidate_cache, 0)
  call self.assert_equal(type(function('tr')), type(reset_hard.func))

  let candidate = {
\   "action__data" : {
\     "hash"        : "hoge",
\   },
\ }
  call reset_hard.func(candidate)
  call self.assert_equal(
\   { 'hash' : candidate.action__data.hash },
\   b:reset_hard_called_with
\ )
endfunction "}}}

function! s:tc.test_action_yank_hash() "{{{
  let kind = self.get('s:kind')
  let yank_hash = kind.action_table.yank_hash
  call self.assert_equal(type({}), type(yank_hash))
  call self.assert_equal(type(''), type(yank_hash.description))
  call self.assert_equal(yank_hash.is_selectable, 0)
  call self.assert_equal(yank_hash.is_quit, 1)
  call self.assert_equal(yank_hash.is_invalidate_cache, 0)
  call self.assert_equal(type(function('tr')), type(yank_hash.func))

  let candidate = {
\   "action__data" : {
\     "hash"        : "hoge",
\   },
\ }
  let @" = 'fuga'
  call self.assert_not_equal(candidate.action__data.hash, @")
  call yank_hash.func(candidate)
  call self.assert_equal(candidate.action__data.hash, @")
endfunction "}}}

function! s:tc.setup_kind_action_changed_files() "{{{
  function! giti#diff_tree#changed_files(param) "{{{
    let b:changed_files_called_with = a:param
    return 'mocked giti#diff_tree#changed_files'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_kind_action_changed_files() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/diff_tree.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}
function! s:tc.test_kind_action_changed_files() "{{{
  let kind = self.get('s:kind')
  let changed_files = kind.action_table.changed_files
  call self.assert_equal(type({}), type(changed_files))
  call self.assert_equal(type(''), type(changed_files.description))
  call self.assert_equal(changed_files.is_selectable, 1)
  call self.assert_equal(changed_files.is_quit, 1)
  call self.assert_equal(changed_files.is_invalidate_cache, 0)
  call self.assert_equal(type(function('tr')), type(changed_files.func))

  let candidates = map(range(2), '
\   {
\     "action__data" : {
\       "hash"        : "hoge" . v:val,
\       "parent_hash" : "fuga" . v:val,
\     },
\   }
\ ')
  call self.assert_equal(changed_files.func([candidates[0]]), 'mocked unite#start')
  call self.assert_equal(b:unite_start_called_with,
\                        [[['giti/diff_tree/changed_files',
\                           candidates[0].action__data.parent_hash,
\                           candidates[0].action__data.hash]], {'input' : ''}])

  call self.assert_equal(changed_files.func(candidates), 'mocked unite#start')
  call self.assert_equal(b:unite_start_called_with,
\                        [[['giti/diff_tree/changed_files',
\                           candidates[1].action__data.hash,
\                           candidates[0].action__data.hash]], {'input' : ''}])
endfunction "}}}

function! s:tc.test_kind_alias_table_has() "{{{
  let kind = self.get('s:kind')
  let table = kind.alias_table
  call self.assert_equal(table.di, 'diff')
  call self.assert_equal(table.vdi, 'vimdiff')
  call self.assert_equal(table.reset_hard, 'reset')
endfunction "}}}

unlet s:tc

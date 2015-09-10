let s:tc = unittest#testcase#new('autoload/unite/kinds/giti/branch/new.vim',
\                                unite#kinds#giti#branch#new#__context__())

function! s:tc.SETUP() "{{{
endfunction "}}}
function! s:tc.TEARDOWN() "{{{
endfunction "}}}

function! s:tc.test_define() "{{{
  call self.assert_equal(
\   type({}),
\   type(unite#kinds#giti#branch#new#define()),
\ )
  call self.assert_throw(
\   'E118', 'call self.call("unite#kinds#giti#branch#new#define", [""])'
\ )
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
  function! giti#checkout#create(name) "{{{
    let b:checkout_create_called_with = a:name
    return 'mocked giti#checkout#create'
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
\   'action__name'        : 'hoge',
\   'action__start_point' : 'fuga',
\ }
  call run.func(candidate)
  call self.assert_equal({'name'        : candidate.action__name,
\                         'start_point' : candidate.action__start_point},
\                        b:checkout_create_called_with)
  call self.assert_equal(b:print_called_with, 'mocked giti#checkout#create')
endfunction "}}}

function! s:tc.setup_kind_action_create_tracking() "{{{
  function! giti#checkout#create(param) "{{{
    let b:checkout_create_called_with = a:param
    return 'mocked giti#checkout#create'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_kind_action_create_tracking() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/checkout.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}
function! s:tc.test_kind_action_create_tracking() "{{{
  let kind = self.get('s:kind')
  let create_tracking = kind.action_table.create_tracking
  call self.assert_equal(type({}), type(create_tracking))
  call self.assert_equal(type(''), type(create_tracking.description))
  call self.assert_equal(create_tracking.is_selectable, 0)
  call self.assert_equal(create_tracking.is_quit, 1)
  call self.assert_equal(type(function('tr')), type(create_tracking.func))

  let candidate = {
\   'action__name'        : 'hoge',
\   'action__start_point' : 'fuga',
\ }
  call create_tracking.func(candidate)
  call self.assert_equal({'name'        : candidate.action__name,
\                         'start_point' : candidate.action__start_point,
\                         'track'       : 1},
\                        b:checkout_create_called_with)
  call self.assert_equal(b:print_called_with, 'mocked giti#checkout#create')
endfunction "}}}

function! s:tc.setup_kind_action_create_no_tracking() "{{{
  function! giti#checkout#create(param) "{{{
    let b:checkout_create_called_with = a:param
    return 'mocked giti#checkout#create'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_kind_action_create_no_tracking() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/checkout.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}
function! s:tc.test_kind_action_create_no_tracking() "{{{
  let kind = self.get('s:kind')
  let create_no_tracking = kind.action_table.create_no_tracking
  call self.assert_equal(type({}), type(create_no_tracking))
  call self.assert_equal(type(''), type(create_no_tracking.description))
  call self.assert_equal(create_no_tracking.is_selectable, 0)
  call self.assert_equal(create_no_tracking.is_quit, 1)
  call self.assert_equal(type(function('tr')), type(create_no_tracking.func))

  let candidate = {
\   'action__name'        : 'hoge',
\   'action__start_point' : 'fuga',
\ }
  call create_no_tracking.func(candidate)
  call self.assert_equal({'name'        : candidate.action__name,
\                         'start_point' : candidate.action__start_point,
\                         'track'       : 0},
\                        b:checkout_create_called_with)
  call self.assert_equal(b:print_called_with, 'mocked giti#checkout#create')
endfunction "}}}

function! s:tc.test_kind_alias_table_has() "{{{
  let kind = self.get('s:kind')
  let table = kind.alias_table
  call self.assert_equal(table.create, 'run')
  call self.assert_equal(table.new, 'run')
  call self.assert_equal(table.cot, 'create_tracking')
  call self.assert_equal(table.con, 'create_no_tracking')
endfunction "}}}

unlet s:tc

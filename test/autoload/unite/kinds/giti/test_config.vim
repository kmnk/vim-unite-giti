let s:tc = unittest#testcase#new('autoload/unite/kinds/giti/config.vim',
\                                unite#kinds#giti#config#__context__())

function! s:tc.SETUP() "{{{
endfunction "}}}
function! s:tc.TEARDOWN() "{{{
endfunction "}}}

function! s:tc.test_define() "{{{
  call self.assert_equal(
\   type({}),
\   type(unite#kinds#giti#config#define()),
\ )
  call self.assert_throw('E118', 'call self.call("unite#kinds#giti#config#define", [""])')
endfunction "}}}

function! s:tc.kind_should_have() "{{{
  let kind = self.get('s:kind')
  call self.assert_equal(type({}), type(kind))
  call self.assert_equal('giti/config', kind.name)
  call self.assert_equal(type(''), type(kind.default_action))
  call self.assert_equal(type({}), type(kind.action_table))
  call self.assert_equal(type({}), type(kind.alias_table))
endfunction "}}}

function! s:tc.setup_kind_action_yank_value() "{{{
  function! giti#config#add(param) "{{{
    let b:config_add_called_with = a:param
    return 'mocked giti#config#add'
  endfunction "}}}
  function! giti#input(prompt, ...) "{{{
    return 'mocked giti#input'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_kind_action_yank_value() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/config.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}
function! s:tc.test_kind_action_yank_value() "{{{
  let kind = self.get('s:kind')
  let yank_value = kind.action_table.yank_value
  call self.assert_equal(type({}), type(yank_value))
  call self.assert_equal(type(''), type(yank_value.description))
  call self.assert_equal(yank_value.is_selectable, 0)
  call self.assert_equal(yank_value.is_quit, 0)
  call self.assert_equal(yank_value.is_invalidate_cache, 1)
  call self.assert_equal(type(function('tr')), type(yank_value.func))

  let candidate = {
\   'action__is_new' : 0,
\   'action__key'   : 'hoge',
\   'action__value' : 'fuga',
\ }
  call yank_value.func(candidate)
  call self.assert_equal(candidate.action__value, @")

  let candidate.action__is_new = 1
  call yank_value.func(candidate)
  call self.assert_equal({'key'      : candidate.action__key,
\                         'value'    : 'mocked giti#input',
\                         'location' : 'local'
\                        },
\                        b:config_add_called_with)
endfunction "}}}

function! s:tc.setup_kind_action_write() "{{{
  function! giti#config#write(param) "{{{
    let b:config_write_called_with = a:param
    return 'mocked giti#config#write'
  endfunction "}}}
  function! giti#input(prompt, ...) "{{{
    return 'mocked giti#input'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_kind_action_write() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/config.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}
function! s:tc.test_kind_action_write() "{{{
  let kind = self.get('s:kind')
  let write = kind.action_table.write
  call self.assert_equal(type({}), type(write))
  call self.assert_equal(type(''), type(write.description))
  call self.assert_equal(write.is_selectable, 0)
  call self.assert_equal(write.is_quit, 0)
  call self.assert_equal(write.is_invalidate_cache, 1)
  call self.assert_equal(type(function('tr')), type(write.func))

  let candidate = {
\   'action__location' : 'global',
\   'action__key'      : 'hoge',
\   'action__value'    : 'fuga',
\ }
  call write.func(candidate)
  call self.assert_equal({
\   'key'      : candidate.action__key,
\   'value'    : 'mocked giti#input',
\   'location' : candidate.action__location,
\ },
\ b:config_write_called_with)
endfunction "}}}

function! s:tc.setup_kind_action_remove() "{{{
  function! giti#config#remove(param) "{{{
    let b:config_remove_called_with = a:param
    return 'mocked giti#config#remove'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_kind_action_remove() "{{{
  let paths = split(globpath(&rtp, 'autoload/giti/config.vim'), '\n')
  execute 'source ' . paths[0]
endfunction "}}}
function! s:tc.test_kind_action_remove() "{{{
  let kind = self.get('s:kind')
  let remove = kind.action_table.remove
  call self.assert_equal(type({}), type(remove))
  call self.assert_equal(type(''), type(remove.description))
  call self.assert_equal(remove.is_selectable, 1)
  call self.assert_equal(remove.is_quit, 0)
  call self.assert_equal(remove.is_invalidate_cache, 1)
  call self.assert_equal(type(function('tr')), type(remove.func))

  let candidates = [{
\   'action__location' : 'global',
\   'action__key'      : 'hoge',
\ }]
  call remove.func(candidates)
  call self.assert_equal({
\   'key'      : candidates[0].action__key,
\   'location' : candidates[0].action__location,
\ },
\ b:config_remove_called_with)
endfunction "}}}

function! s:tc.test_kind_alias_table_has() "{{{
  let kind = self.get('s:kind')
  let table = kind.alias_table
  call self.assert_equal(table.run, 'yank_value')
endfunction "}}}

unlet s:tc

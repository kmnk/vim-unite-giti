let s:tc = unittest#testcase#new('autoload/giti/diff.vim')

function! s:tc.SETUP() "{{{
endfunction "}}}
function! s:tc.TEARDOWN() "{{{
  setlocal filetype=unittest
endfunction "}}}

function! s:tc.test_run() "{{{
  call self.assert_equal(giti#diff#run({'files' : []}), 'mocked_system')
  call self.assert_equal(b:system_called_with, 'diff -- ')

  call self.assert_equal(giti#diff#run({}), 'mocked_system')
  call self.assert_equal(b:system_called_with, 'diff -- ')

  call self.assert_equal(giti#diff#run({'files' : ['hoge', 'fuga']}),
\                        'mocked_system')
  call self.assert_equal(b:system_called_with, 'diff -- hoge fuga')

  call self.assert_throw('E118', 'call giti#diff#run("", "")')
  call self.assert_throw('E119', 'call giti#diff#run()')
endfunction "}}}

function! s:tc.setup_run_nodiff() "{{{
  function! giti#system(command) "{{{
    let b:system_called_with = a:command
    return ''
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_run_nodiff() "{{{
  function! giti#system(command) "{{{
    let b:system_called_with = a:command
    return 'mocked_system'
  endfunction "}}}
endfunction "}}}
function! s:tc.test_run_nodiff() "{{{
  call self.assert_not(giti#diff#run({'files' : []}))
endfunction "}}}

function! s:tc.test_cached() "{{{
  call self.assert_equal(giti#diff#cached({'files' : []}),
\                        'mocked_system')
  call self.assert_equal(b:system_called_with, 'diff --cached -- ')

  call self.assert_equal(giti#diff#cached({}),
\                        'mocked_system')
  call self.assert_equal(b:system_called_with, 'diff --cached -- ')

  call self.assert_equal(giti#diff#cached({'files' : ['hoge', 'fuga']}),
\                        'mocked_system')
  call self.assert_equal(b:system_called_with, 'diff --cached -- hoge fuga')

  call self.assert_throw('E118', 'call giti#diff#cached("", "")')
  call self.assert_throw('E119', 'call giti#diff#cached()')
endfunction "}}}

function! s:tc.test_head() "{{{
  call self.assert_equal(giti#diff#head({'files' : []}),
\                        'mocked_system')
  call self.assert_equal(b:system_called_with, 'diff HEAD -- ')

  call self.assert_equal(giti#diff#head({}),
\                        'mocked_system')
  call self.assert_equal(b:system_called_with, 'diff HEAD -- ')

  call self.assert_equal(giti#diff#head({'files' : ['hoge', 'fuga']}),
\                        'mocked_system')
  call self.assert_equal(b:system_called_with, 'diff HEAD -- hoge fuga')

  call self.assert_throw('E118', 'call giti#diff#head("", "")')
  call self.assert_throw('E119', 'call giti#diff#head()')
endfunction "}}}

function! s:tc.test_specify() "{{{
  call self.assert_equal(giti#diff#specify({
\   'from'  : 'foo',
\   'to'    : 'bar',
\   'files' : ['hoge', 'fuga'],
\ }), 'mocked_system')
  call self.assert_equal(b:system_called_with, 'diff foo..bar -- hoge fuga')

  call self.assert_equal(giti#diff#specify({
\   'from'  : 'foo',
\   'to'    : 'bar',
\   'files' : [],
\ }), 'mocked_system')
  call self.assert_equal(b:system_called_with, 'diff foo..bar -- ')

  call self.assert_equal(giti#diff#specify({
\   'from'  : 'foo',
\   'to'    : 'bar',
\ }), 'mocked_system')
  call self.assert_equal(b:system_called_with, 'diff foo..bar -- ')

  call self.assert_equal(giti#diff#specify({
\   'from'  : 'foo',
\   'to'    : '',
\   'files' : ['hoge', 'fuga'],
\ }), 'mocked_system')
  call self.assert_equal(b:system_called_with, 'diff foo -- hoge fuga')

  call self.assert_equal(giti#diff#specify({
\   'from'  : 'foo',
\   'files' : ['hoge', 'fuga'],
\ }), 'mocked_system')
  call self.assert_equal(b:system_called_with, 'diff foo -- hoge fuga')

  call self.assert_throw('E118', 'call giti#diff#specify("", "")')
  call self.assert_throw('E119', 'call giti#diff#specify()')
endfunction "}}}

function! s:tc.test_view_git_diff() "{{{
  call self.assert(giti#diff#view_git_diff('hoge'))
  call self.assert_equal('setlocal buftype=nofile', b:execute_called_with)
  call self.assert_throw('E118', 'call giti#diff#view_git_diff("", "")')
  call self.assert_throw('E119', 'call giti#diff#view_git_diff()')
endfunction "}}}

function! s:tc.test_view_vim_diff() "{{{
  call self.assert(giti#diff#view_vim_diff({
\   'from' : 'hoge',
\   'to'   : 'fuga',
\   'file' : 'piyo',
\ }))
  call self.assert_equal('setlocal buftype=nofile', b:execute_called_with)
  call self.assert_throw('E118', 'call giti#diff#view_vim_diff("", "")')
  call self.assert_throw('E119', 'call giti#diff#view_vim_diff()')
endfunction "}}}

unlet s:tc

let s:tc = unittest#testcase#new('autoload/giti/diff.vim')

function! s:tc.SETUP()"{{{
endfunction"}}}
function! s:tc.TEARDOWN()"{{{
  setlocal filetype=unittest
endfunction"}}}

function! s:tc.test_run()"{{{
  call self.assert(giti#diff#run({'files' : []}))
  call self.assert_equal(b:system_called_with, 'diff -- ')

  call self.assert(giti#diff#run({}))
  call self.assert_equal(b:system_called_with, 'diff -- ')

  call self.assert(giti#diff#run({'files' : ['hoge', 'fuga']}))
  call self.assert_equal(b:system_called_with, 'diff -- hoge fuga')

  call self.assert_throw('E118', 'call giti#diff#run("", "")')
  call self.assert_throw('E119', 'call giti#diff#run()')
endfunction"}}}

function! s:tc.setup_run_nodiff()"{{{
  function! giti#system(command)"{{{
    let b:system_called_with = a:command
    return ''
  endfunction"}}}
endfunction"}}}
function! s:tc.teardown_run_nodiff()"{{{
  function! giti#system(command)"{{{
    let b:system_called_with = a:command
    return 'mocked_system'
  endfunction"}}}
endfunction"}}}
function! s:tc.test_run_nodiff()"{{{
  call self.assert_not(giti#diff#run({'files' : []}))
endfunction"}}}

function! s:tc.test_cached()"{{{
  call self.assert(giti#diff#cached({'files' : []}))
  call self.assert_equal(b:system_called_with, 'diff --cached -- ')

  call self.assert(giti#diff#cached({}))
  call self.assert_equal(b:system_called_with, 'diff --cached -- ')

  call self.assert(giti#diff#cached({'files' : ['hoge', 'fuga']}))
  call self.assert_equal(b:system_called_with, 'diff --cached -- hoge fuga')

  call self.assert_throw('E118', 'call giti#diff#cached("", "")')
  call self.assert_throw('E119', 'call giti#diff#cached()')
endfunction"}}}

function! s:tc.test_head()"{{{
  call self.assert(giti#diff#head({'files' : []}))
  call self.assert_equal(b:system_called_with, 'diff HEAD -- ')

  call self.assert(giti#diff#head({}))
  call self.assert_equal(b:system_called_with, 'diff HEAD -- ')

  call self.assert(giti#diff#head({'files' : ['hoge', 'fuga']}))
  call self.assert_equal(b:system_called_with, 'diff HEAD -- hoge fuga')

  call self.assert_throw('E118', 'call giti#diff#head("", "")')
  call self.assert_throw('E119', 'call giti#diff#head()')
endfunction"}}}

function! s:tc.test_specify()"{{{
  call self.assert(giti#diff#specify({
\   'from'  : 'foo',
\   'to'    : 'bar',
\   'files' : ['hoge', 'fuga'],
\ }))
  call self.assert_equal(b:system_called_with, 'diff foo..bar -- hoge fuga')

  call self.assert(giti#diff#specify({
\   'from'  : 'foo',
\   'to'    : 'bar',
\   'files' : [],
\ }))
  call self.assert_equal(b:system_called_with, 'diff foo..bar -- ')

  call self.assert(giti#diff#specify({
\   'from'  : 'foo',
\   'to'    : 'bar',
\ }))
  call self.assert_equal(b:system_called_with, 'diff foo..bar -- ')

  call self.assert(giti#diff#specify({
\   'from'  : 'foo',
\   'to'    : '',
\   'files' : ['hoge', 'fuga'],
\ }))
  call self.assert_equal(b:system_called_with, 'diff foo -- hoge fuga')

  call self.assert(giti#diff#specify({
\   'from'  : 'foo',
\   'files' : ['hoge', 'fuga'],
\ }))
  call self.assert_equal(b:system_called_with, 'diff foo -- hoge fuga')

  call self.assert_throw('E118', 'call giti#diff#specify("", "")')
  call self.assert_throw('E119', 'call giti#diff#specify()')
endfunction"}}}

unlet s:tc

let s:tc = unittest#testcase#new('autoload/giti/blame.vim')

function! s:tc.SETUP() "{{{
endfunction "}}}
function! s:tc.TEARDOWN() "{{{
endfunction "}}}

function! s:tc.test_sample() "{{{
  call self.assert_equal(giti#blame#run({'file' : 'hoge'}),
\                        ['mocked_system'])
  call self.assert_equal(b:system_called_with,
\                        'blame hoge')
  call self.assert_throw('E118', 'call giti#blame#run("", "")')
  call self.assert_throw('E119', 'call giti#blame#run()')
endfunction "}}}


function! s:tc.test_format() "{{{
  call self.assert_equal(
\   giti#blame#format(
\     ['hogefugapiyo (whoAreYou 2012-01-01 00:00:00 +0000 1) code of hoge file']),
\   [{ 'hash'   : 'hogefugapiyo',
\      'detail' : '(whoAreYou 2012-01-01 00:00:00 +0000 1)',
\      'line'   : 'code of hoge file' }]
\ )
  call self.assert_equal(
\   giti#blame#format(
\     ['hogefugapiyo (whoAreYou 2012-01-01 00:00:00 +0000 1) code of hoge file',
\      'foobarbaz (IAmFoo 2012-01-01 00:00:00 +0000 2) second line of hoge file']),
\   [{ 'hash'   : 'hogefugapiyo',
\      'detail' : '(whoAreYou 2012-01-01 00:00:00 +0000 1)',
\      'line'   : 'code of hoge file' },
\    { 'hash'   : 'foobarbaz',
\      'detail' : '(IAmFoo 2012-01-01 00:00:00 +0000 2)',
\      'line'   : 'second line of hoge file' }]
\ )
  call self.assert_throw('E118', 'call giti#blame#format("", "")')
  call self.assert_throw('E119', 'call giti#blame#format()')
endfunction "}}}


unlet s:tc

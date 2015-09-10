let s:tc = unittest#testcase#new('autoload/giti/log.vim')

function! s:tc.SETUP() "{{{
  let g:giti_log_default_line_count = 1234
endfunction "}}}
function! s:tc.TEARDOWN() "{{{
endfunction "}}}


function! s:tc.test_run() "{{{
  call self.assert_equal(giti#log#run(), 'mocked_system')
  call self.assert_equal(b:system_called_with, 'log -1234 -- ')
  call self.assert_equal(giti#log#run('hoge'), 'mocked_system')
  call self.assert_equal(b:system_called_with, 'log -1234 -- hoge')
endfunction "}}}

function! s:tc.test_full() "{{{
  call self.assert_equal(giti#log#full(), 'mocked_system')
  call self.assert_equal(b:system_called_with, 'log -- ')
  call self.assert_equal(giti#log#full('hoge'), 'mocked_system')
  call self.assert_equal(b:system_called_with, 'log -- hoge')
endfunction "}}}

function! s:tc.test_line() "{{{
  call self.assert_equal(giti#log#line(), 'mocked_system')
  call self.assert_equal(b:system_called_with,
\                        'log --pretty=oneline --graph -- ')
  call self.assert_equal(giti#log#line('hoge'), 'mocked_system')
  call self.assert_equal(b:system_called_with,
\                        'log --pretty=oneline --graph -- hoge')
endfunction "}}}

function! s:tc.setup_list() "{{{
  function! giti#system(command) "{{{
    let b:system_called_with = a:command
    return '* | | :::aaaa:::bbbb:::cccc<cc@cc.cc>[cc/cc/cc cc:cc:cc(12345)]:::dddd<dd@dd.dd>[dd/dd/dd dd:dd:dd(12345)]:::eeee'
  endfunction "}}}
endfunction
function! s:tc.teardown_list() "{{{
  function! giti#system(command) "{{{
    let b:system_called_with = a:command
    return 'mocked_system'
  endfunction "}}}
endfunction
function! s:tc.test_list() "{{{
  call self.assert_equal(giti#log#list(), [{
\   'graph'       : '* | | ',
\   'hash'        : 'aaaa',
\   'parent_hash' : 'bbbb',
\   'author'      : {'name' : 'cccc', 'mail' : 'cc@cc.cc', 'date' : 'cc/cc/cc cc:cc:cc', 'time' : '12345'},
\   'committer'   : {'name' : 'dddd', 'mail' : 'dd@dd.dd', 'date' : 'dd/dd/dd dd:dd:dd', 'time' : '12345'},
\   'subject'     : 'eeee',
\ }])
  call self.assert_match(
\   'log -1234 --graph --date=default --pretty=format:".\+" ',
\   b:system_called_with
\ )
  call self.assert_equal(giti#log#list({'line_count' : 4321}), [{
\   'graph'       : '* | | ',
\   'hash'        : 'aaaa',
\   'parent_hash' : 'bbbb',
\   'author'      : {'name' : 'cccc', 'mail' : 'cc@cc.cc', 'date' : 'cc/cc/cc cc:cc:cc', 'time' : '12345'},
\   'committer'   : {'name' : 'dddd', 'mail' : 'dd@dd.dd', 'date' : 'dd/dd/dd dd:dd:dd', 'time' : '12345'},
\   'subject'     : 'eeee',
\ }])
  call self.assert_match(
\   'log -4321 --graph --date=default --pretty=format:".\+" ',
\   b:system_called_with
\ )
  call self.assert_equal(giti#log#list({'file' : 'hoge'}), [{
\   'graph'       : '* | | ',
\   'hash'        : 'aaaa',
\   'parent_hash' : 'bbbb',
\   'author'      : {'name' : 'cccc', 'mail' : 'cc@cc.cc', 'date' : 'cc/cc/cc cc:cc:cc', 'time' : '12345'},
\   'committer'   : {'name' : 'dddd', 'mail' : 'dd@dd.dd', 'date' : 'dd/dd/dd dd:dd:dd', 'time' : '12345'},
\   'subject'     : 'eeee',
\ }])
  call self.assert_match(
\   'log -1234 --graph --date=default --pretty=format:".\+" hoge',
\   b:system_called_with
\ )
endfunction "}}}

unlet s:tc

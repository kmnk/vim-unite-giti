let s:tc = unittest#testcase#new('autoload/giti/status.vim')

function! s:tc.SETUP() "{{{
endfunction "}}}
function! s:tc.TEARDOWN() "{{{
endfunction "}}}

function! s:tc.setup_list() "{{{
  function! giti#system(command) "{{{
    let b:system_called_with = a:command
    return 'DA hoge'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_list() "{{{
  function! giti#system(command) "{{{
    let b:system_called_with = a:command
    return 'mocked_system'
  endfunction "}}}
endfunction "}}}
function! s:tc.test_list() "{{{
  call self.assert_equal(
\   giti#status#list(),
\   [{
\     'description' : 'hoge',
\     'path1' : 'hoge',
\     'path2' : '',
\     'index' : 'Deleted',
\     'work'  : 'Added',
\   }]
\ )
  call self.assert_equal(b:system_called_with,
\                        'status -s')
  call self.assert_throw('E118', 'call giti#status#list("")')
endfunction "}}}

function! s:tc.setup_renamedlist() "{{{
  function! giti#system(command) "{{{
    let b:system_called_with = a:command
    return 'RA hoge -> fuga'
  endfunction "}}}
endfunction "}}}
function! s:tc.teardown_renamedlist() "{{{
  function! giti#system(command) "{{{
    let b:system_called_with = a:command
    return 'mocked_system'
  endfunction "}}}
endfunction "}}}
function! s:tc.test_renamedlist() "{{{
  call self.assert_equal(
\   giti#status#list(),
\   [{
\     'description' : 'hoge -> fuga',
\     'path1' : 'hoge',
\     'path2' : 'fuga',
\     'index' : 'Renamed',
\     'work'  : 'Added',
\   }]
\ )
endfunction "}}}

unlet s:tc

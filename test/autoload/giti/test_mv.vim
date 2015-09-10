let s:tc = unittest#testcase#new('autoloda/giti/mv.vim')

function! s:tc.SETUP() "{{{
endfunction "}}}
function! s:tc.TEARDOWN() "{{{
endfunction "}}}

function! s:tc.test_run() "{{{
  call giti#mv#run({
\   'source'      : 'hoge',
\   'destination' : 'fuga',
\ })
  call self.assert_match('mv hoge fuga', b:system_called_with)

  call giti#mv#run({
\   'source'                : 'hoge',
\   'destination_directory' : 'piyo',
\ })
  call self.assert_match('mv hoge ... piyo', b:system_called_with)

  call giti#mv#run({
\   'source'                : 'hoge',
\   'destination'           : 'fuga',
\   'destination_directory' : 'piyo',
\ })
  call self.assert_match('mv hoge fuga', b:system_called_with)

  call self.assert_throw('source is required', '
\   call giti#mv#run({"destination" : "fuga"})
\ ')

  call self.assert_throw('destination is required', '
\   call giti#mv#run({"source" : "hoge"})
\ ')

  call self.assert_throw('E118', 'call giti#mv#run("", "")')
  call self.assert_throw('E119', 'call giti#mv#run()')
endfunction "}}}

function! s:tc.test_force() "{{{
  call giti#mv#force({
\   'source'      : 'hoge',
\   'destination' : 'fuga',
\ })
  call self.assert_match('mv -f hoge fuga', b:system_called_with)

  call giti#mv#force({
\   'source'                : 'hoge',
\   'destination_directory' : 'piyo',
\ })
  call self.assert_match('mv -f hoge ... piyo', b:system_called_with)

  call giti#mv#force({
\   'source'                : 'hoge',
\   'destination'           : 'fuga',
\   'destination_directory' : 'piyo',
\ })
  call self.assert_match('mv -f hoge fuga', b:system_called_with)

  call self.assert_throw('source is required', '
\   call giti#mv#force({"destination" : "fuga"})
\ ')

  call self.assert_throw('destination is required', '
\   call giti#mv#force({"source" : "hoge"})
\ ')

  call self.assert_throw('E118', 'call giti#mv#force("", "")')
  call self.assert_throw('E119', 'call giti#mv#force()')
endfunction "}}}

function! s:tc.test_verbose() "{{{
  call giti#mv#verbose({
\   'source'      : 'hoge',
\   'destination' : 'fuga',
\ })
  call self.assert_match('mv -v hoge fuga', b:system_called_with)

  call giti#mv#verbose({
\   'source'                : 'hoge',
\   'destination_directory' : 'piyo',
\ })
  call self.assert_match('mv -v hoge ... piyo', b:system_called_with)

  call giti#mv#verbose({
\   'source'                : 'hoge',
\   'destination'           : 'fuga',
\   'destination_directory' : 'piyo',
\ })
  call self.assert_match('mv -v hoge fuga', b:system_called_with)

  call self.assert_throw('source is required', '
\   call giti#mv#verbose({"destination" : "fuga"})
\ ')

  call self.assert_throw('destination is required', '
\   call giti#mv#verbose({"source" : "hoge"})
\ ')

  call self.assert_throw('E118', 'call giti#mv#verbose("", "")')
  call self.assert_throw('E119', 'call giti#mv#verbose()')
endfunction "}}}

unlet s:tc

let s:tc = unittest#testcase#new('autoload/giti/branch_recent.vim')

function! s:tc.SETUP() "{{{
  function! giti#system(command) "{{{
    let b:system_called_with = a:command
    return "branch-recent,2 hours ago,89abcde,second commit\nmaster,9 weeks ago,1234567,initial commit"
  endfunction "}}}
endfunction "}}}

function! s:tc.test_recent() "{{{
  call self.assert_equal(
\   [
\     {
\       'name'         : 'branch-recent ',
\       'relativedate' : '2 hours ago ',
\       'objectname'   : '89abcde',
\       'message'      : 'second commit',
\     },
\     {
\       'name'         : 'master        ',
\       'relativedate' : '9 weeks ago ',
\       'objectname'   : '1234567',
\       'message'      : 'initial commit',
\     }
\   ],
\   giti#branch_recent#recent(),
\ )
  call self.assert_equal(
\   'for-each-ref --sort=-committerdate --count=30 --format="%(refname:short),%(committerdate:relative),%(objectname:short),%(contents:subject)" refs/heads/',
\   b:system_called_with)
endfunction "}}}

unlet s:tc

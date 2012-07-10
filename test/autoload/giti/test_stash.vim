let s:tc = unittest#testcase#new('autoload/giti/stash.vim')

function! s:tc.SETUP()"{{{
endfunction"}}}
function! s:tc.TEARDOWN()"{{{
endfunction"}}}

function! s:tc.test_list()"{{{
  call self.assert_equal('mocked_system', giti#stash#list())
  call self.assert_equal('stash list', b:system_called_with)
  call self.assert_throw('E118', 'call giti#stash#list("")')
endfunction"}}}

function! s:tc.test_show()"{{{
  call self.assert(1)
endfunction"}}}

function! s:tc.test_drop()"{{{
  call self.assert(1)
endfunction"}}}

function! s:tc.test_pop()"{{{
  call self.assert(1)
endfunction"}}}

function! s:tc.test_apply()"{{{
  call self.assert(1)
endfunction"}}}

function! s:tc.test_branch()"{{{
  call self.assert(1)
endfunction"}}}

function! s:tc.test_save()"{{{
  call self.assert(1)
endfunction"}}}

function! s:tc.test_clear()"{{{
  call self.assert(1)
endfunction"}}}

unlet s:tc

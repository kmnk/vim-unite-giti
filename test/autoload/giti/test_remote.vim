let s:tc = unittest#testcase#new('autoload/giti/remote.vim')

function! s:tc.SETUP()"{{{
endfunction"}}}
function! s:tc.TEARDOWN()"{{{
endfunction"}}}

function! s:tc.test_show()"{{{
  call self.assert(1)
endfunction"}}}

function! s:tc.test_show_verbose()"{{{
  call self.assert(1)
endfunction"}}}

function! s:tc.test_add()"{{{
  call self.assert(1)
endfunction"}}}

function! s:tc.test_rename()"{{{
  call self.assert(1)
endfunction"}}}

function! s:tc.test_rm()"{{{
  call self.assert(1)
endfunction"}}}

function! s:tc.test_set_head()"{{{
  call self.assert(1)
endfunction"}}}

function! s:tc.test_set_branches()"{{{
  call self.assert(1)
endfunction"}}}

function! s:tc.test_set_url()"{{{
  call self.assert(1)
endfunction"}}}

function! s:tc.test_set_prune()"{{{
  call self.assert(1)
endfunction"}}}

function! s:tc.test_set_update()"{{{
  call self.assert(1)
endfunction"}}}

function! s:tc.test_sample()"{{{
  call self.assert(1)
endfunction"}}}

unlet s:tc

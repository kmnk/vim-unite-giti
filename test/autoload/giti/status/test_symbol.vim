let s:tc = unittest#testcase#new('autoload/giti/status/symbol.vim')

function! s:tc.SETUP() "{{{
endfunction "}}}
function! s:tc.TEARDOWN() "{{{
endfunction "}}}

function! s:tc.test_name_of() "{{{
  call self.assert_equal(giti#status#symbol#name_of(' '), 'Unmodified')
  call self.assert_equal(giti#status#symbol#name_of('M'), 'Modified')
  call self.assert_equal(giti#status#symbol#name_of('A'), 'Added')
  call self.assert_equal(giti#status#symbol#name_of('D'), 'Deleted')
  call self.assert_equal(giti#status#symbol#name_of('R'), 'Renamed')
  call self.assert_equal(giti#status#symbol#name_of('C'), 'Copied')
  call self.assert_equal(giti#status#symbol#name_of('U'), 'Unmerged')
  call self.assert_equal(giti#status#symbol#name_of('?'), 'Untracked')
  call self.assert_throw('Unknown symbol',
\                        'call giti#status#symbol#name_of("H")')
  call self.assert_throw('E118', 'call giti#status#symbol#name_of("", "")')
  call self.assert_throw('E119', 'call giti#status#symbol#name_of()')
endfunction "}}}

function! s:tc.test_symbol_of() "{{{
  call self.assert_equal(giti#status#symbol#symbol_of('Unmodified'), ' ')
  call self.assert_equal(giti#status#symbol#symbol_of('Modified'),   'M')
  call self.assert_equal(giti#status#symbol#symbol_of('Added'),      'A')
  call self.assert_equal(giti#status#symbol#symbol_of('Deleted'),    'D')
  call self.assert_equal(giti#status#symbol#symbol_of('Renamed'),    'R')
  call self.assert_equal(giti#status#symbol#symbol_of('Copied'),     'C')
  call self.assert_equal(giti#status#symbol#symbol_of('Unmerged'),   'U')
  call self.assert_equal(giti#status#symbol#symbol_of('Untracked'),  '?')
  call self.assert_throw('Unknown name',
\                        'call giti#status#symbol#symbol_of("Hoge")')
  call self.assert_throw('E118', 'call giti#status#symbol#symbol_of("", "")')
  call self.assert_throw('E119', 'call giti#status#symbol#symbol_of()')
endfunction "}}}

function! s:tc.test_is_valid_symbol() "{{{
  call self.assert(giti#status#symbol#is_valid_symbol('A'))
  call self.assert(giti#status#symbol#is_valid_symbol(' '))
  call self.assert_not(giti#status#symbol#is_valid_symbol(''))
  call self.assert_not(giti#status#symbol#is_valid_symbol('H'))
  call self.assert_throw('E118', 'call giti#status#symbol#is_valid_symbol("", "")')
  call self.assert_throw('E119', 'call giti#status#symbol#is_valid_symbol()')
endfunction "}}}

function! s:tc.test_is_valid_name() "{{{
  call self.assert(giti#status#symbol#is_valid_name('Added'))
  call self.assert(giti#status#symbol#is_valid_name('Unmodified'))
  call self.assert_not(giti#status#symbol#is_valid_name(''))
  call self.assert_not(giti#status#symbol#is_valid_name('Hoge'))
  call self.assert_throw('E118', 'call giti#status#symbol#is_valid_name("", "")')
  call self.assert_throw('E119', 'call giti#status#symbol#is_valid_name()')
endfunction "}}}

function! s:tc.test_is_unmodified() "{{{
  call self.assert(giti#status#symbol#is_unmodified(' '))
  call self.assert_not(giti#status#symbol#is_unmodified('H'))
  call self.assert_throw('E118', 'call giti#status#symbol#is_unmodified("", "")')
  call self.assert_throw('E119', 'call giti#status#symbol#is_unmodified()')
endfunction

function! s:tc.test_is_modified() "{{{
  call self.assert(giti#status#symbol#is_modified('M'))
  call self.assert_not(giti#status#symbol#is_modified('H'))
  call self.assert_throw('E118', 'call giti#status#symbol#is_modified("", "")')
  call self.assert_throw('E119', 'call giti#status#symbol#is_modified()')
endfunction

function! s:tc.test_is_added() "{{{
  call self.assert(giti#status#symbol#is_added('A'))
  call self.assert_not(giti#status#symbol#is_added('H'))
  call self.assert_throw('E118', 'call giti#status#symbol#is_added("", "")')
  call self.assert_throw('E119', 'call giti#status#symbol#is_added()')
endfunction

function! s:tc.test_is_deleted() "{{{
  call self.assert(giti#status#symbol#is_deleted('D'))
  call self.assert_not(giti#status#symbol#is_deleted('H'))
  call self.assert_throw('E118', 'call giti#status#symbol#is_deleted("", "")')
  call self.assert_throw('E119', 'call giti#status#symbol#is_deleted()')
endfunction

function! s:tc.test_is_renamed() "{{{
  call self.assert(giti#status#symbol#is_renamed('R'))
  call self.assert_not(giti#status#symbol#is_renamed('H'))
  call self.assert_throw('E118', 'call giti#status#symbol#is_renamed("", "")')
  call self.assert_throw('E119', 'call giti#status#symbol#is_renamed()')
endfunction

function! s:tc.test_is_copied() "{{{
  call self.assert(giti#status#symbol#is_copied('C'))
  call self.assert_not(giti#status#symbol#is_copied('H'))
  call self.assert_throw('E118', 'call giti#status#symbol#is_copied("", "")')
  call self.assert_throw('E119', 'call giti#status#symbol#is_copied()')
endfunction

function! s:tc.test_is_unmerged() "{{{
  call self.assert(giti#status#symbol#is_unmerged('U'))
  call self.assert_not(giti#status#symbol#is_unmerged('H'))
  call self.assert_throw('E118', 'call giti#status#symbol#is_unmerged("", "")')
  call self.assert_throw('E119', 'call giti#status#symbol#is_unmerged()')
endfunction

function! s:tc.test_is_untracked() "{{{
  call self.assert(giti#status#symbol#is_untracked('?'))
  call self.assert_not(giti#status#symbol#is_untracked('H'))
  call self.assert_throw('E118', 'call giti#status#symbol#is_untracked("", "")')
  call self.assert_throw('E119', 'call giti#status#symbol#is_untracked()')
endfunction

unlet s:tc

let s:here = expand('<sfile>:p:h')
execute 'source' s:here . '/branch/test_all.vim'
execute 'source' s:here . '/test_branch.vim'
execute 'source' s:here . '/test_config.vim'

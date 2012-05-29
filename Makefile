# Makefile
.PHONEY: test_all test_autoload

test_all:
	vim -u ./dot.vimrc.test -N +UnitTest test/test_all.vim

test_autoload:
	vim -u ./dot.vimrc.test -N +UnitTest test/autoload/test_all.vim

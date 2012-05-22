# Makefile
.PHONY: test

test:
	vim -u ./dot.vimrc.test -N +UnitTest ./test/test_all.vim

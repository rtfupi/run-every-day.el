EMACS ?= emacs

all: compile


compile:
	exec ${EMACS} -Q -batch -f batch-byte-compile run-every-day.el

clean-elc:
	rm -f run-every-day.elc

.PHONY: all compile clean-elc

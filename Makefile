PROG ?= dist/build/sm/sm

.PHONY: test bench linecount clean

$(PROG): Markdown.hs bin/markdown.hs
	cabal configure --user && cabal build

test: $(PROG)
	make -C tests --quiet clean all

bench: $(PROG)
	time $< tests/Original/Markdown_Documentation_Syntax.markdown >/dev/null
	time ../peg-markdown/markdown tests/Original/Markdown_Documentation_Syntax.markdown >/dev/null
	time pandoc tests/Original/Markdown_Documentation_Syntax.markdown >/dev/null
	time Markdown.pl tests/Original/Markdown_Documentation_Syntax.markdown >/dev/null

linecount:
	@echo "Non-comment, non-blank lines:" ; \
	grep '^[^-]' Markdown.hs | wc -l

clean:
	cabal clean && make -C tests clean

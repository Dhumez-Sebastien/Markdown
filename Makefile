PROG ?= dist/build/sm/sm

.PHONY: all test bench linecount clean

all: $(PROG)
	cabal configure --user && cabal build

test: $(PROG)
	make -C tests --quiet clean all

bench: $(PROG)
	time $< tests/Original/Markdown_Documentation_Syntax.markdown >/dev/null
	time ../peg-markdown/markdown tests/Original/Markdown_Documentation_Syntax.markdown >/dev/null

linecount:
	@echo "Non-comment, non-blank lines:" ; \
	grep '^[^-]' Markdown.hs | wc -l

clean:
	-@rm *.o *.hi bin/markdown bin/markdown-prof bin/markdown-opt \
	  bin/*.o bin/*.hi; \
	  make -C tests clean

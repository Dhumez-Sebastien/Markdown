PROG ?= dist/build/sm/sm
BENCHRUNS ?= 10
BENCHPROGS ?= ../peg-markdown/markdown pandoc Markdown.pl
.PHONY: test bench linecount clean

$(PROG): Markdown.hs bin/markdown.hs
	cabal configure --user && cabal build

test: $(PROG)
	make -C tests --quiet clean all

bench: $(PROG)
	for prog in $(PROG) $(BENCHPROGS); do \
	   echo; \
	   echo "Benchmarking $$prog"; \
	     time for i in {1..$(BENCHRUNS)}; do \
	       $$prog tests/Original/Markdown_Documentation_Syntax.markdown; \
	     done > /dev/null; \
	done

linecount:
	@echo "Non-comment, non-blank lines:" ; \
	grep '^[^-]' Markdown.hs | wc -l

clean:
	cabal clean && make -C tests clean

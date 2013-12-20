PROG ?= dist/build/sm/sm
BENCHPROGS ?= ../peg-markdown/markdown pandoc Markdown.pl
.PHONY: prof test bench linecount clean

$(PROG): Markdown.hs bin/sm.hs
	cabal configure --user && cabal build

prof:
	cabal configure --enable-library-profiling --enable-executable-profiling --user && cabal build ; \
	  echo "To profile:  dist/build/sm/sm +RTS -pa -V0.0002 -RTS"

test:
	make -C tests --quiet clean all

bench:
	for prog in $(PROG) $(BENCHPROGS); do \
	   echo; \
	   echo "Benchmarking $$prog"; \
	     time for i in tests/*/*.markdown; do \
	       cat $$i | $$prog >/dev/null ; \
	       done ; \
	done

linecount:
	@echo "Non-comment, non-blank lines:" ; \
	grep '^[^-]' Markdown.hs | wc -l

clean:
	cabal clean && make -C tests clean

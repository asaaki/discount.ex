ERLANG_PATH:=$(shell erl -eval 'io:format("~s~n", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)
CFLAGS_DISCOUNT=-g -fPIC
CFLAGS=$(CFLAGS_DISCOUNT) -Idiscount_src
ERLANG_FLAGS=-I$(ERLANG_PATH)
CC?=clang
CXX?=clang++
EBIN_DIR=ebin

ifeq ($(shell uname),Darwin)
	OPTIONS=-dynamiclib -undefined dynamic_lookup
endif

DISCOUNT_OBJS=\
	discount_src/mkdio.o \
	discount_src/markdown.o \
	discount_src/dumptree.o \
	discount_src/generate.o \
	discount_src/resource.o \
	discount_src/docheader.o \
	discount_src/version.o \
	discount_src/toc.o \
	discount_src/css.o \
	discount_src/xml.o \
	discount_src/Csio.o \
	discount_src/xmlpage.o \
	discount_src/basename.o \
	discount_src/emmatch.o \
	discount_src/github_flavoured.o \
	discount_src/setup.o \
	discount_src/tags.o \
	discount_src/html5.o \
	discount_src/flags.o \
	discount_src/amalloc.o

all: discount_ex

discount_ex:
	mix deps.get
	mix compile

cbin/markdown: discount_src/libmarkdown.a
	mkdir -p cbin && cp discount_src/markdown cbin/

discount_src/libmarkdown.a: discount_src/configure.sh
	cd discount_src && \
	CFLAGS="$(CFLAGS_DISCOUNT)" ./configure.sh \
		--with-dl=Both \
		--with-id-anchor \
		--with-github-tags \
		--with-fenced-code \
		--enable-all-features && \
	CFLAGS="$(CFLAGS_DISCOUNT)" $(MAKE)

discount_src/configure.sh:
	git submodule update --init

discount_src-clean:
	test ! -f discount_src/libmarkdown.a || \
	  (cd discount_src && $(MAKE) clean)

discount_src-distclean:
	test ! -f discount_src/Makefile || \
	  (cd discount_src && \
	  	$(MAKE) distclean && \
	  	git clean -d -f -x)

discount_ex-clean:
	rm -rf $(EBIN_DIR) test/tmp cbin share/*

clean: discount_src-clean discount_ex-clean

distclean: discount_src-distclean discount_ex-clean

.PHONY: all discount_ex clean distclean discount_src-clean discount_src-distclean

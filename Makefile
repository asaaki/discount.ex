ERLANG_PATH:=$(shell erl -eval 'io:format("~s~n", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)
CFLAGS_DISCOUNT=-g -fPIC -O2
CFLAGS=$(CFLAGS_DISCOUNT) -Idiscount_src
ERLANG_FLAGS=-I$(ERLANG_PATH)
CC?=clang
EBIN_DIR=ebin

ifeq ($(shell uname),Darwin)
	OPTIONS=-dynamiclib -undefined dynamic_lookup
endif

NIF_SRC=\
	src/markdown_nif.c

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
	discount_src/flags.o

DISCOUNT_LIB=discount_src/libmarkdown.a

all: discount_ex

priv/markdown.so: ${DISCOUNT_LIB} ${NIF_SRC}
	mkdir -p priv && \
	$(CC) $(CFLAGS) $(ERLANG_FLAGS) -shared $(OPTIONS) \
		$(DISCOUNT_OBJS) \
		$(NIF_SRC) \
		-o $@ 2>&1 >/dev/null

discount_ex:
	mix compile

$(DISCOUNT_LIB): discount_src/configure.sh
	cd discount_src && \
	CFLAGS="$(CFLAGS_DISCOUNT)" ./configure.sh \
		--with-dl=Both \
		--with-id-anchor \
		--with-github-tags \
		--with-fenced-code 2>&1 >/dev/null && \
	CFLAGS="$(CFLAGS_DISCOUNT)" $(MAKE) 2>&1 >/dev/null

discount_src/configure.sh:
	git submodule update --init

discount_src-clean:
	test ! -f $(DISCOUNT_LIB) || \
	  (cd discount_src && $(MAKE) clean)

discount_src-distclean:
	test ! -f discount_src/Makefile || \
	  (cd discount_src && \
	  	$(MAKE) distclean && \
	  	git clean -d -f -x)

discount_ex-clean:
	rm -rf $(EBIN_DIR) test/tmp share/* _build

discount_nif-clean:
	rm -rf priv/markdown.*

docs:
	@MIX_ENV=docs mix docs

docs-clean:
	rm -rf docs

### PUBLISH

publish: publish-code publish-docs

publish-code:
	@mix hex.publish

publish-docs:
	@MIX_ENV=docs mix hex.docs

### TEST

spec: all
	@mix deps.get
	@mix test

test: spec

clean: discount_src-clean discount_ex-clean discount_nif-clean docs-clean

distclean: discount_src-distclean discount_ex-clean discount_nif-clean docs-clean

.PHONY: all discount_ex clean distclean discount_src-clean discount_src-distclean docs docs-clean publish publish-code publish-docs spec test

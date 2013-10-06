ERLANG_PATH:=$(shell erl -eval 'io:format("~s~n", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)
CFLAGS_DISCOUNT=-g -O3 -fPIC
CFLAGS=$(CFLAGS_DISCOUNT) -Idiscount
ERLANG_FLAGS=-I$(ERLANG_PATH)
CC?=clang
CXX?=clang++
EBIN_DIR=ebin

ifeq ($(shell uname),Darwin)
	OPTIONS=-dynamiclib -undefined dynamic_lookup
endif

DISCOUNT_OBJS=\
	discount/mkdio.o \
	discount/markdown.o \
	discount/dumptree.o \
	discount/generate.o \
	discount/resource.o \
	discount/docheader.o \
	discount/version.o \
	discount/toc.o \
	discount/css.o \
	discount/xml.o \
	discount/Csio.o \
	discount/xmlpage.o \
	discount/basename.o \
	discount/emmatch.o \
	discount/github_flavoured.o \
	discount/setup.o \
	discount/tags.o \
	discount/html5.o \
	discount/flags.o \
	discount/amalloc.o
	# discount/libmarkdown.a

NIF_SRC=\
	src/discount_nif.c


all: discount

discount: share/discount.so
	mix compile

share/discount.so: discount/libmarkdown.a ${NIF_SRC}
	mkdir -p share && \
	$(CC) $(CFLAGS) $(ERLANG_FLAGS) -shared $(OPTIONS) -o $@ $(DISCOUNT_OBJS) $(NIF_SRC)

discount/libmarkdown.a: discount-submodule discount-configure discount-build

discount-submodule:
	@echo Check and update submodule ...
	git submodule update --init
	@echo

discount-configure:
	@echo Configure discount ...
	cd discount && \
	CFLAGS="$(CFLAGS_DISCOUNT)" ./configure.sh \
		--with-dl=Both --with-id-anchor --with-github-tags --with-fenced-code --enable-all-features
	@echo

discount-build:
	@echo Build discount ...
	cd discount && CFLAGS="$(CFLAGS_DISCOUNT)" $(MAKE)
	@echo

discount-clean:
	test ! -f discount/markdown.o || \
	  (cd discount && $(MAKE) clean)

discount-distclean:
	test ! -f discount/Makefile || \
	  (cd discount && $(MAKE) distclean)
	rm -f discount/blocktags librarian.sh mktags

discountex-clean:
	rm -rf $(EBIN_DIR)
	rm -rf test/tmp
	rm -rf share
	@ echo

clean: discount-clean discountex-clean

distclean: discount-distclean discountex-clean

.PHONY: clean

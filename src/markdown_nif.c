#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <time.h>
#include <ctype.h>

#include "erl_nif.h"

#include "config.h"
#include "cstring.h"
#include "tags.h"
#include "mkdio.h"

static ERL_NIF_TERM markdown_to_html_nif(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]) {

  ErlNifBinary  markdown_binary;
  ErlNifBinary  output_binary;
  mkd_flag_t    flags            = 0 | MKD_AUTOLINK | MKD_TABSTOP| MKD_NOHEADER ;
  MMIOT        *doc;

  if (argc != 1) {
    return enif_make_badarg(env);
  }

  if(!enif_inspect_binary(env, argv[0], &markdown_binary)){
    return enif_make_badarg(env);
  }

  if (markdown_binary.size <= 0){
    const char *empty_string = "";
    const int   empty_len    = strlen(empty_string);
    enif_alloc_binary(empty_len, &output_binary);
    strncpy((char*)output_binary.data, empty_string, empty_len);
    return enif_make_binary(env, &output_binary);
  }

  doc = gfm_string((char*)markdown_binary.data, markdown_binary.size, flags);

  if(doc && mkd_compile(doc, flags)) {
      char *output_text;
      int   output_len   = mkd_document(doc, &output_text);

      enif_alloc_binary(output_len, &output_binary);
      strncpy((char*)output_binary.data, output_text, output_len);

      mkd_cleanup(doc);
      enif_release_binary(&markdown_binary);
      return enif_make_binary(env, &output_binary);
  }

  // everything else is an error
  enif_release_binary(&markdown_binary);
  enif_release_binary(&output_binary);
  return enif_make_badarg(env);
}

static ErlNifFunc nif_funcs[] = {
  { "nif_to_html", 1, markdown_to_html_nif }
};

ERL_NIF_INIT(Elixir.Discount.Markdown, nif_funcs, NULL, NULL, NULL, NULL);

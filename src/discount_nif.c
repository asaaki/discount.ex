#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "erl_nif.h"
#include "mkdio.h"

static ERL_NIF_TERM to_markdown_nif(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]) {
  ErlNifBinary  md_input;
  ErlNifBinary  parsed;
  int           flags = 0 | MKD_AUTOLINK;
  MMIOT         *tmp_md_doc;

  if (argc != 1) {
    return enif_make_badarg(env);
  }
  if (enif_inspect_binary(env, argv[0], &md_input) == 0 || md_input.size == 0U) {
    return enif_make_badarg(env);
  }

  tmp_md_doc = mkd_string((const char*)md_input.data, md_input.size, MKD_TABSTOP|MKD_NOHEADER);

  if (mkd_compile(tmp_md_doc, flags)) {
    char  *result;
    int   result_size = mkd_document(tmp_md_doc, &result);

    enif_alloc_binary(result_size, &parsed);
    memcpy(parsed.data, result, result_size);
    mkd_cleanup(tmp_md_doc);

  } else {
    mkd_cleanup(tmp_md_doc);
    return enif_make_badarg(env);
  }

  return enif_make_binary(env, &parsed);
}

static ErlNifFunc nif_funcs[] = { { "to_html", 1, to_markdown_nif } };

ERL_NIF_INIT(Elixir.Discount.Discount, nif_funcs, NULL, NULL, NULL, NULL);

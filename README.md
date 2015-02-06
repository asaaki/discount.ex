# Discount.ex

[![Hex.pm package version](https://img.shields.io/hexpm/v/discount.svg?style=flat-square)](https://hex.pm/packages/discount)
[![Hex.pm package license](https://img.shields.io/hexpm/l/discount.svg?style=flat-square)](https://github.com/asaaki/discount.ex/blob/master/LICENSE)
[![Build Status (master)](https://img.shields.io/travis/asaaki/discount.ex/master.svg?style=flat-square)](https://travis-ci.org/asaaki/discount.ex)
[![Support via Gratipay](http://img.shields.io/gratipay/asaaki.svg?style=flat-square)](https://gratipay.com/asaaki)

Elixir NIF for **discount**, a Markdown parser ([GH: Orc/discount](https://github.com/Orc/discount)).

----

**I recommend to use a strongly specified implementation of Markdown called CommonMark!**

An Elixir library exists at [GitHub: asaaki/cmark.ex](https://github.com/asaaki/cmark.ex), the Hex package at <https://hex.pm/packages/cmark>.

More about the reason can be read at <http://commonmark.org/>.

----



## Add dependency (with `hex`)

```elixir
{ :discount, "~> 0.7" }
```



## Use

```shell
make
iex -S mix
```

```elixir
Discount.to_html "## markdown string"
#=> "<h2>markdown string</h2>"

# Alternatively pass the compiled document to a function:
Discount.to_html "## markdown string", fn (html) ->
  do_something_with(html)
end
```



## License

[MIT/X11](./LICENSE)

Copyright (c) 2013—2015 Christoph Grabo

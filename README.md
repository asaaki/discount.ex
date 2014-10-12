# Discount.ex

[![build status](https://travis-ci.org/asaaki/discount.ex.svg?branch=master)](https://travis-ci.org/asaaki/discount.ex)

Elixir NIF for **discount**, a Markdown parser ([GH: Orc/discount](https://github.com/Orc/discount)).

- [hex.pm/packages/discount](https://hex.pm/packages/discount)
- [hexdocs.pm/discount](http://hexdocs.pm/discount/)



## Add dependency (with `hex`)

```elixir
{ :discount, "~> 0.6.1" }
```



## Test

```shell
make test
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

See [test examples](https://github.com/asaaki/discount.ex/blob/0.6.1/test/discount_test.exs) for more detailed usage.



## License

[MIT/X11](./LICENSE)

Copyright (c) 2013—2014 Christoph Grabo

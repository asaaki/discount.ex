# Discount.ex

Elixir NIF of **discount**, a Markdown parser/converter ([GH: Orc/discount](https://github.com/Orc/discount)).



## Clone

```shell
git clone https://github.com/asaaki/discount.ex.git discount
```



## Build and test

```shell
mix compile
mix test
```

```shell
iex -pa ebin
```

```elixir
Discount.Discount.to_html "## markdown string"
```



## License

[MIT/X11](./LICENSE)

Copyright (c) 2013 Christoph Grabo

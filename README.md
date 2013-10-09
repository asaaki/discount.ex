# Discount.ex

Elixir Wrapper for **discount**, a Markdown parser/converter ([GH: Orc/discount](https://github.com/Orc/discount)).



## Clone

```shell
git clone https://github.com/asaaki/discount.ex.git discount
```



## Build and test

```shell
make
mix test
```

```shell
iex -S mix
```

```elixir
# my_callback_function/1
# result format: [{ <status symbol>, result_or_error_string }]
Discount.to_html "## markdown string", my_callback_function
```


See [tests](./test/discount_test.exs) for example usage.


## License

[MIT/X11](./LICENSE)

Copyright (c) 2013 Christoph Grabo

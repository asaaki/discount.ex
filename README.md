# Discount.ex [![build status](https://travis-ci.org/asaaki/discount.ex.png?branch=master)](https://travis-ci.org/asaaki/discount.ex)

[expm.co/discount](http://expm.co/discount)

Elixir NIF for **discount**, a Markdown parser ([GH: Orc/discount](https://github.com/Orc/discount)).



## Clone

```shell
git clone https://github.com/asaaki/discount.ex.git discount
```



## Build and test

__Run tests (will also build if not already done via `make`):__

```shell
mix test
```

__Run a IEx shell with library compiled and loaded:__

```shell
iex -S mix
```

```elixir
result = Discount.to_html "## markdown string"
# or
Discount.to_html "## markdown string", my_callback_function_taking_one_argument
```


See [test examples](./test/discount_test.exs) for usage.


## License

[MIT/X11](./LICENSE)

Copyright (c) 2013 Christoph Grabo


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/asaaki/discount.ex/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

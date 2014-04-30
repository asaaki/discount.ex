# Discount.ex [![build status](https://travis-ci.org/asaaki/discount.ex.svg?branch=master)](https://travis-ci.org/asaaki/discount.ex)

Elixir NIF for **discount**, a Markdown parser ([GH: Orc/discount](https://github.com/Orc/discount)).

- [hex.pm/packages/discount](https://hex.pm/packages/discount) (`>= 0.5.0`)
- [expm.co/discount](http://expm.co/discount) (`<= 0.4.0`)



## Add dependency (with `hex`)

```elixir
  defp deps do
    [
      { :discount, "~> 0.5.1" }
    ]
  end
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


See [test examples](./test/discount_test.exs) for more detailed usage.


## License

[MIT/X11](./LICENSE)

Copyright (c) 2013—2014 Christoph Grabo

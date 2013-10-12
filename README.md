# Discount.ex [![build status](https://travis-ci.org/asaaki/discount.ex.png?branch=master)](https://travis-ci.org/asaaki/discount.ex)

[expm.co/discount](http://expm.co/discount)

Elixir wrapper for **discount**, a Markdown parser ([GH: Orc/discount](https://github.com/Orc/discount)).



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


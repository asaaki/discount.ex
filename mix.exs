Code.ensure_loaded?(Hex) and Hex.start

defmodule Mix.Tasks.Compile.Discount do
  @shortdoc "Compiles discount library"
  def run(_) do
    Mix.shell.info System.cmd("make priv/markdown.so")
  end
end

defmodule Discount.Mixfile do
  use Mix.Project

  def project do
    [
      app:         :discount,
      version:     "0.5.0",
      elixir:      "~> 0.13.0",
      compilers:   [:discount, :elixir, :app],
      deps:        deps(Mix.env),
      package:     package,
      description: description
    ]
  end

  def application, do: []

  defp description do
    """
    Elixir NIF for discount, a Markdown parser (https://github.com/Orc/discount)
    """
  end

  defp package do
    [
      contributors: ["Christoph Grabo"],
      licenses:     ["MIT"],
      links:        [github: "https://github.com/asaaki/discount.ex"],
      files:        [
        "lib",
        "src",
        "discount_src",
        "priv",
        "Makefile",
        "mix.exs",
        "README.md",
        "LICENSE"]
    ]
  end

  defp deps(_) do
    [{ :ex_doc, github: "elixir-lang/ex_doc" }]
  end
end

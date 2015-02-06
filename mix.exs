Code.ensure_loaded?(Hex) and Hex.start

defmodule Mix.Tasks.Compile.Discount do
  @shortdoc "Compiles discount library"
  def run(_) do
    if Mix.shell.cmd("make priv/markdown.so") != 0 do
      raise Mix.Error, message: "could not run `make priv/markdown.so`. Do you have make and gcc installed?"
    end
  end
end

defmodule Discount.Mixfile do
  use Mix.Project

  def project do
    [
      app:          :discount,
      version:      "0.7.0",
      elixir:       "~> 1.0",
      compilers:    [:discount, :elixir, :app],
      deps:         deps,
      package:      package,
      description:  "Elixir NIF for discount, a Markdown parser",
      name:         "discount",
      source_url:   "https://github.com/asaaki/discount.ex",
      homepage_url: "http://hexdocs.pm/discount",
      docs:         docs
    ]
  end

  def application, do: []

  defp package do
    [
      contributors: ["Christoph Grabo"],
      licenses:     ["MIT"],
      links: %{
        "GitHub" => "https://github.com/asaaki/discount.ex",
        "Issues" => "https://github.com/asaaki/discount.ex/issues",
        "Docs"   => "http://hexdocs.pm/discount/"
      },
      files: [
        "lib",
        "src",
        "discount_src",
        "priv",
        "Makefile",
        "mix.exs",
        "README.md",
        "LICENSE"
      ]
    ]
  end

  defp docs do
    {ref, 0} = System.cmd("git", ["rev-parse", "--verify", "--quiet", "HEAD"])
    [
      source_ref: ref,
      readme:     "README.md",
      main:       "README"
    ]
  end


  defp deps do
    [
      { :excoveralls, nil, only: [:dev, :test] },
      { :poison,      nil, only: [:dev, :test] },
      { :ex_doc,      nil, only: :docs },
      { :earmark,     nil, only: :docs },
      { :inch_ex,     nil, only: :docs }
    ]
  end
end

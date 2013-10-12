Expm.Package.new(
  name:        "discount",
  description: "Discount.ex - Elixir wrapper for discount, a Markdown parser",
  version:     "0.1.0",

  keywords:     [
                  "markdown",
                  "discount",
                  "parser",
                  "wrapper"
                ],
  maintainers:  [
                  [
                    name: "Christoph Grabo",
                    email: "chris@dinarrr.com"
                  ]
                ],
  repositories: [
                  [ github: "asaaki/discount.ex", tag: "0.1.0" ]
                ],
  dependencies: [
                  { "parallel", :head }
                ])

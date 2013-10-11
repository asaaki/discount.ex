Expm.Package.new(
  name:        "Discount.ex",
  description: "Elixir wrapper for discount, a Markdown parser",
  version:     :head,

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

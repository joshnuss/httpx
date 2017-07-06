# HTTPX

A tiny concurrent and fault-tolerant HTTP server.

## Usage

Create an app file:

```elixir
# in myapp.exs
defmodule MyApp do
  # handle the / path
  def call(%{path: "/"}),
    do: %{code: 200, type: "text/plain", body: "OMG Y'ALL!!"}

  # everything else is a 404 response
  def call(_),
    do: %{code: 404, body: "say what now?"}
end
```

Then, start the server

```shell
./httpx examples/myapp.exs --port 3000 &
curl localhost:3000
```

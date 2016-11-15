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

  # everything is a 404 response
  def call(_),
    do: %{code: 404, body: "oh dear, totally clueless"}
end
```

Then, start the server

```shell
httpx myapp.exs --port 8080
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `httpx` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:httpx, "~> 0.1.0"}]
    end
    ```

  2. Ensure `httpx` is started before your application:

    ```elixir
    def application do
      [applications: [:httpx]]
    end
    ```


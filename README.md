# HTTPX

A tiny concurrent HTTP server

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


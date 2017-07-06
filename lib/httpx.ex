defmodule HTTPX do
  use Application

  def start(_type, opts) do
    import Supervisor.Spec, warn: false

    name = Keyword.get(opts, :name) || Application.get_env(:httpx, :name)
    port = Keyword.get(opts, :port) || Application.get_env(:httpx, :port)

    children = [
      supervisor(Task.Supervisor, [[name: HTTPX.Request.Supervisor]]),
      worker(HTTPX.Server, [port, name])
    ]

    opts = [strategy: :one_for_one, name: HTTPX.Supervisor]

    Supervisor.start_link(children, opts)
  end
end

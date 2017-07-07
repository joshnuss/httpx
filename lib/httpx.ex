defmodule HTTPX do
  use Application

  def start(_type, {opts, [file|_]}) do
    import Supervisor.Spec, warn: false

    port = Keyword.get(opts, :port) || Application.get_env(:httpx, :port)

    app = HTTPX.CodeLoader.load(file)

    children = [
      supervisor(Task.Supervisor, [[name: HTTPX.Request.Supervisor]]),
      worker(HTTPX.Server, [port, app])
    ]

    opts = [strategy: :one_for_one, name: HTTPX.Supervisor]

    Supervisor.start_link(children, opts)
  end
end

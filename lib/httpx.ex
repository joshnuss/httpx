defmodule HTTPX do
  use Application

  def start(_type, {opts, [file|_]}) do
    import Supervisor.Spec, warn: false

    port = Keyword.get(opts, :port) || Application.get_env(:httpx, :port)
    app = HTTPX.CodeLoader.load(file)

    children = [
      {Task.Supervisor, name: HTTPX.Request.Supervisor},
      {HTTPX.Server, port: port, app: app}
    ]

    opts = [strategy: :one_for_one, name: HTTPX.Supervisor]

    Supervisor.start_link(children, opts)
  end
end

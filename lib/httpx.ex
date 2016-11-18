defmodule HTTPX do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Task.Supervisor, [[name: HTTPX.Request.Supervisor]]),
      worker(HTTPX.Server, [9000, :fake_app])
    ]

    opts = [strategy: :one_for_one, name: HTTPX.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

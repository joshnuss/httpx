defmodule HTTPX.Listener do
  require Logger

  alias HTTPX.Server

  @options [:binary, packet: :line, active: false, reuseaddr: true]

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end

  def start_link(opts) do
    app = Keyword.fetch!(opts, :app)
    port = Keyword.fetch!(opts, :port)

    {:ok, listener} = :gen_tcp.listen(port, @options)

    Logger.info("Accepting connections on port #{port}")

    pid = spawn fn -> loop(listener, app) end

    {:ok, pid}
  end

  defp loop(listener, app) do
    {:ok, socket} = :gen_tcp.accept(listener)

    Task.Supervisor.start_child(Server.Supervisor, Server, :serve, [socket, app])

    loop(listener, app)
  end
end

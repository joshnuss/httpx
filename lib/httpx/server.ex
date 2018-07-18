defmodule HTTPX.Server do
  require Logger

  alias HTTPX.Request

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

    {:ok, socket} = :gen_tcp.listen(port, @options)

    Logger.info("Accepting connections on port #{port}")

    pid = spawn fn -> loop(socket, app) end

    {:ok, pid}
  end

  defp loop(socket, app) do
    {:ok, client} = :gen_tcp.accept(socket)

    Task.Supervisor.start_child(Request.Supervisor, Request, :serve, [client, app])

    loop(socket, app)
  end
end

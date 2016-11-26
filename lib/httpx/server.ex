defmodule HTTPX.Server do
  require Logger

  alias HTTPX.Request

  @options [:binary, packet: :line, active: false, reuseaddr: true]

  def start_link(port, app) do
    {:ok, socket} = :gen_tcp.listen(port, @options)

    Logger.info("Accepting connections on port #{port}")

    loop(socket, app)
  end

  defp loop(socket, app) do
    {:ok, client} = :gen_tcp.accept(socket)

    Task.Supervisor.start_child(Request.Supervisor, Request, :serve, [client, app])

    loop(socket, app)
  end
end

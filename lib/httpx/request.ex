defmodule HTTPX.Request do
  require Logger

  @messages %{
    200 => "OK",
    404 => "Not Found",
    500 => "Internal Error"
  }

  def serve(client, handler) do
    client
    |> read
    |> parse
    |> process(handler)
    |> write(client)
  end

  defp read(socket) do
    {:ok, line} = :gen_tcp.recv(socket, 0)
    headers = read_headers(socket)

    {line, headers}
  end

  defp parse({line, headers}) do
    [verb, path, _version] = String.split(line)

    {path, query} = parse_path(path)

    %{verb: verb,
      path: path,
      query: query,
      headers: headers}
  end

  defp read_headers(socket, headers \\ []) do
    {:ok, line} = :gen_tcp.recv(socket, 0)

    case Regex.run(~r/(\w+): (.*)/, line) do
      [_line, key, value] -> [{key,  value}] ++ read_headers(socket, headers)
      _                   -> []
    end
  end

  defp parse_path(path) do
    case String.split(path, "?") do
      [path] -> {path, []}
      [path, query] -> {path, query}
    end
  end

  defp process(request, handler) do
    Logger.info "#{request.verb} #{request.path}"

    handler.(request)
  end

  defp write(response, socket) do
    preamble = """
    HTTP/1.1 #{response.code} #{message(response.code)}
    Date: #{:httpd_util.rfc1123_date}
    Content-Type: #{response.content_type}
    Content-Length: #{String.length(response.body)}
    """

    raw = preamble <> format_headers(response.headers) <> "\n\n" <> response.body

    :gen_tcp.send(socket, raw)
  end

  defp format_headers(headers),
    do: Enum.map_join(headers, "\n", &format_header/1)

  defp format_header({key, value}),
    do: "#{key}: #{value}"

  defp message(code), do: @messages[code] || "Unknown"
end
defmodule HTTPX.CLI do
  def main(args \\ []) do
    args
    |> parse
    |> boot

    Process.sleep(:infinity)
  end

  defp parse(args) do
    OptionParser.parse(args, switches: [port: :integer], aliases: [port: :p])
  end

  defp boot({opts, files, _}) do
    HTTPX.start(:transient, {opts, files})
  end
end

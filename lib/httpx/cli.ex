defmodule HTTPX.CLI do
  def main(args \\ []) do
    args
    |> parse
    |> boot
  end

  defp parse(args) do
    {opts, _word, _} = OptionParser.parse(args, switches: [port: :integer, name: :string], aliases: [port: :p])

    opts
  end

  defp boot(opts) do
    HTTPX.start(:transient, opts)
  end
end

defmodule HTTPX.CodeLoader do
  def load(path) do
    path
    |> Code.require_file(".")
    |> extract_module
  end

  defp extract_module([{mod, _}]), do: mod
end

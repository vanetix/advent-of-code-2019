defmodule Day1.Calculator do
  use Rustler, otp_app: :day_1, crate: :calculator

  @moduledoc false

  @doc """
  Calculate fuel required using native code.
  """
  def calculate(_), do: error()

  defp error(), do: :erlang.nif_error(:not_loaded)
end

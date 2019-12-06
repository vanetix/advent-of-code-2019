defmodule Day2.Vm do
  use Rustler, otp_app: :day_2, crate: :vm

  def run(_), do: error()

  defp error(), do: :erlang.nif_error(:vm_not_loaded)
end

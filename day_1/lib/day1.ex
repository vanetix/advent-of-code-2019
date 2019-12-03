defmodule Day1 do
  @moduledoc false

  @doc """
  Returns the required fuel for all modules in `input.txt`.

    iex> Day1.solution_1()
    3_372_695
  """
  def solution_1() do
    read_and_convert_input()
    |> Task.async_stream(Day1.Calculator, :calculate, [])
    |> Stream.map(fn {:ok, {:ok, fuel}} -> fuel end)
    |> Enum.sum()
  end

  @doc """
  Returns the required fuel for all modules in `input.txt` *and* computes fuel required
  to carry the additional fuel.

  iex> Day1.solution_2()
  5_056_172
  """
  def solution_2() do
    read_and_convert_input()
    |> Task.async_stream(&do_solution_2_calculation/1)
    |> Stream.map(fn {:ok, fuel} -> fuel end)
    |> Enum.sum()
  end

  defp read_and_convert_input() do
    :code.priv_dir(:day_1)
    |> Path.join("input.txt")
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn mass ->
      {m, ""} = Integer.parse(mass)

      m
    end)
  end

  defp do_solution_2_calculation(mass) do
    {:ok, fuel} = Day1.Calculator.calculate(mass)

    if fuel <= 0 do
      0
    else
      fuel + do_solution_2_calculation(fuel)
    end
  end
end

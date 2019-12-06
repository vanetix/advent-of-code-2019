defmodule Day2 do
  @moduledoc false

  @doc """
  Runs our computer against the operations contained in `input.txt`.

    iex> Day2.solution_1()
    4090689
  """
  def solution_1() do
    {:ok, [head | _]} =
      read_and_parse_input()
      |> Enum.map(fn
        {_, 1} -> 12
        {_, 2} -> 2
        {op, _} -> op
      end)
      |> Day2.Vm.run()

    head
  end

  @doc """
  Returns the `noun` and `verb` that computes the solution `19_690_720`.

  iex> Day2.solution_2()
  7733
  """
  def solution_2() do
    input = for x <- 0..99, y <- 0..99, do: {x, y}

    {noun, verb} =
      input
      |> Stream.map(&make_input/1)
      |> Stream.zip(input)
      |> Task.async_stream(fn {input, values} ->
        {:ok, [result | _]} = Day2.Vm.run(input)

        {result, values}
      end)
      |> Stream.map(fn {:ok, result} -> result end)
      |> Enum.find_value(fn
        {19_690_720, values} -> values
        _ -> nil
      end)

    100 * noun + verb
  end

  defp read_and_parse_input() do
    :code.priv_dir(:day_2)
    |> Path.join("input.txt")
    |> File.read!()
    |> String.trim("\n")
    |> String.split(",", trim: true)
    |> Enum.map(fn opcode ->
      {int, ""} = Integer.parse(opcode)

      int
    end)
    |> Enum.with_index()
  end

  defp make_input({noun, verb}) do
    read_and_parse_input()
    |> Enum.map(fn
      {_, 1} -> noun
      {_, 2} -> verb
      {op, _} -> op
    end)
  end
end

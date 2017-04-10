defmodule AdventOfCode2015.Day12 do
  @input "data/day12.input"

  def input do
    @input |> File.read! |> Poison.decode!
  end

  def sum_all_fields, do: input() |> sum_all_fields
  def sum_all_fields(x) when is_map(x) do
    x
    |> Enum.filter(
        fn {k, v} -> k != "red" and v != "red"
      end)
    |> Enum.map(fn {_, v} -> sum_all_fields(v) end)
    |> Enum.sum
  end
  def sum_all_fields(x) when is_list(x) do
    Enum.reduce(x, 0, fn v, acc -> acc + sum_all_fields(v) end)
  end
  def sum_all_fields(x) when is_integer(x), do: x
  def sum_all_fields(_), do: 0

end

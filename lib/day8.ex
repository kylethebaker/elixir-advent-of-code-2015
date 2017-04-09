defmodule AdventOfCode2015.Day8 do
  @input "data/day8.input"

  def input do
    @input |> File.read! |> String.trim |> String.split
  end

  def is_hex?(x) do
    case to_string(x) |> Base.decode16(case: :mixed) do
      {:ok, _} -> true
      _ -> false
    end
  end

  def part1 do
    input()
    |> Enum.map(&to_charlist/1)
    |> Enum.reduce(0, fn n, c -> c + length(n) - count(n, 0) end)
  end

  def part2 do
    input()
    |> Enum.map(&to_charlist/1)
    |> Enum.reduce(0, fn n, c -> c + encoded(n, 2) - length(n) end)
  end

  # potential hex encoding
  def count([?\\ | [?x | [h1 | [h2 | rest ]]]], count) do
    case is_hex?([h1, h2]) do
      true -> count(rest, count + 1)
      false -> count([h1, h2] ++ rest, count + 1)
    end
  end

  # potential escape
  def count([?\\ | [next | rest]], count) when next in [?\\, ?"] do
    count(rest, count + 1)
  end

  # exit case, quotes, and others
  def count([], count), do: count
  def count([?" | rest], count), do: count(rest, count)
  def count([_ | rest], count), do: count(rest, count + 1)

  def encoded([], count), do: count
  def encoded([c | rest], count) do
    case c in [?\\, ?"] do
      true -> encoded(rest, count + 2)
      false -> encoded(rest, count + 1)
    end
  end

end

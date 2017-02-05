defmodule AdventOfCode2015.Day1 do
  @input "data/day1.input"

  def input do
    @input |> File.read! |> String.strip |> to_charlist
  end

  def final_floor do
    input() |> Enum.reduce(0, fn direction, acc ->
      case direction do
        ?( -> acc + 1
        ?) -> acc - 1
      end
    end)
  end

  def basement_location do
    input() |> Enum.reduce_while({0, 0}, fn direction, acc ->
      {floor, pos} = acc
      case direction do
        ?) when floor == 0 -> {:halt, {floor - 1, pos + 1}}
        ?( -> {:cont, {floor + 1, pos + 1}}
        ?) -> {:cont, {floor - 1, pos + 1}}
      end
    end)
  end
end

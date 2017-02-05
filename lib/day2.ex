defmodule AdventOfCode2015.Day2 do
  @input "data/day2.input"

  def input do
    @input
    |> File.read!
    |> String.split
    |> Enum.map(&String.split(&1, "x"))
    |> Enum.map(fn x -> Enum.map(x, &String.to_integer/1) end)
  end

  def surface_area([l, w, h]) do
    2*l*w + 2*w*h + 2*h*l + Enum.min([l*w, w*h, h*l])
  end

  def ribbon_length([l, w, h]) do
    [l, w, h]
    |> Enum.sort
    |> Enum.take(2)
    |> Enum.reduce(0, &(2* &1 + &2))
    |> Kernel.+(l*w*h)
  end

  def how_much_paper do
    input() |> Enum.map(&surface_area/1) |> Enum.sum
  end

  def how_much_ribbon do
    input() |> Enum.map(&ribbon_length/1) |> Enum.sum
  end

end

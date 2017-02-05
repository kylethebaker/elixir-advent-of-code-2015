defmodule AdventOfCode2015.Day3 do
  @input "data/day3.input"

  def input do
    @input |> File.read! |> String.trim |> to_charlist
  end

  def deliver_present(direction, {position, visited}) do
    new_location = move(direction, position)
    visited = Map.put(visited, new_location, :visited)
    {new_location, visited}
  end

  def move(direction, {x, y}) do
    case direction do
      ?^ -> {x, y + 1}
      ?v -> {x, y - 1}
      ?> -> {x + 1, y}
      ?< -> {x - 1, y}
    end
  end

  def get_deliveries(directions) do
    Enum.reduce(directions, {{0, 0}, %{}}, &deliver_present/2)
  end

  def only_santa_deliveries do
    {_, visited} = get_deliveries(input())
    visited |> Map.keys |> Enum.count
  end

 def robo_santa_deliveries do
   {_, santa} = input() |> Enum.take_every(2) |> get_deliveries
   {_, dog} = input() |> Enum.drop_every(2) |> get_deliveries
   Map.merge(santa, dog) |> Map.keys |> Enum.count
 end
end

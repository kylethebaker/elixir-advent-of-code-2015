defmodule AdventOfCode2015.Day10 do
  @input "data/day10.input"
  @pattern ~r/(\d)\1*/

  def input do
    @input |> File.read! |> String.trim
  end

  def look_and_say(string) do
    string
    |> split_into_sequences
    |> look_and_say_sequences
  end

  def look_and_say_sequences(sequences) do
    Enum.reduce(sequences, "", &look_and_say_sequences/2)
  end

  def look_and_say_sequences(s, acc) do
    acc <> look_and_say_single(s)
  end

  def look_and_say_single(s) do
    (s |> String.length |> to_string) <> String.first(s)
  end

  def look_and_say_multiple(string, 0), do: string
  def look_and_say_multiple(string, n) do
    look_and_say_multiple(string |> look_and_say, n - 1)
  end

  def split_into_sequences(input) do
    Regex.scan(@pattern, input) |> Enum.map(fn x -> hd(x) end)
  end

  def part1 do
    input()
    |> look_and_say_multiple(40)
    |> String.length
  end

  def part2 do
    input()
    |> look_and_say_multiple(50)
    |> String.length
  end

end

defmodule AdventOfCode2015.Day5 do
  @input "data/day5.input"

  def input do
    @input |> File.read! |> String.trim |> String.split
  end

  #-----------------------------------------------------------------------
  # Part 1
  #-----------------------------------------------------------------------

  def contains_bad?(str) do
    String.contains?(str, ["ab", "cd", "pq", "xy"])
  end

  def has_enough_vowels?(str) do
    no_vowels = String.split(str, ["a", "e", "i", "o", "u"]) |> Enum.join("")
    String.length(str) - String.length(no_vowels) >= 3
  end

  def has_double?(str), do: str |> to_charlist |> has_double?('')
  def has_double?([], _), do: false
  def has_double?([first|rest], previous) do
    first == previous || has_double?(rest, first)
  end

  def is_nice?(str) do
    has_double?(str)
    and has_enough_vowels?(str)
    and not contains_bad?(str)
  end

  def count_nice_strings() do
    input() |> Enum.filter(&is_nice?/1) |> Enum.count
  end

  #-----------------------------------------------------------------------
  # Part 2
  #-----------------------------------------------------------------------

  def get_pairs([_]), do: []
  def get_pairs([]), do: []
  def get_pairs([first|rest]) do
    pair = [first, hd(rest)]
    [pair | get_pairs(rest)]
  end

  def has_double_pair?([]), do: false
  def has_double_pair?([_]), do: false
  def has_double_pair?([pair|rest]) do
    (pair in tl(rest)) || has_double_pair?(rest)
  end
  def has_double_pair?(str) do
    str |> to_charlist |> get_pairs |> has_double_pair?
  end

  def has_sandwich?([], _, _), do: false
  def has_sandwich?(str), do: str |> to_charlist |> has_sandwich?('', '')
  def has_sandwich?([first|rest], prev, prev2) do
    first == prev2 || has_sandwich?(rest, first, prev)
  end

  def is_new_nice?(str) do
    has_sandwich?(str) and has_double_pair?(str)
  end

  def count_new_nice_strings() do
    input() |> Enum.filter(&is_new_nice?/1) |> Enum.count
  end
end

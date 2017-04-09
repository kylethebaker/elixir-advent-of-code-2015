defmodule AdventOfCode2015.Day11 do
  @input "data/day11.input"
  @invalid_chars ["i", "o", "l"]

  def input do
    @input |> File.read! |> String.trim
  end

  def has_straight?(chars) when length(chars) < 3, do: false
  def has_straight?([a | [b | [c | rest]]]) do
    if (a + 1 == b) and (a + 2 == c) do
      true
    else
      has_straight?([b] ++ [c] ++ rest)
    end
  end

  def has_pairs?(chars), do: has_pairs?(chars, false)
  def has_pairs?(chars, _) when length(chars) < 2, do: false
  def has_pairs?([a | [b | rest]], false) when a == b do
    if rest !== [] and hd(rest) == b do
      has_pairs?(rest, true)
    else
      has_pairs?([b | rest], true)
    end
  end
  def has_pairs?([_ | rest], false), do: has_pairs?(rest, false)
  def has_pairs?([a | [b | _]], true) when a == b, do: true
  def has_pairs?([_ | rest], true), do: has_pairs?(rest, true)

  def has_invalid_chars?(p) do
    String.contains?(to_string(p), @invalid_chars)
  end

  def is_valid_password?(p) do
    has_straight?(p) and has_pairs?(p) and not has_invalid_chars?(p)
  end

  def get_next_potential(p) do
    p
    |> Enum.reverse
    |> increment_password
    |> Enum.reverse
  end

  def increment_password([]), do: []
  def increment_password([?z | next]) do
    [?a | increment_password(next)]
  end
  def increment_password([c | rest]) do
    [c + 1 | rest]
  end

  def get_next_password(p) do
    potential = get_next_potential(p)
    if is_valid_password?(potential) do
      potential
    else
      get_next_password(potential)
    end
  end

  def part1 do
    input() |> to_charlist |> get_next_password
  end

  def part2 do
    part1() |> get_next_password
  end

end

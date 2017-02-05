defmodule AdventOfCode2015.Day4 do
  @input "data/day4.input"

  def input do
    @input |> File.read! |> String.trim
  end

  def difficulty(n) do
    String.duplicate("0", n)
  end

  def next_coin(seed, key, zeros) do
    base = key <> Integer.to_string(seed)
    coin = :crypto.md5(base) |> Base.encode16
    if String.starts_with?(coin, difficulty(zeros)) do
      {seed, coin}
    else
      next_coin(seed + 1, key, zeros)
    end
  end

  def lowest_coin() do
    #next_coin(1, input(), 5)
    next_coin(1, input(), 6)
  end
end

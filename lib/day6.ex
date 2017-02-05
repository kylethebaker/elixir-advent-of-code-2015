defmodule AdventOfCode2015.Day6 do
  @input "data/day6.input"
  @parse_regex ~r/(toggle|turn off|turn on) (\d*),(\d*) .* (\d*),(\d*)/

  def input do
    @input
    |> File.read!
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&parse_instruction/1)
  end

  def parse_instruction(str) do
    [_, cmd_raw, sy, sx, ey, ex] = Regex.run(@parse_regex, str)
    # {:operation, {sy, sx}, {ey, ex}}
    {String.split(cmd_raw) |> Enum.take(-1) |> hd |> String.to_atom,
      {String.to_integer(sy), String.to_integer(sx)},
      {String.to_integer(ey), String.to_integer(ex)}
    }
  end

  def get_empty_grid({ly, lx}, starting_val) do
    (for y <- 0..ly, x <- 0..lx, do: {y, x})
    |> Enum.reduce(%{}, fn n, grid -> Map.put(grid, n, starting_val) end)
  end

  def change_lights(grid, {ay, ax}, {by, bx}, update_fn) do
    (for y <- ay..by, x <- ax..bx, do: {y, x})
    |> Enum.reduce(grid, fn coord, grid ->
      update_coordinate(grid, coord, update_fn)
    end)
  end

  def update_coordinate(grid, coord, update_fn) do
    {_, updated} = Map.get_and_update(grid, coord, fn current ->
      {current, update_fn.(current)}
    end)
    updated
  end

  #---------------------------------------------------------------------------
  # Part 1
  #---------------------------------------------------------------------------

  def how_many_lights do
    input()
    |> Enum.reduce(get_empty_grid({999, 999}, false), fn n, grid ->
      case n do
        {:on, a, b} -> change_lights(grid, a, b, &turn_on/1)
        {:off, a, b} -> change_lights(grid, a, b, &turn_off/1)
        {:toggle, a, b} -> change_lights(grid, a, b, &toggle/1)
      end
    end)
    |> Enum.count(fn n -> elem n, 1 end)
  end

  def turn_off(_), do: false
  def turn_on(_), do: true
  def toggle(x), do: !x

  #---------------------------------------------------------------------------
  # Part 2
  #---------------------------------------------------------------------------

  def get_total_brightness do
    input()
    |> Enum.reduce(get_empty_grid({999, 999}, 0), fn n, grid ->
      case n do
        {:on, a, b} -> change_lights(grid, a, b, &brighten/1)
        {:off, a, b} -> change_lights(grid, a, b, &darken/1)
        {:toggle, a, b} -> change_lights(grid, a, b, &double_brighten/1)
      end
    end)
    |> Enum.reduce(0, fn n, brightness -> brightness + elem(n, 1) end)
  end

  def brighten(x), do: x + 1
  def double_brighten(x), do: x + 2
  def darken(0), do: 0
  def darken(x), do: x - 1

end

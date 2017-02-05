defmodule AdventOfCode2015.Day7 do
  @input "data/day7.input"

  use Bitwise

  def input do
    @input
    |> File.read!
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&parse_instruction/1)
  end

  # {operation, wire, [args]}
  def parse_instruction(line) do
    [instruction, wire] = String.split(line, " -> ")
    convert_any_ints(case String.split(instruction) do
      [a] -> {:SEND, wire, [a]}
      [a, op, b] -> {String.to_atom(op), wire, [a, b]}
      ["NOT", a] -> {:NOT, wire, [a]}
    end)
  end

  # convert all numeric strings in an instruction into ints
  def convert_any_ints({op, wire, args}) do
    args = Enum.map(args, &try_int_conversion/1)
    wire = try_int_conversion(wire)
    {op, wire, args}
  end

  # convert str to int if possible
  def try_int_conversion(str) do
    case Integer.parse(str) do
      {i, _} -> i
      :error -> str
    end
  end

  # recursively solve all of the wires
  def solve_next_wire([], known), do: known
  def solve_next_wire([op|ops_list], known_wires) do
    if can_be_solved?(op, known_wires) do
      solve_next_wire(ops_list, solve_wire(op, known_wires))
    else
      solve_next_wire(ops_list ++ [op], known_wires)
    end
  end

  # have we solved enough wires already to be able to solve this one?
  def can_be_solved?({_, _, args}, known_wires) do
    Enum.all?(args, fn arg ->
      is_integer(arg) or Map.has_key?(known_wires, arg)
    end)
  end

  # solves the signal for a wire when all arguments are already known
  def solve_wire({op, wire, args}, known_wires) do
    args = substitute(args, known_wires)
    signal = case op do
      :SEND -> do_send(args)
      :NOT -> do_not(args)
      :AND -> do_and(args)
      :OR -> do_or(args)
      :LSHIFT -> do_lshift(args)
      :RSHIFT -> do_rshift(args)
    end
    Map.put(known_wires, wire, signal)
  end

  def do_send([a]), do: a
  def do_not([a]), do: ~~~a
  def do_and([a, b]), do: a &&& b
  def do_or([a, b]), do: a ||| b
  def do_lshift([a, b]), do: a <<< b
  def do_rshift([a, b]), do: a >>> b

  # replaces wire labels in args with their integer signal
  def substitute(args, known_wires) do
    Enum.map(args, fn arg ->
      if is_integer(arg), do: arg, else: Map.get(known_wires, arg)
    end)
  end

  def part1 do
    circuit = solve_next_wire(input(), %{})
    Map.get(circuit, "a")
  end

  def part2 do
    a = part1()
    updated_instructions = Enum.map(input(), fn op ->
      case op do
        {_, "b", _} -> {:SEND, "b", [a]}
        _ -> op
      end
    end)
    new_circuit = solve_next_wire(updated_instructions, %{})
    Map.get(new_circuit, "a")
  end

end

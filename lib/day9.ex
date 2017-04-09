defmodule AdventOfCode2015.Day9 do
  @input "data/day9.input"

  def input do
    @input
    |> File.read!
    |> String.split("\n", trim: true)
    |> Enum.map(fn s ->
      [a, b, distance] = String.split(s, [" to ", " = "])
      {a, b, String.to_integer(distance)}
    end)
  end

  def get_routes_and_places(paths) do
    Enum.reduce(paths, {%{}, MapSet.new}, &add_route_and_place/2)
  end

  def add_route_and_place({a, b, distance}, {routes, places}) do
    places = MapSet.put(places, a)
    places = MapSet.put(places, b)
    routes = Map.put(routes, {a, b}, distance)
    routes = Map.put(routes, {b, a}, distance)
    {routes, places}
  end

  def permutations([]), do: [[]]
  def permutations(list) do
    for x <- list, y <- permutations(list -- [x]), do: [x | y]
  end

  def get_total_distance(route, routes) do
    get_total_distance(route, routes, 0)
  end
  def get_total_distance([_], _, distance) do
    distance
  end
  def get_total_distance([start|rest], routes, distance) do
    distance = distance + Map.get(routes, {start, hd(rest)})
    get_total_distance(rest, routes, distance)
  end

  def get_shortest_distance do
    {routes, places} = input() |> get_routes_and_places()
    places
    |> MapSet.to_list()
    |> permutations()
    |> Enum.map(fn route -> get_total_distance(route, routes) end)
    |> Enum.min()
  end

  def get_longest_distance do
    {routes, places} = input() |> get_routes_and_places()
    places
    |> MapSet.to_list()
    |> permutations()
    |> Enum.map(fn route -> get_total_distance(route, routes) end)
    |> Enum.max()
  end

end

# Massive abuse of elem on String.to_xyz ahead... you've been warned.

defmodule Movies do

  defp to_lines(file), do: String.split(file, "\n")

  defp to_movies(line) when is_bitstring line do
    parts = String.split line, "\t"

    id = Enum.at parts, 0
    rating = String.to_float Enum.at parts, 1
    name = Enum.at parts, 2
    year = elem (String.to_integer Enum.at parts, 3), 0

    { id, elem(rating, 0), name, year }
  end
  defp to_movies([head|tail]), do: [ to_movies(head) | to_movies(tail) ]
  defp to_movies([]), do: []

  def from(path) do
    device = File.read! path

    device |> to_lines |> to_movies
  end

end

defmodule Uniqueness do
  def count_unique(collection), do: count_unique(HashDict.new, collection)
  defp count_unique(hash, [head|tail]) do 
    hash = HashDict.update hash, head, 1, fn val -> val + 1 end
    count_unique hash, tail
  end
  defp count_unique(hash, []), do: hash

  def sum_unique(collection), do: sum_unique(HashDict.new, collection)
  defp sum_unique(hash, [head|tail]) do
    key = elem head, 0
    value = elem head, 1

    hash = HashDict.update hash, key, value, fn val -> val + value end
    sum_unique hash, tail
  end
  defp sum_unique(hash, []), do: hash
end

IO.puts "***************"
IO.puts "Movies per year"
IO.puts "***************"
IO.inspect Movies.from("movies") |> Enum.map(fn movie -> elem movie, 3 end) |> Uniqueness.count_unique

IO.puts "***************"
IO.puts "Sum scores per year"
IO.puts "***************"
IO.inspect Movies.from("movies") |> Enum.map(fn movie -> { elem(movie, 3), elem(movie, 1) } end) |> Uniqueness.sum_unique

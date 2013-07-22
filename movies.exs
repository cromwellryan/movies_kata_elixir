defmodule Movies do

  defp to_lines(file), do: String.split file, "\n"

  defp to_movies(line) when is_bitstring(line), do: list_to_tuple String.split line, "\t"
  defp to_movies([head|tail]), do: [ to_movies(head) | to_movies(tail) ]
  defp to_movies([]), do: []

  def from(path) do
    device = File.read! path

    device |> to_lines |> to_movies
  end

end

defmodule Uniqueness do
  def count_unique(collection), do: count_unique HashDict.new, collection
  def count_unique(hash, [head|tail]) do 
    hash = HashDict.update hash, head, 1, fn val -> val + 1 end
    count_unique hash, tail
  end
  def count_unique(hash, []), do: hash
end


movies = Movies.from "movies"
movies_year = Enum.map movies, fn movie -> elem movie, 3 end

IO.inspect Uniqueness.count_unique movies_year

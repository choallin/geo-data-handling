defmodule GeoDataHandling do
  @moduledoc """
  Documentation for GeoDataHandling.
  """

  def create_pairs(file_path) do
    file_path
    |> Path.expand(__DIR__)
    |> File.stream!
    |> CSV.decode!(headers: true)
    |> Enum.map(&( [ String.to_float(&1["lon"]) , String.to_float(&1["lat"]) ] ))
    |> Enum.take(2)
    |> Enum.map(&(&1))
  end
end

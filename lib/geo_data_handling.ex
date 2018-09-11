defmodule GeoDataHandling do
  @moduledoc """
  Collection of functions to manipulate GeoData
  """

  @doc """
  This function creates a list of tuples of coordinates

  Returns [{lon, lat}, {lon, lat}]
  Where lon and lat are floats
  """
  def create_pairs(file_path) do
    file_path
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> CSV.decode!(headers: true)
    |> Enum.map(&{String.to_float(&1["lon"]), String.to_float(&1["lat"])})
    |> Enum.chunk_every(2)
  end

  @doc """
  Creates a bounding box for an arbitrary number of coordinates

  Returns [n,e,s,w]
  Where n,e,s,w stands for north, east, south, west and is a float
  """
  def create_bounding_box(geo_coodrinates) do
    # To find the bbox for 2 given points I reorder it to
    # NESW representation
    [current_point | tail] = List.flatten(geo_coodrinates)
    first_lat = elem(current_point, 1)
    first_lon = elem(current_point, 0)
    [current_point | tail] = tail
    second_lat = elem(current_point, 1)
    second_lon = elem(current_point, 0)

    bbox = [
      min(first_lat, second_lat),
      min(first_lon, second_lon),
      max(first_lat, second_lat),
      max(first_lon, second_lon)
    ]

    # After creation of the first box we
    # recursivly call the private functions
    # to find the min/max of each point and compare it
    # with the current bounding box.
    #
    # This would not be necessary if we can be sure
    # that our function is only be calles from e.g.
    # pairs. But this way we can reuse it with
    # an arbitrary number of coordinates as well
    create_bounding_box(tail, bbox)
  end

  defp create_bounding_box([], bbox) do
    # This function is our final step when we iterated
    # over all coordinates
    bbox
  end

  defp create_bounding_box(geo_coodrinates, bbox) do
    # In this function we check the head of the coordinates
    # list against the bounding box we currently have
    [current_point | tail] = geo_coodrinates
    first_lat = elem(current_point, 1)
    first_lon = elem(current_point, 0)
    {north, _} = List.pop_at(bbox, 0)
    {south, _} = List.pop_at(bbox, 2)
    {west, _} = List.pop_at(bbox, 3)
    {east, _} = List.pop_at(bbox, 1)

    bbox = [
      min(first_lat, north),
      min(first_lon, east),
      max(first_lat, south),
      max(first_lon, west)
    ]

    create_bounding_box(tail, bbox)
  end

  @doc """
  Matches coordinates to a bounding box

  Returns [%{box: [n,e,s,w], coordinates: [[float, float], ...]}, ...]
  """
  def match_coordinates_to_bounding_boxes(bounding_boxes, coordinates) do
    # This function implements the requirement to save all coordinates
    # to the right bboxes. But it is not used for the final part of your task
    # To call this with the right args in iex use this:
    # coordinates = "coordinates.csv"
    # |> Path.expand(__DIR__)
    # |> File.stream!
    # |> CSV.decode!(headers: true)
    # |> Enum.map(&([String.to_float(&1["lon"]), String.to_float(&1["lat"]) ]))
    #
    # GeoDataHandling.create_pairs("../pairs.csv")
    # |> Enum.map(fn(x) -> GeoDataHandling.create_bounding_box(x) end)
    # |> GeoDataHandling.match_coordinates_to_bounding_boxes(coordinates)
    #
    # To check which coordinates matched you can use this:
    # Enum.filter(tmp, &( Enum.any?(&1[:coordinates]) ))

    # We iterate over the bounding boxes we have since it
    # is more likely that we have more coordinates than bboxes
    Enum.reduce(bounding_boxes, [], fn box, memo ->
      matched_coordinates =
        Enum.filter(coordinates, fn coordinate ->
          is_coordinate_in_bounding_box?(box, coordinate)
        end)

      [%{box: box, coordinates: matched_coordinates} | memo]
    end)
  end

  @doc """
  Checks if a point is inside a bounding box

  Returns boolean
  """
  def is_coordinate_in_bounding_box?(bbox, coordinate) do
    {north, _} = List.pop_at(bbox, 0)
    {south, _} = List.pop_at(bbox, 2)
    {west, _} = List.pop_at(bbox, 3)
    {east, _} = List.pop_at(bbox, 1)
    lat = List.last(coordinate)
    lon = List.first(coordinate)
    north < lat && south > lat && east < lon && west > lon
  end
end

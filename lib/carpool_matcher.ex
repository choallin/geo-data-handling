defmodule CarpoolMatcher do
  use Agent

  @doc """
  Can find bounding boxes and manage the state for them
  """

  def start_link(_opts) do
    # Collect state
    # The initial state is the one save in our pairs.csv file
    bboxes = GeoDataHandling.create_pairs("../pairs.csv")
    |> Enum.map(fn(x) -> GeoDataHandling.create_bounding_box(x) end)

    # Initialize our agent with the state
    Agent.start_link(fn() -> bboxes end, name: __MODULE__)
  end

  @doc """
  Finds a bounding box for origin, destination or both

  It will also create a new bounding box for the coordinates
  and save it

  Returns [origin: [n,e,s,w], destination: [n,e,s,w] ]
  """
  def find_boxes(origin, destination) do
    bbox = Agent.get(__MODULE__, fn(boxes) ->
      Enum.flat_map(boxes, fn(box) ->
        # This case happens when both points are in the same box
        if GeoDataHandling.is_coordinate_in_bounding_box?(box, origin) && GeoDataHandling.is_coordinate_in_bounding_box?(box, destination) do
          %{origin: box, destination: box}
        else
          cond do
            GeoDataHandling.is_coordinate_in_bounding_box?(box, origin) ->
              %{origin: box}
            GeoDataHandling.is_coordinate_in_bounding_box?(box, destination) ->
              %{destination: box}
            true ->
              %{}
          end
        end
      end)
    end)

    add_pair_to_bounding_boxes([List.to_tuple(origin), List.to_tuple(destination)])

    bbox
  end

  defp add_pair_to_bounding_boxes(coordinates) do
    new_box = GeoDataHandling.create_bounding_box(coordinates)
    # Update state
    Agent.update(__MODULE__, fn(bboxes) -> [new_box | bboxes] end)
  end
end

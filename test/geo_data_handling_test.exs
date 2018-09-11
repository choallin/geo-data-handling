defmodule GeoDataHandlingTest do
  use ExUnit.Case

  test "creates pairs" do
    assert Enum.take(GeoDataHandling.create_pairs("../pairs.csv"), 2) == [
             [{120.99287, 14.75659}, {120.99206, 14.756699999999999}],
             [
               {120.99203999999999, 14.756939999999998},
               {120.99207999999999, 14.757139999999998}
             ]
           ]
  end

  test "finds the bounding box" do
    assert GeoDataHandling.create_bounding_box([
             {120.99287, 14.75659},
             {120.99206, 14.756699999999999}
           ]) == [14.75659, 120.99206, 14.756699999999999, 120.99287]
  end

  test "connects coordinates to bounding boxes" do
    assert GeoDataHandling.match_coordinates_to_bounding_boxes(
             [
               [14.75659, 120.99206, 14.756699999999999, 120.99287],
               [14.45659, 120.99206, 14.656699999999999, 121.287]
             ],
             [[120.9921, 14.7566], [122.9921, 14.7566], [121.0039, 14.5157]]
           ) ==
             [
               %{
                 box: [14.45659, 120.99206, 14.656699999999999, 121.287],
                 coordinates: [[121.0039, 14.5157]]
               },
               %{
                 box: [14.75659, 120.99206, 14.756699999999999, 120.99287],
                 coordinates: [[120.9921, 14.7566]]
               }
             ]
  end

  test "finds out if a coordinate is in a given box" do
    assert GeoDataHandling.is_coordinate_in_bounding_box?(
             [14.75808, 120.99160999999998, 14.758099999999999, 120.99182999999998],
             [120.9917, 14.758089]
           ) == true

    assert GeoDataHandling.is_coordinate_in_bounding_box?(
             [14.75808, 120.99160999999998, 14.758099999999999, 120.99182999999998],
             [120.9927, 14.758089]
           ) == false
  end
end

defmodule GeoDataHandlingTest do
  use ExUnit.Case
  doctest GeoDataHandling

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
    assert GeoDataHandling.create_bounding_box([{120.99287, 14.75659}, {120.99206, 14.756699999999999}]) ==
      [14.75659, 120.99206, 14.756699999999999, 120.99287]
  end
end

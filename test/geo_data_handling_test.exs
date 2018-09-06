defmodule GeoDataHandlingTest do
  use ExUnit.Case
  doctest GeoDataHandling

  test "creates pairs" do
    assert Enum.take(GeoDataHandling.create_pairs("../pairs.csv"), 2) == [
      [120.99287, 14.75659], [120.99206, 14.756699999999999]
    ]
  end
end

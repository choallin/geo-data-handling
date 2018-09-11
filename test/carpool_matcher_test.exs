defmodule CarpoolMatcherTest do
  use ExUnit.Case

  setup do
    {:ok, pid} = CarpoolMatcher.start_link([])
    %{bbox: pid}
  end

  test "finds bboxes for origin and destination and both of them" do
    assert CarpoolMatcher.find_boxes([120.9917,14.758089], [121.0039,14.5157]) ==
      [
        origin: [14.75808, 120.99160999999998, 14.758099999999999, 120.99182999999998]
      ]
    assert CarpoolMatcher.find_boxes([121.0039,14.5157], [120.9917,14.758089]) ==
      [
        destination: [14.75808, 120.99160999999998, 14.758099999999999, 120.99182999999998]
      ]
    assert CarpoolMatcher.find_boxes([120.9917,14.758089], [120.9917,14.758089]) ==
      [
        destination: [14.75808, 120.99160999999998, 14.758099999999999, 120.99182999999998],
        origin: [14.75808, 120.99160999999998, 14.758099999999999, 120.99182999999998]
      ]
  end
end

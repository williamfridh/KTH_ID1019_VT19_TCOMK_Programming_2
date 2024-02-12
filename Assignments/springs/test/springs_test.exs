defmodule SpringsTest do
  use ExUnit.Case
  doctest Springs

  test "greets the world" do
    assert Springs.hello() == :world
  end
end

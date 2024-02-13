defmodule SpringsTest do
  use ExUnit.Case
  doctest Springs

  test "eval #1" do
    assert "???.### 1,1,3" |> Springs.rowToEntry(false) |> Springs.eval() == 1
  end

  test "eval #2" do
    assert ".??..??...?##. 1,1,3" |> Springs.rowToEntry(false) |> Springs.eval() == 4
  end

  test "eval #3" do
    assert "?#?#?#?#?#?#?#? 1,3,1,6" |> Springs.rowToEntry(false) |> Springs.eval() == 1
  end

  test "eval #4" do
    assert "????.#...#... 4,1,1" |> Springs.rowToEntry(false) |> Springs.eval() == 1
  end

  test "eval #5" do
    assert "????.######..#####. 1,6,5" |> Springs.rowToEntry(false) |> Springs.eval() == 4
  end

  test "eval #6" do
    assert "?###???????? 3,2,1" |> Springs.rowToEntry(false) |> Springs.eval() == 10
  end

  test "final #7" do
    assert "data/test_1.csv" |> Springs.docToList(false) |> Springs.evalList() == 21
  end
end

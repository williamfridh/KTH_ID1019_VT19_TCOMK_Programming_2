defmodule SpringsTest do
  use ExUnit.Case
  doctest Springs

  test "eval #1" do
    assert "???.### 1,1,3" |> Springs.rowToEntry(1) |> Springs.eval() == 1
  end

  test "eval #2" do
    assert ".??..??...?##. 1,1,3" |> Springs.rowToEntry(1) |> Springs.eval() == 4
  end

  test "eval #3" do
    assert "?#?#?#?#?#?#?#? 1,3,1,6" |> Springs.rowToEntry(1) |> Springs.eval() == 1
  end

  test "eval #4" do
    assert "????.#...#... 4,1,1" |> Springs.rowToEntry(1) |> Springs.eval() == 1
  end

  test "eval #5" do
    assert "????.######..#####. 1,6,5" |> Springs.rowToEntry(1) |> Springs.eval() == 4
  end

  test "eval #6" do
    assert "?###???????? 3,2,1" |> Springs.rowToEntry(1) |> Springs.eval() == 10
  end

  test "evalList #7" do
    assert "data/test.csv" |> Springs.docToList(1) |> Springs.evalList() == 21
  end

  test "evalList #8" do
    assert "data/test_final.csv" |> Springs.docToList(1) |> Springs.evalList() == 7118
  end

  test "evalMemCheck #9" do
    assert "???.### 1,1,3" |> Springs.rowToEntry(1) |> Springs.evalMemTest(%{}) == 1
  end

  test "evalMemCheck #10" do
    assert ".??..??...?##. 1,1,3" |> Springs.rowToEntry(1) |> Springs.evalMemTest(%{}) == 4
  end

  test "evalMemCheck #11" do
    assert "?#?#?#?#?#?#?#? 1,3,1,6" |> Springs.rowToEntry(1) |> Springs.evalMemTest(%{}) == 1
  end

  test "evalMemCheck #12" do
    assert "????.#...#... 4,1,1" |> Springs.rowToEntry(1) |> Springs.evalMemTest(%{}) == 1
  end

  test "evalMemCheck #13" do
    assert "????.######..#####. 1,6,5" |> Springs.rowToEntry(1) |> Springs.evalMemTest(%{}) == 4
  end

  test "evalMemCheck #14" do
    assert "?###???????? 3,2,1" |> Springs.rowToEntry(1) |> Springs.evalMemTest(%{}) == 10
  end

  test "evalList #15" do
    assert "data/test.csv" |> Springs.docToList(5) |> Springs.evalList() == 525152
  end

  test "evalListMem #16" do
    assert "data/test.csv" |> Springs.docToList(5) |> Springs.evalListMem() == 525152
  end

end

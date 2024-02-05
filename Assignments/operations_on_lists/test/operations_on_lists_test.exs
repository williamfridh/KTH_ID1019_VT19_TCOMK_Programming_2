defmodule OperationsOnListsTest do
  use ExUnit.Case
  doctest OperationsOnLists



  # =================== Test basic functions ===================

  test "even/1" do
    assert OperationsOnLists.even([0,1,2,3,4,5,6,7,8,9]) == [0,2,4,6,8]
  end

  test "odd/1" do
    assert OperationsOnLists.odd([0,1,2,3,4,5,6,7,8,9]) == [1,3,5,7,9]
  end

  test "divisible/2" do
    assert OperationsOnLists.divisible([0,1,2,3,4,5,6,7,8,9], 2) == [0,2,4,6,8]
  end

  test "inc/2" do
    assert OperationsOnLists.inc([0,1,2,3,4], 1) == [1,2,3,4,5]
  end

  test "dec/2" do
    assert OperationsOnLists.dec([2,4,6,8], 1) == [1,3,5,7]
  end

  test "mul/2" do
    assert OperationsOnLists.mul([1,2,3,4], 2) == [2,4,6,8]
  end

  test "reminder/2" do
    assert OperationsOnLists.reminder([1,2,3,4,5,6], 2) == [1,0,1,0,1,0]
  end

  test "prod/2" do
    assert OperationsOnLists.prod([1,2,3]) == 6
  end

  test "sum/2" do
    assert OperationsOnLists.sum([1,2,3,4]) == 10
  end

  test "len/2" do
    assert OperationsOnLists.len([1,2,3,4]) == 4
  end



  # =================== Test basic higher order functions ===================

  test "reducer/3" do
    assert OperationsOnLists.reducer([1,2,3,4,5], 0, fn(x, y) -> x + y end) == 15
  end

  test "reducel/3" do
    assert OperationsOnLists.reducel([1,2,3,4,5], 0, fn(x, y) -> x + y end) == 15
  end

  test "map/2" do
    assert OperationsOnLists.map([1,2,3,4,5], fn(x) -> x + 1 end) == [2,3,4,5,6]
  end

  test "filterr/2" do
    assert OperationsOnLists.filterr([1,2,3,4,5,6], fn(x) -> rem(x, 2) == 0 end) == [2,4,6]
  end

  test "filterl/3" do
    assert OperationsOnLists.filterl([1,2,3,4,5,6], [], fn(x) -> rem(x, 2) == 0 end) == [6,4,2]
  end

  test "filterlf/3" do
    assert OperationsOnLists.filterlf([1,2,3,4,5,6], [], fn(x) -> rem(x, 2) == 0 end) == [2,4,6]
  end



  # =================== Basic functions in higher order functions ===================
  test "even/1 in filterlf/3" do
    assert OperationsOnLists.filterlf([1,2,3,4,5,6], [], fn(x) -> rem(x, 2) == 0 end) == [2,4,6]
  end

  test "odd/1 in filterlf/3" do
    assert OperationsOnLists.filterlf([1,2,3,4,5,6], [], fn(x) -> rem(x, 2) == 1 end) == [1,3,5]
  end

  test "divisible/2 in filterlf/3" do
    assert OperationsOnLists.filterlf([1,2,3,4,5,6], [], fn(x) -> rem(x, 3) == 0 end) == [3, 6]
  end

  test "inc/1 in map/2" do
    assert OperationsOnLists.map([1,2,3,4,5,6],  fn(x) -> x + 1 end) == [2,3,4,5,6,7]
  end

  test "dec/1 in map/2" do
    assert OperationsOnLists.map([3,4,5,6,7,8],  fn(x) -> x - 1 end) == [2,3,4,5,6,7]
  end

  test "mul/2 in map/2" do
    assert OperationsOnLists.map([1,2,3,4],  fn(x) -> x * 2 end) == [2,4,6,8]
  end

  test "reminder/2 in map/2" do
    assert OperationsOnLists.map([1,2,3,4],  fn(x) -> rem(x, 2) end) == [1,0,1,0]
  end

  test "prod/2 in reducer/3" do
    assert OperationsOnLists.reducer([1,2,3,4], 1,  fn(x, y) -> x * y end) == 24
  end

  test "sum/2 in reducer/3" do
    assert OperationsOnLists.reducer([1,2,3,4], 0,  fn(x, y) -> x + y end) == 10
  end

  test "len/1 in reducer/3" do
    assert OperationsOnLists.reducer([1,2,3,4], 0,  fn(x, y) -> 1 + y end) == 4
  end

end

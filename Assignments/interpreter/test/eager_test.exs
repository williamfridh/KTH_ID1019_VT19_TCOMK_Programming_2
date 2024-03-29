defmodule EagerTest do
  use ExUnit.Case
  doctest Interpreter

  # =================== eval_expr ===================

  test "Test eval_expr #1" do
    assert Eager.eval_expr({:atm, :a}, []) == {:ok, :a}
  end

  test "Test eval_expr #2" do
    assert Eager.eval_expr({:var, :x}, [{:x, :a}]) == {:ok, :a}
  end

  test "Test eval_expr #3" do
    assert Eager.eval_expr({:var, :x}, []) == :error
  end

  test "Test eval_expr #4" do
    assert Eager.eval_expr({:cons, {:var, :x}, {:atm, :b}}, [{:x, :a}]) == {:ok, {:a, :b}}
  end

  # =================== eval_match ===================

  test "Test eval_match #5" do
    assert Eager.eval_match({:atm, :a}, :a, []) == {:ok, []}
  end

  test "Test eval_match #6" do
    assert Eager.eval_match({:var, :x}, :a, []) == {:ok, [{:x, :a}]}
  end

  test "Test eval_match #7" do
    assert Eager.eval_match({:var, :x}, :a, [{:x, :a}]) == {:ok, [{:x, :a}]}
  end

  test "Test eval_match #8" do
    assert Eager.eval_match({:var, :x}, :a, [{:x, :b}]) == :fail
  end

  test "Test eval_match #9" do
    assert Eager.eval_match({:cons, {:var, :x}, {:var, :x}}, {:a, :b}, []) == :fail
  end

  test "Test eval_match #10" do
    assert Eager.eval_match({:cons, {:var, :x}, {:var, :y}}, {:a, :b}, [{:x, :a}, {:y, :b}]) == {:ok, [{:x, :a}, {:y, :b}]}
  end

  # =================== eval_match ===================

  test "Test eval_match #11" do
    seq = [
      {:match, {:var, :x}, {:atm,:a}},
      {:match, {:var, :y}, {:cons, {:var, :x}, {:atm, :b}}},
      {:match, {:cons, :ignore, {:var, :z}}, {:var, :y}},
      {:var, :z}]
    assert Eager.eval(seq) == {:ok, :b}
  end

  # =================== eval_seq ===================

  test "Test eval_seq #12" do
    seq = [{:match, {:var, :x}, {:atm, :a}},
      {:case, {:var, :x},
      [{:clause, {:atm, :b}, [{:atm, :ops}]},
      {:clause, {:atm, :a}, [{:atm, :yes}]}
      ]}
      ]
    assert Eager.eval_seq(seq, Env.new()) == {:ok, :yes}
  end

end

defmodule Eager do

  @moduledoc """
  # Eager
  """


  @doc """
  # Expression Evaluation

  The first argument is the expression and the second is the environment.

  Test: "test/eager_test.exs"
  """
  def eval_expr({:atm, id}, _) do {:ok, id} end

  def eval_expr({:var, id}, env) do
    case env do
      [] ->
        :error
      _ ->
        {_, v} = Env.lookup(env, id)
        {:ok, v}
    end
  end

  def eval_expr({:cons, h, t}, env) do
    case eval_expr(h, env) do
      :error ->
        :error
    {:ok, hs} ->
      case eval_expr(t, env) do
        :error ->
          :error
        {:ok, ts} ->
          {:ok, {hs, ts}}
      end
    end
  end



  @doc """
  # Pattern Matching
  """
  def eval_match(:ignore, _, _) do {:ok, []} end
  def eval_match({:atm, id}, id, _) do {:ok, []} end

  def eval_match({:var, id}, str, env) do
    case Env.lookup(env, id) do
      nil ->
        {:ok, [{id, str}]}
      {_, ^str} ->
        {:ok, env}
      {_, _} ->
        :fail
    end
  end

  def eval_match({:cons, hp, tp}, ..., env) do
    case eval_match(..., ..., env) do
      :fail ->
        :fail
      ... ->
        eval_match(..., ..., env)
    end
  end

  def eval_match(_, _, _) do :fail end

end

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
        {:ok, Env.add(env, id, str)}
      {_, ^str} ->
        {:ok, env}
      {_, _} ->
        :fail
    end
  end

  def eval_match({:cons, hp, tp}, {a, b}, env) do
    case eval_match(hp, a, env) do
      :fail ->
        :fail
      {:ok, env} ->
        eval_match(tp, b, env)
    end
  end

  def eval_match(_, _, _) do :fail end



  @doc """
  # Sequence Evaluation
  """
  def extract_vars([]) do nil end
  def extract_vars([{k, v} | t]) do
    if t != [] do
      r = extract_vars(t)
      if k == :var do
        [v | r]
      else
        r
      end
    else
      if k == :var do
        [v]
      end
    end
  end
  def extract_vars({k, v}) do k end

  def eval_scope(ds, env) do
    IO.inspect(ds)
    Env.remove(env, extract_vars(ds))
  end

  def eval_seq([exp], env) do # Single element left.
    eval_expr(exp, env)
  end

  def eval_seq([{:match, a1, a2} | t], env) do # Multiple elements left.
    case eval_expr(a2, env) do
      :error ->
        :error1
      {:ok, ds} ->
        IO.inspect env # Debugging
        env = eval_scope(a1, env)
        IO.inspect env # Debugging
        case eval_match(a1, ds, env) do
          :fail ->
            :error2
          {:ok, env} ->
            eval_seq(t, env)
        end
    end
  end

  def eval(seq) do
    eval_seq(seq, Env.new())
  end

end

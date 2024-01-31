# TODO LIST
# TODO: Improve documentation.

# ======================================

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

  def eval_expr({:case, expr, cls}, env) do
    case eval_expr(expr, env) do
      :error ->
        :error
      {:ok, exprval} ->
        eval_cls(cls, exprval, env)
    end
  end

  def eval_expr({:lambda, par, free, seq}, env) do
    case Env.closure(free, env) do
     :error ->
        :error
      closure ->
        {:ok, {:closure, par, seq, closure}}
    end
  end

  def eval_expr({:apply, expr, args}, env) do
    IO.inspect expr
    IO.inspect args
    IO.inspect env
    IO.inspect eval_expr(expr, env)

    case eval_expr(expr, env) do
      :error ->
        :error
      {:ok, {:closure, par, seq, closure}} ->
        case eval_args(args, closure) do
          :error ->
            :error
          {:ok, strs} ->
            env = Env.args(par, strs, closure)
            eval_seq(seq, env)
        end
    end
  end



  @doc """
  # Evaluate Arguments

  Should return a list.
  """
  def eval_args([h], env) do [eval_expr(h, env)] end

  def eval_args([h, t], env) do
    case eval_expr(h, env) do
      :error ->
        :error
      {:ok, ev} ->
        eval_expr(t, env)
    end
  end



  @doc """
  # Evaluate Clause
  """
  def eval_cls([], _, _) do :error end

  def eval_cls([{:clause, ptr, seq} | cls], exprval, env) do
    case eval_match(ptr, exprval, env) do
      :fail ->
        eval_cls(cls, exprval, env)
      {:ok, env} ->
        eval_seq(seq, env)
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
  # Extract Variables

  This function extracts all the variables from a given list,
  pattern, or expression. It returns a list of the found variables
  in forms of atoms.

  Used by the function called eval_scope/2.
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
  def extract_vars({k, _}) do k end
  def extract_vars({:cons, a1, a2}) do
    case {a1, a2} do
      {:ignore, _} ->
        extract_vars([a2])
      {_, :ignore} ->
        extract_vars([a1])
      _ ->
        extract_vars([a1, a2])
    end
  end



  @doc """
  # Evaluate Scope

  This function uses the function extract_vars/1 alongside with Env.remove/2
  to remove all the variables in the given pattern or expression from the given
  environment and returns this newely modified environment.

  Used by the function called eval_seq/2.
  """
  def eval_scope(ds, env) do
    Env.remove(env, extract_vars(ds))
  end



  @doc """
  # Evaluate Sequence

  This function evaluated a given sequence.
  """
  def eval_seq([exp], env) do # Single element left.
    eval_expr(exp, env)
  end

  def eval_seq([{:match, a1, a2} | t], env) do # Multiple elements left.
    case eval_expr(a2, env) do
      :error ->
        :error
      {:ok, ds} ->
        env = eval_scope(a1, env)
        case eval_match(a1, ds, env) do
          :fail ->
            :error
          {:ok, env} ->
            eval_seq(t, env)
        end
    end
  end



  @doc """
  # Evaluate

  A simple caller method used for evaluations.
  """
  def eval(seq) do
    eval_seq(seq, Env.new())
  end

end

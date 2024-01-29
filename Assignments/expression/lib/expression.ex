defmodule Expression do
  @moduledoc """
  Documentation for `Expression`.

  The custom types expr() and literal(). Note that literal() is used inside expr().

  ## Examples

    iex(1)> {:add, {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}, {:q, 1,2}}
    {:add, {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}, {:q, 1, 2}}

    iex(1)> {:add, {:num, 3}, {:q, 1,2}}

  """
  @type literal() :: {:num, number()}
    | {:var, atom()}
    | {:q, number(), number()}
  @type expr() :: {:add, expr(), expr()}
    | {:sub, expr(), expr()}
    | {:mul, expr(), expr()}
    | {:div, expr(), expr()}
    | literal()

  @doc """
  Hello world.

  ## Examples

      iex> Expression.hello()
      :world

  """
  def eval({:num, n}, _) do n end
  def eval({:var, v}, env) do Env.lookup(env, v) end

  def eval(q, _) do
    simplify_q(q)
  end

  def simplify_q({:q, v1, v2}) do simplify_q({:q, v1, v2}, v2) end
  def simplify_q({:q, v1, v2}, d) do
    if rem(v1, d) == 0 and rem(v2, d) == 0 do
      {:q, v1/d, v2/d}
    else
      if d > 2 do
        simplify_q({:q, v1, v2}, d - 1)
      else
        {:q, v1, v2}
      end
    end
  end

  def eval({:add, e1, e2}, env) do
    add(eval(e1, env), eval(e2, env))
  end

  #def eval({:add, e1, e2}, env) do
  #  case {elem(e1, 0), elem(e2, 0)} do
  #    {:q, :q} ->
  #    {:q, _} -> {:q, }
  #    {_, :q} ->
  #    _ ->
  #end




  def eval({:sub, e1, e2}, env) do
    sub(eval(e1, env), eval(e2, env))
  end
  def eval({:mul, e1, e2}, env) do
    mul(eval(e1, env), eval(e2, env))
  end
  def eval({:div, e1, e2}, env) do
    {:div, eval(e1, env), eval(e2, env)}
  end

  def add(v1, v2) do v1 + v2 end
  def sub(v1, v2) do v1 - v2 end
  def mul(v1, v2) do v1 * v2 end
  def division(v1, v2) do {:q, v1, v2} end
end

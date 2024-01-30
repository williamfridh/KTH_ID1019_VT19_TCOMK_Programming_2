# TODO LIST
#

defmodule Expression do

  @moduledoc """
  Documentation for `Expression`.

  The custom types expr() and literal(). Note that literal() is used inside expr().
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
  # Evaluate

  Evaluates a given expression based on the provided environment
  holding the variable values. It uses the child functions eval()
  and simplify() to evaluate the expression.

  Note that all values are first converted into rational numbers
  before calculations then simplified as mucha s possible and into
  normal numbers if possible.

  ## Examples

      iex> Expression.evaluate({:add, {:q, 1, 3}, {:q, 1, 5}}, env)
      {:q, 8, 15}

      iex> Expression.evaluate({:mul, {:num, 2}, {:div, {:num, 3}, {:num, 4}}}, env)
      {:q, 3.0, 2.0}

      iex> Expression.evaluate({:add, {:q, 7, 3}, {:q, 2, 3}}, env)
      {:num, 3.0}

      iex> Expression.evaluate({:add, {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}, {:q, 1, 2}}, env) # If x = 2.
      {:q, 15, 2}

  """
  def evaluate(e, env) do
    e = eval(e, env)
    e = simplify(e)
    {:q, v1, v2} = e
    if v2 == 1 do
      {:num, v1}
    else
      e
    end
  end

  def eval({:num, n}, _) do {:q, n, 1} end
  def eval({:var, v}, env) do {:q, Env.lookup(env, v), 1} end
  def eval({:q, v1, v2}, _) do {:q, v1, v2} end

  def eval({:add, e1, e2}, env) do add(eval(e1, env), eval(e2, env)) end
  def eval({:sub, e1, e2}, env) do sub(eval(e1, env), eval(e2, env)) end
  def eval({:mul, e1, e2}, env) do mul(eval(e1, env), eval(e2, env)) end
  def eval({:div, e1, e2}, env) do division(eval(e1, env), eval(e2, env)) end


  @doc"""
  # Addition
  """
  def add({:q, v1, v2}, {:q, v3, v4}) do {:q, v1*v4+v3*v2, v2*v4} end


  @doc"""
  # Subtraction
  """
  def sub({:q, v1, v2}, {:q, v3, v4}) do {:q, v1*v4-v3*v2, v2*v4} end


  @doc"""
  # Multiplication
  """
  def mul({:q, v1, v2}, {:q, v3, v4}) do {:q, v1*v3, v2*v4} end


  @doc"""
  # Division
  """
  def division({:q, v1, v2}, {:q, v3, v4}) do {:q, v1*v4, v2*v3} end



  @doc """
  # Simplify Rational Number

  This function is used by evaluate().

  ## Example
    iex> Expression.simplify({:q, 16, 32})
    {:q, 1.0, 2.0}
  """
  def simplify({:q, v1, v2}) do simplify({:q, v1, v2}, v2) end
  def simplify({:q, v1, v2}, d) do
    if d > 1 and rem(v1, d) == 0 and rem(v2, d) == 0 do
      {:q, v1/d, v2/d}
    else
      if d > 2 do
        simplify({:q, v1, v2}, d - 1)
      else
        {:q, v1, v2}
      end
    end
  end

end

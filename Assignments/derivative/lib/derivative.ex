# TODO: Add support for finding the derivative of cos(x), -sin(x), and -cos(x).
# TODO: Add support for subtraction expression.
# TODO: Remove simplication for numbers if possible.

# NOTE: Subtraction isn't required as one can multiply by -1.
# NOTE: The doce war first written using :nil instead of {:num, 0}, but {:num, 0} adds to consistency.

defmodule Derivative do

  @moduledoc """

  This module provides basic support for finding derivatives.

  ## Supported datatypes and operators:
  - Number              - {:num, number()}
  - Variables           - {:var, atom()}
  - Addition            - {:add, expr(), expr()}
  - Exponentials        - {:exp, expr(), expr()}
  - Multiplication      - {:mul, expr(), expr()}
  - Natural logarith    - {:ln, expr()}
  - Division            - {:div, expr(), expr()}
  - Square root         - {:sqrt, expr()}
  - Sin                 - {:sin, expr()}

  """

  # =================================================================

  # CUSTOM TYPES

  # Custom type for numbers and constants.
  @type literal() :: {:num, number()}
  | {:var, atom()}

  # Custom type for mathmatical numexpressions.
  @type expr() :: {:add, expr(), expr()}
  | {:exp, expr(), expr()}
  | {:mul, expr(), expr()}
  | {:ln, expr()}
  | {:div, expr(), expr()}
  | {:sqrt, expr()}
  | {:sin, expr()}
  | {:cos, expr()}
  | literal()

  # =================================================================

  @doc """
  Deriv.

  The function deriv/? is the main function of the Derivative-module as it's responsible for finding
  the derivative. However, it needs to be used with the function simplify/? if one wished to be able
  to read the results and this function (deriv/?) returns a mess. Note that the function is split up
  for different types of input.
  """

  # Derivate a number (always zero).
  # Rule: d/dx = 0
  def deriv({:num, _}, _) do {:num, 0} end

  # Derivate a variable (allways one).
  # Rule: dx/dx = 1
  def deriv({:var, v}, v) do {:num, 1} end

  # Derivate a variable that isn't the target one.
  # Rule: dy/dx = 0
  def deriv({:var, _}, _) do {:num, 0} end

  # Derivate sin.
  # Rule: d/dx sin(x) = cos(x)
  def deriv({:sin, a1}, v) do
    case a1 do
      {:num, _} -> {:cos, a1}
      _ -> {:mul, {:cos, a1}, deriv(a1, v)}
    end
  end

  # Derivate division.
  # Use the quotient rule and convert.
  def deriv({:div, a1, a2}, v) do
    {
      :mul,
      {:add, {:mul, a2, deriv(a1, v)}, {:mul, {:mul, a1, deriv(a2, v)}, {:num, -1}}},
      {:exp, a2, {:num, -2}}
    }
  end

  # Derivate multiplication (notice the chain-rule).
  # Rule: (d/dx)(f+g) = df/dx+dg/dx
  def deriv({:mul, e1, e2}, v) do
    {:add,
      {:mul, deriv(e1, v), e2},
      {:mul, deriv(e2, v), e1}
    }
  end

  # Derivate addition (simply split it up).
  # Rule: (d/dx)(2x+x^2) = 2+2x
  def deriv({:add, e1, e2}, v) do
    {:add,
      deriv(e1, v),
      deriv(e2, v)
    }
  end

  # Derivate exponential.
  # Rule: (d/dx)(x^3) = 3x^2
  def deriv({:exp, e1, {:num, n}}, v) do
    case e1 do
      {:num, _} -> {:exp, e1, {:num, n}}
      {:var, _} -> {:mul, {:num, n}, {:exp, e1, {:num, n-1}}}
      _ -> {:mul, {:mul, {:num, n}, {:exp, e1, {:num, n-1}}}, deriv(e1, v)}
    end
  end

  # Derivate natural logarithm.
  # Rule: ln(x) = 1/x & chain-rule
  def deriv({:ln, e1}, v) do
    case e1 do
      {:num, _} -> {:num, 0}
      {:var, _} -> {:exp, e1, {:num, -1}}
      _ -> {:mul, {:exp, e1, {:num, -1}}, deriv(e1, v)}
    end
  end

  # Derivate squareroot.
  # Rule: sqrt(x) = -1/(2sqrt(x)) & chain-rule
  def deriv({:sqrt, a1}, v) do
    case a1 do
      {:num, _} -> {:num, 0}
      {:var, _} -> {:div, {:num, 1}, {:mul, {:num, 2}, {:sqrt, a1}}}
      _ -> {:mul, {:div, {:num, 1}, {:mul, {:num, 2}, {:sqrt, a1}}}, deriv(a1, v)}
    end
  end

  # =================================================================

  @doc """
  Simplify.

  This function is sued for simpifying found derivaties. It relies heavily on checking for
  ones and zeros to be able to remove unnecessary data. Note that the function is split up
  for different types of input.
  """

  # Things to not simplify.
  def simplify({:var, v}) do {:var, v} end
  def simplify({:sqrt, a1}) do {:sqrt, a1} end
  def simplify({:div, a1, a2}) do {:div, a1, a2} end
  def simplify({:sin, a1}) do {:sin, a1} end
  def simplify({:cos, a1}) do {:cos, a1} end

  # Simplify numbers.
  def simplify({:num, v}) do
    if v == 0 do
      {:num, 0}
    else
      {:num, v}
    end
  end

  # Addition.
  def simplify({:add, e1, e2}) do
    case [simplify(e1), simplify(e2)] do
      [{:num, 0}, {:num, 0}] -> {:num, 0}
      [_, {:num, 0}] -> simplify(e1)
      [{:num, 0}, _] -> simplify(e2)
      [{:num, v1}, {:num, v2}] -> {:num, v1 + v2}
      _ -> {:add, simplify(e1), simplify(e2)}
    end
  end

  # Multiplication.
  def simplify({:mul, e1, e2}) do
    case [simplify(e1), simplify(e2)] do
      [_, {:num, 0}] -> {:num, 0}
      [{:num, 0}, _] -> {:num, 0}
      [{:num, v1}, {:num, v2}] -> {:num, v1 * v2}
      [{:num, 1}, _] -> e2
      [_, {:num, 1}] -> simplify(e1)
      _ -> {:mul, simplify(e1), simplify(e2)}
    end
  end

  # Exponential.
  def simplify({:exp, e1, e2}) do
    case [e1, e2] do
      [_, {:num, 0}] -> {:num, 1}
      [_, {:num, 1}] -> simplify(e1)
      [{:num, v1}, {:num, v2}] -> {:num, :math.pow(v1, v2)}
      [_, {:num, v2}] -> {:exp, simplify(e1), {:num, v2}}
      [_, {:div, v1, v2}] -> {:exp, simplify(e1), {:div, v1, v2}}
    end
  end

  # Natural logarithm.
  def simplify({:ln, e1}) do
    case e1 do
      {:num, 1} -> {:num, 0}
      _ -> {:ln, simplify(e1)}
    end
  end

  # =================================================================

  @doc """
  Pretify.

  This function is used for making the data easier to read for humans.
  It turns the custom types (see module documentation) into normal
  mathmatical expressions (with some limitations).
  """

  def prettify({:var, v}) do v end
  def prettify({:num, n}) do n end
  def prettify({:add, a1, a2}) do "(#{prettify(a1)} + #{prettify(a2)})" end
  def prettify({:mul, a1, a2}) do "(#{prettify(a1)} * #{prettify(a2)})" end
  def prettify({:exp, a1, a2}) do "(#{prettify(a1)} ^ #{prettify(a2)})" end
  def prettify({:ln, a1}) do "ln(#{prettify(a1)})" end
  def prettify({:div, a1, a2}) do "(#{prettify(a1)} / #{prettify(a2)})" end
  def prettify({:sqrt, a1}) do "sqrt(#{prettify(a1)})" end
  def prettify({:sin, a1}) do "sin(#{prettify(a1)})" end
  def prettify({:cos, a1}) do "cos(#{prettify(a1)})" end

  # =================================================================

  @doc """
  Test.

  This function is used for testing. It takes in two arguments; a mathamatical
  expression find the derivative of and the variable to derive by.
  """

  def test(e, v) do
    IO.puts("Input: #{e |> prettify()}")
    IO.puts("Derivative: #{e |> deriv(v) |> prettify()}")
    IO.puts("Simplified: #{e |> deriv(v) |> simplify() |> prettify()}")
    IO.puts("")
  end

end

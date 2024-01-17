defmodule Derivative do

  # CUSTOM TYPES

  # Define a custom type for numbers and constants.
  @type literal() :: {:num, number()}
  | {:var, atom()}

  # Define a custom type for expressions.
  @type expr() :: {:add, expr(), expr()}
  | {:exp, expr(), literal()} # Limit the second argument for simplicity.
  | {:mul, expr(), expr()}
  | literal()

  # =================================================================

  # CALCULATIONS

  # Derivate a number (always zero).
  # Rule: d/dx = 0
  def deriv({:num, _}, _) do {:num, 0} end

  # Derivate a variable (allways one).
  # Rule: dx/dx = 1
  def deriv({:var, v}, v) do {:num, 1} end

  # Derivate a constant (like pi, allways zero).
  # Rule: d/dx = 0
  def deriv({:var, _}, _) do {:num, 0} end

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
    t = {:mul, {:num, n}, {:exp, e1, {:num, n-1}}}
    case [e1, n] do
      [{:var, _}, _] -> t
      [{:add, _}, _] -> {:mul, t, deriv(e1, v)}
      [{:mul, _}, _] -> {:mul, t, deriv(e1, v)}
    end
  end

  # =================================================================

  # SIMPLIFY

  # Don't simplify variables.
  def simplify({:var, v}) do {:var, v} end

  # Simplyfy numbers.
  def simplify({:num, v}) do
    if v == 0 do
      :nil
    else
      {:num, v}
    end
  end

  # Simplify additions.
  def simplify({:add, e1, e2}) do
    case [simplify(e1), simplify(e2)] do
      [:nil, :nil] -> :nil
      [_, :nil] -> simplify(e1)
      [:nil, _] -> simplify(e2)
      [{:num, v1}, {:num, v2}] -> {:num, v1 + v2}
      #[{:var, v1}, {:var, _}] -> {:mul, {:num, 2}, {:var, v1}} # Note that v1 and v2 (no added) must be the same! Disabled because it's unnecessary.
      _ -> {:add, simplify(e1), simplify(e2)}
    end
  end

  # Simplify multiplication.
  def simplify({:mul, e1, e2}) do
    case [simplify(e1), simplify(e2)] do
      [_, :nil] -> :nil
      [:nil, _] -> :nil
      [{:num, v1}, {:num, v2}] -> {:num, v1 * v2}
      [{:num, 1}, _] -> e2
      [_, {:num, 1}] -> e1
      _ -> {:mul, simplify(e1), simplify(e2)}
    end
  end

  # Simplify exponential.
  def simplify({:exp, e1, {:num, n}}) do
    IO.puts(n)
    case [e1, n] do
      [_, 0] -> {:num, 1}
      [_, 1] -> simplify(e1)
      [{:num, v1}, _] -> {:num, :math.pow(v1, n)}
      [{:var, _}, _] -> {:exp, simplify(e1), {:num, n}}
    end
  end

  # =================================================================

  # Function to simplify testing.
  # Note that this throws an error.
  def run(e, v) do
    IO.puts("Input: #{Kernel.inspect(e)}")
    IO.puts("Derivative: #{e |> deriv(v) |> Kernel.inspect()}")
    IO.puts("Simplified: #{e |> deriv(v) |> simplify() |> Kernel.inspect()}")
    IO.puts("")
  end

end

# 2x+3 >> 3
Derivative.run({:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}, :x)
#2x^2+3x+5 >> 4x+3
Derivative.run({:add, {:add, {:mul, {:num, 2}, {:mul, {:var, :x}, {:var, :x}}}, {:mul, {:num, 3}, {:var, :x}}}, {:num, 5}}, :x)
#2x^3+3x+5 >> 6x^2+3
Derivative.run({:add, {:add, {:mul, {:num, 2}, {:exp, {:var, :x}, {:num, 3}}}, {:mul, {:num, 3}, {:var, :x}}}, {:num, 5}}, :x)
#(3x)^2 >> 18x
Derivative.run({:exp, {:mul, {:num, 3}, {:var, :x}}, {:num, 2}}, :x)
#2x^2+4x+5 >> 4x + 4
Derivative.run({:add, {:add, {:mul, {:num, 2}, {:exp, {:var, :x}, {:num, 2}}}, {:mul, {:num, 4}, {:var, :x}}}, {:num, 5}}, :x)
#x^2 >> 2x
Derivative.run({:exp, {:num, 3}, {:num, 2}}, :x)

# Output: {:add, {:mul, {:mul, {:num, 2}, {:exp, {:var, :x}, {:num, 1}}}, {:num, 2}}, {:num, 4}}
# Fix the unwanted EXP

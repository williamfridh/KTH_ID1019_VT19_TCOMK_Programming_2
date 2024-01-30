defmodule Env do

  @moduledoc """
  Envirement Module
  """

  @doc """
  New environment.

  Call upon to generate a new empty environment.

  ## Example
    iex> env = Env.new([{:x, 5}, {:y, 10}])
    [x: 5, y: 10]
  """
  def new(bindings) do bindings end



  @doc """
  Lookup variable in environment.

  ## Example
    iex> Env.lookup(env, :x)
    5
  """
  def lookup([], _) do "Error: Variable not found in the provided environment." end
  def lookup([{k, v} | h], var) do
    if k == var do
      v
    else
      lookup(h, var)
    end
  end

end

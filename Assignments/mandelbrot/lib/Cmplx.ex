defmodule Cmplx do
  @moduledoc """
  Complex number module.
  """



  @doc """
  New.

  Returns the complex number with real value r and imaginary i.
  """
  def new(r, i) do{:cmpx, r * 1.0, i * 1.0} end



  @doc """
  Add.

  Adds two complex numbers.
  """
  def add({:cmpx, r1, i1}, {:cmpx, r2, i2}) do {:cmpx, r1+r2, i1+i2} end



  @doc """
  Squared.

  Math: (a+bi)(a+bi) = aa+adi+bai-bb
  """
  def sqr({:cmpx, r, i}) do
    {:cmpx, r * r - i * i, r * i * 2}
  end



  @doc """
  Absolute value.

  Get the absolute value of the complex number.
  """
  def absolute({:cmpx, r, i}) do :math.sqrt(r * r + i * i) end

end

defmodule Cmplx do
  @moduledoc """
  Complex number module.
  """



  @doc """
  New.

  Returns the complex number with real value r and imaginary i.
  """
  def new(r, i) do{r * 1.0, i * 1.0} end



  @doc """
  Add.

  Adds two complex numbers.
  """
  def add({r1, i1}, {r2, i2}) do {r1+r2, i1+i2} end



  @doc """
  Squared.

  Math: (a+bi)(a+bi) = aa+adi+bai-bb
  """
  def sqr({r, i} = a) do
    {:math.pow(r, 2) - :math.pow(i, 2), r*i*2}
  end



  @doc """
  Absolute value.

  Get the absolute value of the complex number.
  """
  def absolute({r, i}) do :math.sqrt(:math.pow(r, 2) + :math.pow(i, 2)) end

end

defmodule Brot do
  @moduledoc """
  Documentation for the module Brot.
  """



  @doc """
  Mandelbrot.

  This function takes the two arguments c (complex number)
  and i, the maximum number of iterations.
  """
  def mandelbrot({_, i} = c, m) do
    z0 = Cmplx.new(0, i)
    i = 0
    test(i, z0, c, m)
  end



  @doc """
  Test.

  Tests if the limit is reached.
  """
  def test(i, _, _, m) when i == m - 1 do 0 end # Note that we subtract 1 to get true depth of m.
  def test(i, z0, c, m) do
    #IO.puts("Number: #{Cmplx.absolute(z0)}")
    if (Cmplx.absolute(z0) > 2) do
      i
    else
      test(i + 1, Cmplx.add(Cmplx.sqr(z0), c), c, m)
    end
  end

end

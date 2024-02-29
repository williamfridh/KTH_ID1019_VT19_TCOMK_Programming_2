defmodule Brot do
  @moduledoc """
  Documentation for the module Brot.
  """



  @doc """
  Mandelbrot.

  This function takes the two arguments c (complex number)
  and i, the maximum number of iterations.
  """
  def mandelbrot(c, m) do
    z0 = Cmplx.new(0, 0)
    test(0, z0, c, m)
  end



  @doc """
  Test.

  This function tests the depth of a complex number. In the context of the Mandelbrot Set,
  "depth" typically refers to the level of iteration or the number of iterations performed
  in the iterative process used to determine whether a point in the complex plane belongs
  to the Mandelbrot Set or not.
  """
  def test(i, _z, _c, m) when i == m - 1 do 0 end # Note that we subtract 1 to get true depth of m.
  def test(i, z, c, m) do
    a = Cmplx.absolute(z)                 # Get absolute value.
    if (a > 2) do                         # Depth found.
      i
    else                                  # Continue measuring.
      z1 = Cmplx.add(Cmplx.sqr(z), c)
      test(i + 1, z1, c, m)
    end
  end

end

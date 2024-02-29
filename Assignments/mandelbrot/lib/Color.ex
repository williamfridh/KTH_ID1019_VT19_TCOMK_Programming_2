defmodule Color do
  @moduledoc """
  Documentation for the Color module.
  """


  @doc """
  Convert.

  Converts a depth ona a scale from zero to mix
  and returns the color.
  """
  def convert(depth, max) do
    if (depth > max) do convert(max, max) end  # Recall the function with max value.

    frac = depth / max

    x = frac * 10

    red     = round(abs(:math.sin(x*(1/3)*:math.pi) * 255))
    green   = round(abs(:math.sin(x*(2/3)*:math.pi) * 255))
    blue    = round(abs(:math.sin(x*(3/3)*:math.pi) * 255))

    {:rgb, red, green, blue}
  end

  def getLog(0.0) do 0.0 end
  def getLog(x) do :math.log2(x) end
end

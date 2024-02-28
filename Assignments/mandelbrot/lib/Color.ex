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
    #x = getLog(depth)
    frac = depth / max                          # Calculate fraction.

    hex = round(255255255 * frac)

    red = round(hex/1000000)
    green = round(rem(round(hex/100), 1000))
    blue = round(rem(hex, 1000000))



    #colorFrac = abs(:math.sin(frac))

    #redDistance = getRedDistance(colorFrac)
    #greenDistance = getGreenDistance(colorFrac)
    #blueDistance = getBlueDistance(colorFrac)

    #red = round(redDistance * 255)
    #green = round(greenDistance * 255)
    #blue = round(blueDistance * 255)

    #red = round(255 - abs(:math.cos(frac*:math.pi/2)) * 255)
    #green = round(255 - abs(:math.cos(frac*:math.pi/4)) * 255)
    #blue = round(255 - abs(:math.cos(frac*:math.pi/6)) * 255)


    #IO.puts("{:rgb, #{red}, #{green}, #{blue}}")
    {:rgb, red, green, blue}
  end

  def getLog(0) do 0 end
  def getLog(x) do :math.log(x) end

  def getRedDistance(frac) when frac >= 0.5 do 0 end
  def getRedDistance(frac) do 1 - frac * 2 end

  def getBlueDistance(frac) when frac <= 0.5 do 0 end
  def getBlueDistance(frac) do frac * 2 - 1 end

  def getGreenDistance(frac) when frac == 0.5 do 1.0 end
  def getGreenDistance(frac) when frac < 0.5 do frac * 2 end
  def getGreenDistance(frac) when frac > 0.5 do 2.0 - frac * 2 end

end

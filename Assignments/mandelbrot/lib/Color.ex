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

    frac = getLog(frac)

    #IO.puts(frac)

    #x = round(frac * 1000000000000)

    #hex = round(255255255 * frac)

    red = 255 - abs(round(:math.sin(frac*1000) * 255 ))
    green = 255 - abs(round(:math.sin(rem(round(frac*1000000), 1000)) * 255))
    blue = 255 - abs(round(:math.sin(rem(round(frac*1000000000), 1000)) * 255))

    #opacity = rem(round(frac*1000000000000), 1000) / 1000

    #IO.puts(red)

    #IO.puts("{:rgb, #{red}, #{green}, #{blue}, #{opacity}}")

    #red = round(red * opacity)
    #green = round(green * opacity)
    #blue = round(blue * opacity)

    #colorFrac = abs(:math.sin(frac))

    #redDistance = getRedDistance(colorFrac)
    #greenDistance = getGreenDistance(colorFrac)
    #blueDistance = getBlueDistance(colorFrac)

    #red = round(redDistance * 255)
    #green = round(greenDistance * 255)
    #blue = round(blueDistance * 255)

    red = round(255 - abs(:math.cos(frac*:math.pi/2)) * 255)
    green = round(255 - abs(:math.cos(frac*:math.pi/4)) * 255)
    blue = round(255 - abs(:math.cos(frac*:math.pi/6)) * 255)


    {:rgb, red, green, blue}
  end

  def getLog(0.0) do 0.0 end
  def getLog(x) do :math.log2(x) end

  def getRedDistance(frac) when frac >= 0.5 do 0 end
  def getRedDistance(frac) do 1 - frac * 2 end

  def getBlueDistance(frac) when frac <= 0.5 do 0 end
  def getBlueDistance(frac) do frac * 2 - 1 end

  def getGreenDistance(frac) when frac == 0.5 do 1.0 end
  def getGreenDistance(frac) when frac < 0.5 do frac * 2 end
  def getGreenDistance(frac) when frac > 0.5 do 2.0 - frac * 2 end

end

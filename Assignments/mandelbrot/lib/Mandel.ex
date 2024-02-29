defmodule Mandel do

  @moduledoc """
  Documentation for module Mandel.
  """



  @doc """
  Mandelbrot.

  This function is used to generate a new mandelbrot image with the dimensions
  of width times height. Where the upper left corner is the point x + yi.
  and the offset between two points is k. Where k is a constant added for more
  drastic changes to the complex number as only the coordinates might now
  be enough for the desired result.

  Note: This function is not written by the student.
  """
  def mandelbrot(width, height, x, y, k, depth) do
    trans = fn(w, h) -> Cmplx.new(x + k * (w - 1), y - k * (h - 1)) end
    rows(width, height, trans, depth, [])
  end



  @doc """
  Rows.

  This function does calls to the function called columns/5 until it has
  generated a list of lists with as many entires as the value of height.
  """
  def rows(_width, height, _trans, _depth, row) when height == 0 do row end
  def rows(width, height, trans, depth, row) do
    [columns(width, height, trans, depth, row) | rows(width, height - 1, trans, depth, row)]
  end



  @doc """
  Columns.

  This function receives calls from the function called row/5 and filles an
  empty list with colors (via calls to Color.convert/2). Thus, this is the
  function "paints" the canvas.
  """
  def columns(width, _height, _trans, _depth, col) when width == 0 do col end
  def columns(width, height, trans, depth, col) do
    d = Brot.mandelbrot(trans.(width, height), depth)
    [Color.convert(d, depth) | columns(width - 1, height, trans, depth, col)]
  end



  @doc """
  Run.

  This function is used for generating mandelbrot images with a
  desired width, height, and depth. Note that it's based on the
  functions demo/0 and small/3 given to the student.

  It results in images located in the folder specified in the module
  PPM with a filename showing the width, height, and depth.
  """
  def run(width, height, depth) do
    x0 = -2.6
    y0 = 1.0
    xn = 1.0
    k = (xn - x0) / width
    image = mandelbrot(width, height, x0, y0, k, depth)
    PPM.write("w#{width}_h#{height}_d#{depth}_.ppm", image)
  end

end

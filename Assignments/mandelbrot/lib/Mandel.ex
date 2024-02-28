defmodule Mandel do

  @moduledoc """
  Documentation for module Mandel.
  """



  @doc """
  Mandelbrot.

  This function is not written by the student.
  """
  def mandelbrot(width, height, x, y, k, depth) do
    trans = fn(w, h) ->
      Cmplx.new(x + k * (w - 1), y - k * (h - 1))
    end
    rows(width, height, trans, depth, [])
  end



  def parallel(fun, ref) do
    self = self()
    #IO.puts("Starting new process...")
    spawn(fn() ->
      res = fun.()
      send(self, {:ok, ref, res})
      end)
  end



  def collect(ref) do
    receive do
      {:ok, ^ref, res} ->
        res
    end
  end



  @doc """
  Rows.
  """
  #def rows(width, height, trans, depth, []) do [] end
  def rows(_width, height, _trans, _depth, lst) when height == 0 do
    IO.puts("All processes spawned.")
    lst
  end
  def rows(width, height, trans, depth, lst) do
    #IO.puts(height)
    ref = make_ref()
    parallel(fn() -> columns(width, height, trans, depth, lst) end, ref)
    res = collect(ref)
    [res | rows(width, height - 1, trans, depth, lst)]
    #[columns(width, height, trans, depth, lst) | rows(width, height - 1, trans, depth, lst)]
  end



  @doc """
  Columns.
  """
  #def columns(width, height, trans, depth, []) do [] end
  def columns(width, _height, _trans, _depth, lst) when width == 0 do lst end
  def columns(width, height, trans, depth, lst) do
    #IO.puts(width)
    d = Brot.mandelbrot(trans.(width, height), depth)
    [Color.convert(d, depth) | columns(width - 1, height, trans, depth, lst)]
  end



  def demo(width, height) do
    small(width, height, -1, 1, 1)
  end

  def small(width, height, x0, y0, xn) do
    depth = 64
    k = (xn - x0) / width
    image = Mandel.mandelbrot(width, height, x0, y0, k, depth)
    #IO.inspect(image)
    PPM.write("small.ppm", image)
  end

end

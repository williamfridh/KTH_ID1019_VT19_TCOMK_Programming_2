defmodule PO do

  def error(func, line, msg) do
    IO.puts("#{IO.ANSI.red_background()}### ERROR ### #{func} - #{line} :: #{msg}#{IO.ANSI.reset()}")
  end

  def info(msg) do
    IO.puts("#{IO.ANSI.blue_background()}### INFO ### #{msg}#{IO.ANSI.reset()}")
  end

  def h(txt) do
    IO.puts("#{IO.ANSI.yellow_background()}### #{txt} ####{IO.ANSI.reset()}")
  end

end

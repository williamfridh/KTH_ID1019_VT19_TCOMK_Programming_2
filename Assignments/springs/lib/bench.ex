defmodule Bench do
  @moduledoc """
  Documenation for Bench (module for benchmarking).
  """


  @doc """
  Basic of evalList/1.
  """
  def evalList(n, file) do
    IO.puts("n\t\tt(us)\t\tt/p")
    Enum.reduce(1..n, 1, fn(n, p) ->
      {t, _} = :timer.tc(fn() -> file |> Springs.docToList(n) |> Springs.evalList() end)
      IO.puts("#{n}\t\t#{t}\t\t#{t/p}")
      t
      end)
  end


  @doc """
  Basic of evalListMem/1.
  """
  def evalListMem(n, file) do
    IO.puts("n\t\tt(us)\t\tt/p")
    Enum.reduce(1..n, 1, fn(n, p) ->
      {t, _} = :timer.tc(fn() -> file |> Springs.docToList(n) |> Springs.evalListMem() end)
      IO.puts("#{n}\t\t#{t}\t\t#{t/p}")
      t
      end)
  end

end

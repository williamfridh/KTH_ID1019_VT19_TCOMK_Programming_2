defmodule Day1 do

  # A basic function.
  def to_celcius(faren) do
    (faren - 32) / 1.8
  end

  # A function using recursion.
  def fib(n) do
    case n do
      1 -> 1
      2 -> 1
      _ when n > 0 -> fib(n-1) + fib(n-2)
      _ -> :gurka
    end
  end

  # Convert roman numbers.
  def roman(n) do
    case n do
      :i -> 1
      :v -> 5
      :x -> 10
    end
  end

  def listen do
    receive do
      {:yo} -> IO.puts("message received")
    end
    listen()
  end

end

pid = spawn(Day1, :listen, [])
send pid, {:yo}
send pid, {:yo}
send pid, {:yo}

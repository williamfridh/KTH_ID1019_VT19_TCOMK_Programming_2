defmodule Dinner do
  @moduledoc """
  Documentation for the module Dinner.

  The code in this document was given in the assignment document for
  testing the implementation of the modules Chopstick and Philosopher.
  """

  @doc """
  Start.

  Create a thread that runs init/0.
  """
  def start(hunger, life) do
    IO.puts("Starting benchmark...")
    spawn(fn -> init(hunger, life) end)
  end



  @doc """
  """
  def init(hunger, life) do
    c1 = Chopstick.start()
    c2 = Chopstick.start()
    c3 = Chopstick.start()
    c4 = Chopstick.start()
    c5 = Chopstick.start()
    ctrl = self()
    Philosopher.start(hunger, c1, c2, :arendt, ctrl, life)
    Philosopher.start(hunger, c2, c3, :hypatia, ctrl, life)
    Philosopher.start(hunger, c3, c4, :simone, ctrl, life)
    Philosopher.start(hunger, c4, c5, :elisabeth, ctrl, life)
    Philosopher.start(hunger, c5, c1, :ayn, ctrl, life)# ABC
    t1 = :os.system_time(:millisecond)
    wait(5, [c1, c2, c3, c4, c5], t1)
  end

  # We’re starting all processes under a controlling process that will keep
  # track of all the philosophers and also make sure that the chopstick processes
  # are terminated when we’re done.

  def wait(0, chopsticks, t1) do
    t2 = :os.system_time(:millisecond)
    t = t2 - t1
    IO.puts("#{t} milliseconds")
    Enum.each(chopsticks, fn(c) -> Chopstick.remove(c) end)
  end



  def wait(n, chopsticks, t1) do
    receive do
      :done ->
        wait(n - 1, chopsticks, t1)
      :abort ->
        Process.exit(self(), :kill)
      end
  end

end

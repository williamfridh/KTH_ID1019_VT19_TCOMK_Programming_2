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
  def start(), do: spawn(fn -> init() end)



  @doc """
  """
  def init() do
    c1 = Chopstick.start()
    c2 = Chopstick.start()
    c3 = Chopstick.start()
    c4 = Chopstick.start()
    c5 = Chopstick.start()
    ctrl = self()
    Philosopher.start(5, c1, c2, :arendt, ctrl, 20)
    Philosopher.start(5, c2, c3, :hypatia, ctrl, 20)
    Philosopher.start(5, c3, c4, :simone, ctrl, 20)
    Philosopher.start(5, c4, c5, :elisabeth, ctrl, 20)
    Philosopher.start(5, c5, c1, :ayn, ctrl, 20)
    wait(5, [c1, c2, c3, c4, c5])
  end

  # We’re starting all processes under a controlling process that will keep
  # track of all the philosophers and also make sure that the chopstick processes
  # are terminated when we’re done.

  def wait(0, chopsticks) do
    Enum.each(chopsticks, fn(c) -> Chopstick.remove(c) end)
  end



  def wait(n, chopsticks) do
    receive do
      :done ->
        wait(n - 1, chopsticks)
      :abort ->
        Process.exit(self(), :kill)
      end
  end

end

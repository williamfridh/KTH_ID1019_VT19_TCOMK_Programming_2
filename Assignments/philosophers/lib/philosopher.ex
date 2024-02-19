defmodule Philosopher do
  @moduledoc """
  Documentation for `Philosopher`.
  """


  @doc """
  Start.

  # Arguments
  - hunger: the number of times the Philosopher should eat before it
  sends a :done message to the controller process.

  - right and left: the process identifiers of the two chopsticks.

  - name: an atom that is the name of the philosopher, used for nice logging.

  - ctrl: a controller process that should be informed when the philosopher is done.
  """
  def start(hunger, right, left, name, ctrl) do
    spawn_link(fn -> dreaming(hunger, right, left, name, ctrl) end)
  end



  @doc """
  Sleep.

  A function made for ranomized sleeping.
  Gives a more realistic simlulation of the final
  test found in the module Dinner.
  """
  def sleep(0) do :ok end
  def sleep(t) do
    #:timer.sleep(:rand.uniform(t))
  end



  @doc """
  Dreaming.
  """
  def dreaming(hunger, right, left, name, ctrl) do
    IO.puts("#{name} is dreaming")
    sleep(1000)                                   # Sleeping time.
    waiting(hunger, right, left, name, ctrl)      # Go to hungry state.
  end



  @doc """
  Waiting.
  """
  def waiting(hunger, right, left, name, ctrl) do
    IO.puts("#{name} is waiting")


    case Chopstick.request(left, name) do
      {:request, _} ->
        case Chopstick.request(right, name) do
          {:request, _} ->
            eating(hunger, right, left, name, ctrl)
          _ ->
            #IO.puts("Right chopstick is not available")
            Chopstick.return(left, name)
            waiting(hunger, right, left, name, ctrl)
          end
      _ ->
        #IO.puts("Left chopstick is not available")
        waiting(hunger, right, left, name, ctrl)
    end

  end



  @doc """
  Eating.
  """
  def eating(hunger, right, left, name, ctrl) do
    IO.puts("#{name} starts to eat")              # Success. Starts to eat.
    sleep(1000)                                       # Eating time.
    Chopstick.return(right, name)                           # Return chopsticks.
    Chopstick.return(left, name)                            # -||-
    #IO.puts("Chopstick left & right returned by #{name}")
    if (hunger - 1 == 0) do
      IO.puts("#{name} is full")
      send(ctrl, :done)
    else
      dreaming(hunger - 1, right, left, name, ctrl)     # Go back to dreaming.
    end
  end

end

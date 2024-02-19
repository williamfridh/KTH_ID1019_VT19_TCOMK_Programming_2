defmodule Philosophers do
  @moduledoc """
  Documentation for `Philosophers`.
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
    philosopher = spawn_link(fn -> dreaming(hunger, right, left, name, ctrl) end)
  end



  @doc """
  Dreaming.
  """
  def dreaming(hunger, right, left, name, ctrl) do
    receive do
      :eat ->
        IO.puts("#{name} want's to eat")
        waiting(hunger, right, left, name, ctrl)
      _ ->
        IO.puts("#{name} continues to dream")
        dreaming(hunger, right, left, name, ctrl)
    end
  end



  @doc """
  Waiting.
  """
  def waiting(hunger, right, left, name, ctrl) do
        if Chopstick.request(left) == :ok do      # Check if the left chopstick is available.
          if Chopstick.request(right) == :ok do   # Check if the right chopstick is available.
            IO.puts("#{name} starts to eat")      # Success. Starts to eat.
            eating()                              # Go to next state.
          else                                    # Missing right chopstick.
            Chopstick.return(left)                # Return left chopstick.
            waiting()                            # Continue dreaming.
          end
        else                                      # Can't access left chopstick.
        waiting()                              # Continue dreaming.
        end
  end



  @doc """
  Eating.
  """
end

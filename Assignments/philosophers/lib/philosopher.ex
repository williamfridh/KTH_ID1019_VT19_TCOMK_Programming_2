defmodule Philosopher do
  @moduledoc """
  Documentation for `Philosopher`.

  # Dreaming = 1000
  # Eating = 1000

  All get to eat eventually. The console goes crazy with messages from the loop
  inside the waiting-state. Most printing to the console becomes redundent.

  "
  arendt -- Got a chopstick
  arendt -- Didn't get a chopstick
  arendt -- Returned a chopstick
  arendt -- Got a chopstick
  arendt -- Didn't get a chopstick
  arendt -- Returned a chopstick
  "

  Approximatly 3 people finish at the same time in the end.

  # Dreaming = 10
  # Eating = 1000

  Approximatly 2 people finish at the same time in the end.

  # Dreaming = 0
  # Eating = 1000

  Approximatly 3 people finish at the same time in the end.





  4. Experiments

  A dreaming period slows down the process. More time is wasted in the
  beginning since no chopsticks are used.

  An artifixcial delay of 1000 between getting the chopsticks doesn't
  affect much. Howver, puttin it between receiving the first chopstick and trying
  to get the second slows down the process drasticly.

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
  def start(hunger, right, left, name, ctrl, life) do
    spawn_link(fn -> dreaming(hunger, right, left, name, ctrl, life) end)
  end



  @doc """
  Sleep.

  A function made for ranomized sleeping.
  Gives a more realistic simlulation of the final
  test found in the module Dinner.
  """
  def sleep(0) do :ok end
  def sleep(t) do
    :timer.sleep(:rand.uniform(t))
  end



  @doc """
  Dreaming.
  """
  def dreaming(hunger, right, left, name, ctrl, life) do
    IO.puts("#{name} -- Is dreaming")
    sleep(3000)                                   # Sleeping time.
    IO.puts("#{name} -- Is waiting")
    waiting(hunger, right, left, name, ctrl, life)      # Go to hungry state.
  end



  @doc """
  Waiting.
  """
  def waiting(hunger, right, left, name, ctrl, life) do
    case Chopstick.request(left, name, 100) do
      :ok ->
        sleep(500)
        case Chopstick.request(right, name, 100) do
          :ok ->
            eating(hunger, right, left, name, ctrl, life)
          :bad ->
            Chopstick.return(left, name)
            waiting(hunger, right, left, name, ctrl, life)
          :timeout ->
            Chopstick.return(left, name)
            if (life - 1 == 0) do
              dead(0, right, left, name, ctrl, 0)
            else
              waiting(hunger, right, left, name, ctrl, life - 1)
            end
          end
      :bad ->
        waiting(hunger, right, left, name, ctrl, life)
      :timeout ->
        if (life - 1 == 0) do
          dead(0, right, left, name, ctrl, 0)
        else
          waiting(hunger, right, left, name, ctrl, life - 1)
        end
    end
  end



  @doc """
  Eating.
  """
  def eating(hunger, right, left, name, ctrl, life) do
    IO.puts("#{name} -- Starts to eat")               # Starts to eat.
    sleep(3000)                                       # Eating time.
    Chopstick.return(right, name)                     # Return chopsticks.
    Chopstick.return(left, name)                      # -||-
    if (hunger - 1 == 0) do                           # Check if no longer hungry.
      IO.puts("#{name} -- Is full")
      send(ctrl, :done)                               # Notify the tester that this one is full.
    else
      dreaming(hunger - 1, right, left, name, ctrl, life)   # Go back to dreaming.
    end
  end



  @doc """
  Dead.
  """
  def dead(hunger, _, _, name, ctrl, _) do
    IO.puts("#{name} -- Is dead with #{hunger} hunger left")
    send(ctrl, :done)
  end

end

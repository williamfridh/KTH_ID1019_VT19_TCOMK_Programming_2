defmodule Philosopher do
  @moduledoc """
  Documentation for `Philosopher`.

  I first made the philosophers not eager enough to cause deadlocks by making
  them return the left chopstick if the right one wasnt availible.

  --

  @dreaming    1000
  @eating      1000
  Deadlock after some philisophers are full.

  --

  @dreaming    100
  @eating      1000
  -||-

  --

  @dreaming    10
  @eating      1000
  -||-

  --

  @dreaming    1000
  @eating      1000
  @chopsticks  100
  Deadlock fast. 2 got full. Things run slower.

  --

  @dreaming    1000
  @eating      1000
  @chopsticks  1000
  -||-

  --

  @dreaming    1000
  @eating      1000
  @chopsticks  3000
  Deadlock real fast.
  Adding a sleep for chopsticks doesn't make things better.

  --

  @dreaming    1000
  @eating      1000
  @chopsticks  0
  @max_waiting 1000
  Solved the deadlock, but most philosphers died.

  --

  Benchmarks

  @dreaming    1000
  @eating      1000
  @chopsticks  0
  @max_waiting 1000
  5x5
  22685ms
  5 dead

  @dreaming    10
  @eating      10
  @chopsticks  0
  @max_waiting 10
  5x5
  269ms
  5 dead

  @dreaming    10
  @eating      10
  @chopsticks  0
  @max_waiting 1000
  5x5
  20037ms
  4 dead

  @dreaming    10
  @eating      0
  @chopsticks  0
  @max_waiting 1000
  5x5
  20053ms
  3 dead

  @dreaming    1000
  @eating      0
  @chopsticks  0
  @max_waiting 1000
  5x5
  3937ms
  0 dead

  @dreaming    100
  @eating      0
  @chopsticks  0
  @max_waiting 100
  5x5
  347ms
  0 dead




  @dreaming    0
  @eating      1000
  No one got to eat anything.

  --

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


  @dreaming    1
  @eating      0
  @chopsticks  0
  @max_waiting 1
  #@additional_waiting 20


  @doc """
  Start.

  # Arguments
  - hunger: the number of times the Philosopher should eat before it
  sends a :done message to the controller process.

  - right and left: the process identifiers of the two chopsticks.

  - name: an atom that is the name of the philosopher, used for nice logging.

  - ctrl: a controller process that should be informed when the philosopher is done.
  """
  def start(hunger, left, right, name, ctrl, life) do
    spawn_link(fn -> dreaming(hunger, left, right, name, ctrl, life) end)
  end



  @doc """
  Sleep.

  A function made for ranomized sleeping.
  Gives a more realistic simlulation of the final
  test found in the module Dinner.

  Note how :rand.uniform/1 means that the
  randomization is uniform and thus if you
  give it 1000 as input an infinite amount
  of times, then the average would be 500.
  """
  def sleep(0) do :ok end
  def sleep(t) do
    :timer.sleep(:rand.uniform(t))
  end



  @doc """
  Dreaming.
  """
  def dreaming(hunger, left, right, name, ctrl, life) do
    #IO.puts("#{name} -- Is dreaming")
    sleep(@dreaming)                                   # Sleeping time.
    #IO.puts("#{name} -- Is waiting")
    waiting(hunger, left, right, name, ctrl, life, 0)      # Go to hungry state.
  end

  # The waiter makes a cetralized csolution.
  # A bottleneck that can crash everything.
  # Instead, find a decentrilised solution.
  # The chopsticks are the decentrilization?
  # We use a exponential backloff time. Like in CSMA/CD.

  @doc """
  Waiting.
  """
  def waiting(hunger, left, right, name, ctrl, life, wait) do
    #case Chopstick.request(left, name, @max_waiting) do
    #  :ok ->
    #    sleep(@chopsticks)
    #    case Chopstick.request(right, name, @max_waiting) do
    #      :ok ->
    #        eating(hunger, right, left, name, ctrl, life)
    #      :timeout ->
    #        if (life - 1 == 0) do
    #          dead(0, right, left, name, ctrl, 0)
    #        else
    #          waiting(hunger, right, left, name, ctrl, life - 1)
    #        end
    #      end
    #  :timeout ->
    #    if (life - 1 == 0) do
    #      dead(0, right, left, name, ctrl, 0)
    #    else
    #      waiting(hunger, right, left, name, ctrl, life - 1)
    #    end
    #end
    #sleep(wait)
    #if (:rand.uniform(4) != 1) do
    #  IO.puts("#{name} -- Missed his/her turn")
    #  waiting(hunger, right, left, name, ctrl, life, wait, true)
    #else
    ref = make_ref()
    case Chopstick.async_request(left, right, name, @max_waiting, ref) do
      :granted ->
        eating(hunger, left, right, name, ctrl, life, ref)
      :timeout ->
        if (life - 1 == 0) do
          dead(0, name, ctrl)
        else
          #IO.puts("#{name} -- Is waiting...")
          #sleep(round(:math.pow(2, wait)))
          #IO.puts("#{name} -- Lost a life (#{life})")
          waiting(hunger, left, right, name, ctrl, life - 1, wait+ 1)
        end
    end
  #end
  end



  @doc """
  Eating.
  """
  def eating(hunger, left, right, name, ctrl, life, ref) do
    #IO.puts("#{name} -- Starts to eat")               # Starts to eat.
    sleep(@eating)                                    # Eating time.
    Chopstick.return(left, name, ref)                      # -||-
    Chopstick.return(right, name, ref)                     # Return chopstick.
    hunger = hunger - 1                               # Update hunger.
    if (hunger == 0) do                               # If done.
      IO.puts("#{name} -- Is full with life #{life}")
      send(ctrl, :done)                               # Notify CTRL.
    else
      dreaming(hunger, left, right, name, ctrl, life) # Go back to dreaming.
    end
  end



  @doc """
  Dead.
  """
  def dead(hunger, name, ctrl) do
    IO.puts("#{name} -- Is dead with #{hunger} hunger left")
    send(ctrl, :done)
  end

end

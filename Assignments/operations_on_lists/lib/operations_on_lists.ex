defmodule OperationsOnLists do
  @moduledoc """
  Documentation for `OperationsOnLists`.
  """


  # ======================= FILTERS =======================


  @doc """
  # Even

  Returns a list of all even numbers.
  """
  def even([ ]) do [ ] end
  def even([h|t]) do
    if rem(h, 2) == 0 do
      [h | even(t)]
    else
      even(t)
    end
  end



  @doc """
  # Odd

  Returns a list of all odd numbers.
  """
  def odd([ ]) do [ ] end
  def odd([h|t]) do
    if rem(h, 2) != 0 do
      [h | odd(t)]
    else
      odd(t)
    end
  end



  @doc """
  # Divisible

  Returns a list containing all integers in the given list that are
  evenly divisble by the given integer.
  """
  def divisible([ ], _) do [ ] end
  def divisible([h | t], i) do
    if rem(h, i) == 0 do
      [h | divisible(t, i)]
    else
      divisible(t, i)
    end
  end



  @doc """
  # Filter (not tail recursive)
  """
  def filterr([ ], _) do [ ] end
  def filterr([h | t], op) do
    if op.(h) do
      [h | filterr(t, op)]
    else
      filterr(t, op)
    end
  end



  @doc """
  # Filter (tail recursive)
  """
  def filterl([ ], _, _) do [ ] end
  def filterl([ x ], lst2, op) do
    if op.(x) do
      [ x | lst2 ]
    else
      lst2
    end
  end
  def filterl([h1 | t1], lst2, op) do
    if op.(h1) do
      filterl(t1, [h1 | lst2], op)
    else
      filterl(t1, lst2, op)
    end
  end



  @doc """
  # Filter (tail recursive) flipped
  """
  def filterlf([ ], _, _) do [ ] end
  def filterlf([ x ], lst2, op) do
    if op.(x) do
      lst2 ++ [ x ]
    else
      lst2
    end
  end
  def filterlf([h1 | t1], lst2, op) do
    if op.(h1) do
      filterlf(t1, lst2 ++ [ h1 ], op)
    else
      filterlf(t1, lst2, op)
    end
  end



  # ======================= MAP =======================



  @doc """
  # Increment

  Returns the given list with all values increased by a given value.
  """
  def inc([ ], _) do [ ] end
  def inc([h | t], i) do [h + i | inc(t, i)] end



  @doc """
  # Decrement

  Returns the given list with all values decremented by a given value.
  """
  def dec([ ], _) do [ ] end
  def dec([h | t], i) do [h - i | dec(t, i)] end



  @doc """
  # Multiply

  Returns the given list with all values are multiplied by a given value.
  """
  def mul([ ], _) do [ ] end
  def mul([h | t], i) do [h * i | mul(t, i)] end



  @doc """
  # Reminder

  Returns the given list with all reminders from division by a given value.
  """
  def reminder([ ], _) do [ ] end
  def reminder([h | t], i) do [rem(h, i) | reminder(t, i)] end



  @doc """
  # Map
  """
  def map([ ], _) do [ ] end
  def map([h | t], op) do [op.(h) | map(t, op)] end



  # ======================= REDUCE =======================



  @doc """
  # Product

  Returns the product of all elements in a list.
  """
  def prod([ ]) do 0 end
  def prod([ x ]) do x end
  def prod([h | t]) do h * prod(t) end



  @doc """
  # Sum

  Returns the sum of all the intergers in the list.
  """
  def sum([ ]) do 0 end
  def sum([h | t]) do h + sum(t) end



  @doc """
  # Length

  Returns the lenght of a given length.
  """
  def len([ ]) do 0 end
  def len([_ | t]) do 1 + len(t) end



  @doc """
  # Reduce (not tail recursive)
  """
  def reducer([ ], _, _) do 1 end
  def reducer([ x ], i, op) do op.(x, i) end
  def reducer([h | t], i, op) do
    op.(h, reducer(t, i, op))
  end



  @doc """
  # Reduce (tail recursive)
  """
  def reducel([ ], _, _) do 1 end
  def reducel([ x ], i, op) do op.(x, i) end
  def reducel([h | t], i, op) do
    reducel(t, op.(h, i), op)
  end



  # ======================= EXTRA =======================

  @doc """
  # Foo &

  Takes a list of integers and returns the sum of the square of all values less than n.
  """
  def foo(lst, n) do
    less_than_n = filterlf(lst, [], fn(x) -> x < n end)
    squares = map(less_than_n, fn(x) -> x * x end)
    reducel(squares, 0, fn(x, y) -> x + y end)
  end

  def bar(lst, n) do
    lst |>
      filterlf([], fn(x) -> x < n end) |>
      map(fn(x) -> x * x end) |>
      reducel(0, fn(x, y) -> x + y end)
  end

end

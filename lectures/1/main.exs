# Not how the function is stored in the variable called foo.
foo = fn x -> x + 2 end   # Long version.
boo = &(&1 + 2)           # Short version.

# Print out the results.
IO.puts foo.(5)                   # Outputs 7.
IO.puts boo.(5)                   # Outputs 7.
IO.puts foo.(boo.(5))             # Outputs 9.
5 |> foo.() |> boo.() |> IO.puts() # Outputs 20.

# Inline call.
IO.puts (fn x -> x + 10 end).(10) # Outputs 20.

# Variable test.
name = "William"
IO.puts (name)    # Prints the value of the variable.
IO.puts :name     # Prints the "atom".

# Test day1 (module).
Code.require_file("Day1.exs")
IO.puts (Day1.to_celcius(98))
IO.puts (Day1.fib(2))
IO.puts (Day1.fib(3))
IO.puts (Day1.fib(10))
IO.puts (Day1.fib(0))

# List.
list = [1, 2, 3]

# Map.
map = %{:a => 1, :b => 2}

# Match operator.
[a, b, c] = [1, 2, 3]
#[a, b, c, d] = [1, 2, 3] # Wil}l yield an error.

# Tuples.
foo = {:gurka, 42}
{x, y} = foo  # Note how this is the match operator.
IO.puts (y)

defmodule Springs do
  @moduledoc """
  Documentation for `Springs`.
  """



  @doc """
  Document to list.

  Reads entires from a document and converts each row into
  a entry by calling upon rowToEntry/1.
  """
  def docToList(file_path, extended) do
    case File.read(file_path) do                    # Attempt to read from file.
      {:ok, content} ->                             # Content found.
        rowsToEntires(content, extended)            # Pass content for convertion.
      {:error, reason} ->                           # Error accured.
        IO.puts("Error reading file: #{reason}")
    end
  end



  @doc """
  Rows to entires.

  This function jsut passes down each row to the function
  called rowToEntry/1.
  """
  def rowsToEntires(content, extended) do
    rows = String.split(content, "\n")
    rowsToEntires(rows, [], extended)
  end
  def rowsToEntires([], lst, _) do lst end
  def rowsToEntires([h | t], lst, extended) do
    [rowToEntry(h, extended) | rowsToEntires(t, lst, extended)]
  end



  @doc """
  Row to entry.

  Converts a given input row into a proper entry of the
  format {[:bad, :ok, :bad, :ok, :bad, :bad, :bad], [1,1,3]}.
  """
  def rowToEntry(row, extended) do
    [sym, num] = String.split(row, " ")                 # Split row into symbols and numbers.
    sym = symbolsToList(sym)                            # Turn symbols into an list of atoms.
    num = numbersToList(num)                            # Turn numebrs into an list ofr integers.
    {sym, num}                                          # Return row multiplied in length.
  end



  @doc """
  Numbers to list.

  Converts a string of numbers into a list of numbers.

  # Example:
  iex: numersToList("1,2,3")
  [1, 2, 3]
  """
  def numbersToList(nums) do
    String.split(nums, ",")               # Split string into list (still strings).
    |> Enum.map(&String.to_integer/1)     # Convert each string into an integer.
  end



  @doc """
  Symbols to list.

  Converts a string of symbols into an list of atoms.
  """
  def symbolsToList(sym) do
    sym = String.to_charlist(sym)                 # Convert the symbols into a character list.
    symbolsToList(sym, [])                        # Continue...
  end
  def symbolsToList([], lst) do lst end           # Catch empty symbol lists.
  def symbolsToList(sym, lst) do
    char = hd(sym)                                # Select head and save to seperate variable.
    sym = tl(sym)                                 # Remove head and only save the tail.
    case char do                                  # Analyze the char (compare to ascii codes).
      46 -> symbolsToList(sym, lst ++ [:ok])      # Found working spring.
      35 -> symbolsToList(sym, lst ++ [:bad])     # Found broken spring.
      63 -> symbolsToList(sym, lst ++ [:unk])     # Found spring of unknown state.
    end
  end



  @doc """
  Evalute lite of entries.

  This function evalutes each entry in the provided list
  and sums up all the results.
  """
  def evalList([]) do 0 end
  def evalList([h | t]) do
    eval(h) + evalList(t)
  end



  @doc """
  Evaluate entry.

  Evalutes an entry and returns the amount of possible solution.
  The goal is to replace each :unk with either :ok or :bad.
  """
  def eval(entry) do eval(entry, false) end
  def eval({[], []}, _) do 1 end
  def eval({[], [0]}, _) do 1 end

  def eval({[], _}, _) do 0 end
  def eval({[:ok | _], _}, true) do 0 end
  def eval({_, [-1 | nt]}, _) do 0 end

  def eval({[sh | st] = sym, []}, _) do
    case sh do
      :bad -> 0
      _ -> eval({st, []}, false)
    end
  end

  def eval({[:ok | st] = sym, num}, _) do
    num = removeZeroHead(num)
    eval({st, num}, false)
  end

  def eval({[:bad | st] = sym, [nh | nt] = num}, _) do
    num_dec = [nh - 1 | nt]
    if nh - 1 == 0 do
      eval({st, num_dec}, false)
    else
      eval({st, num_dec}, true)
    end
  end

  def eval({[:unk | st] = sym, [0 | _] = num}, _) do
    num = removeZeroHead(num)
    eval({st, num}, false)
  end

  def eval({[:unk | st] = sym, [nh | nt] = num}, true) do
      num_dec = [nh - 1 | nt]
      if nh - 1 == 0 do
        eval({st, num_dec}, false)
      else
        eval({st, num_dec}, true)
      end
  end

  def eval({[:unk | st] = sym, [nh | nt] = num}, false) do
      num_dec = [nh - 1 | nt]
      if nh - 1 == 0 do
        eval({st, num_dec}, false) + eval({st, num}, false)
      else
        eval({st, num_dec}, true) + eval({st, num}, false)
      end
  end



  @doc """
  Remove Zero Head.

  Removes the head of a list if the head is zero.
  A simple helper function used by eval/2.
  """
  def removeZeroHead([0 | tl]) do tl end
  def removeZeroHead(lst) do lst end



  @doc """
  Check entry.

  Returns a boolean telling if the entry is valid.
  Note that this function is only for testing.
  """
  def check({sym, num}) do
    if check(sym, [], 0) == num do
      true
    else
      false
    end
  end

  def check([], tmp, bads) do
    if bads == 0 do
      tmp
    else
      tmp ++ [bads]
    end
  end

  def check(sym, tmp, bads) do
    [sh | st] = sym
    if sh == :bad do
      check(st, tmp, bads + 1)
    else
      if bads == 0 do
        check(st, tmp, 0)
      else
        check(st, tmp ++ [bads], 0)
      end
    end
  end

end

defmodule Springs do
  @moduledoc """
  Documentation for `Springs`.
  """



  @doc """
  Document to list.

  Reads entires from a document and converts each row into
  a entry by calling upon rowToEntry/1.
  """
  def docToList(file_path, extend) do
    case File.read(file_path) do                    # Attempt to read from file.
      {:ok, content} ->                             # Content found.
        rowsToEntires(content, extend)              # Pass content for convertion.
      {:error, reason} ->                           # Error accured.
        IO.puts("Error reading file: #{reason}")
    end
  end



  @doc """
  Rows to entires.

  This function jsut passes down each row to the function
  called rowToEntry/1.
  """
  def rowsToEntires(content, extend) do
    rows = String.split(content, "\n")
    rowsToEntires(rows, [], extend)
  end
  def rowsToEntires([], lst, _) do lst end
  def rowsToEntires([h | t], lst, extend) do
    [rowToEntry(h, extend) | rowsToEntires(t, lst, extend)]
  end



  @doc """
  Row to entry.

  Converts a given input row into a proper entry of the
  format {[:bad, :ok, :bad, :ok, :bad, :bad, :bad], [1,1,3]}.
  """
  def rowToEntry(row, extend) do
    [sym, num] = String.split(row, " ")                 # Split row into symbols and numbers.
    sym = symbolsToList(sym)                            # Turn symbols into an list of atoms.
    num = numbersToList(num)                            # Turn numebrs into an list ofr integers.
    extendEntry({sym, num}, extend)                     # Return row multiplied in length.
  end



  @doc """
  Extend entry.

  Extends a entry by multiplying each side a given amount of times.
  """
  def extendEntry({sym, num}, extend) do
    extendEntry({sym, num}, {sym, num}, extend)
  end

  #def extendEntry(_, 0) do [] end
  #def extendEntry(lst, 1) do lst end
  def extendEntry({sym, num}, {symNew, numNew}, extend) do
    if extend > 1 do
      extendEntry({sym, num}, {symNew ++ [:unk] ++ sym, numNew ++ num}, extend - 1)
    else
      {symNew, numNew}
    end
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

  def eval({[sh | st] = sym, [nh | nt] = num}, _) when
                                                        sh == :ok or
                                                        sh == :unk and nh == 0
                                                        do
    num = removeZeroHead(num)
    eval({st, num}, false)
  end

  def eval({[:unk | st] = sym, [nh | nt] = num}, false) do
      num_dec = [nh - 1 | nt]
      if nh - 1 == 0 do
        eval({st, num_dec}, false) + eval({st, num}, false)
      else
        eval({st, num_dec}, true) + eval({st, num}, false)
      end
  end

  def eval({[sh | st] = sym, [nh | nt] = num}, _) do
      num_dec = [nh - 1 | nt]
      if nh - 1 == 0 do
        eval({st, num_dec}, false)
      else
        eval({st, num_dec}, true)
      end
  end



  @doc """
  Evalute lite of entries.

  This function evalutes each entry in the provided list
  and sums up all the results.
  """
  def evalListMem(lst) do
    {r, m} = evalListMem(lst, %{})
    r
  end
  def evalListMem([], mem) do {0, mem} end
  def evalListMem([h | t], mem) do
    {r1, m1} = evalMemCheck(h, mem)
    {r2, m2} = evalListMem(t, m1)
    {r1 + r2, m2}
  end



  @doc """
  Evaluate With Memory Test.

  This function is used for running someof the tests
  found in data/springs_test.exs.

  See evalMem/2 for more information.
  """
  def evalMemTest(entry, mem) do
    {r, m } = evalMemCheck(entry, false, mem)
    r
  end



  @doc """
  Evaluate With Memory.

  Evaluates a given entry by using memory to speed up the process.
  """
  def evalMem(entry, mem) do evalMemCheck(entry, false, mem) end

  def evalMem({[], []}, _, mem) do {1, mem} end
  def evalMem({[], [0]}, _, mem) do {1, mem} end

  def evalMem({[], _}, _, mem) do {0, mem} end
  def evalMem({[:ok | _], _}, true, mem) do {0, mem} end
  def evalMem({_, [-1 | nt]}, _, mem) do {0, mem} end

  def evalMem({[sh | st] = sym, []}, _, mem) do
    case sh do
      :bad -> {0, mem}
      _ -> evalMemCheck({st, []}, false, mem)
    end
  end

  def evalMem({[sh | st] = sym, [nh | nt] = num}, _, mem) when
                                                        sh == :ok or
                                                        sh == :unk and nh == 0
                                                        do
    num = removeZeroHead(num)
    evalMemCheck({st, num}, false, mem)
  end

  def evalMem({[:unk | st] = sym, [nh | nt] = num}, false, mem) do
      num_dec = [nh - 1 | nt]
      if nh - 1 == 0 do
        {r1, m1} = evalMemCheck({st, num_dec}, false, mem)
        {r2, m2} = evalMemCheck({st, num}, false, m1)
        {r1 + r2, m2}
      else
        {r1, m1} = evalMemCheck({st, num_dec}, true, mem)
        {r2, m2} = evalMemCheck({st, num}, false, m1)
        {r1 + r2, m2}
      end
  end

  def evalMem({[sh | st] = sym, [nh | nt] = num}, _, mem) do
      num_dec = [nh - 1 | nt]
      if nh - 1 == 0 do
        evalMemCheck({st, num_dec}, false, mem)
      else
        evalMemCheck({st, num_dec}, true, mem)
      end
  end



  @doc """
  Evaluate Memory Check.

  This function is a form of wrapper function for the evalMem/2.
  It's job is to first check if ther is a result stored in the
  memory already.
  """
  def evalMemCheck({sym, num}, mem) do evalMemCheck({sym, num}, false, mem) end
  def evalMemCheck({sym, num}, forceBad, mem) do
    memRes = Map.get(mem, {sym, num, forceBad})
    if memRes == nil do
      {res, mem} = evalMem({sym, num}, forceBad, mem)
      {res, Map.put(mem, {sym, num, forceBad}, res)}
    else
      {memRes, mem}
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

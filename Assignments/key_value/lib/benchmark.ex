defmodule Benchmark do

  @moduledoc"""
  This module is used for benchmarking the two different types of data-structures
  implemented. That is lists of key-value pairs and binary trees of key-value pairs.

  Note that the code in this file is based on code given by the course teacher.
  That is, only minor adjustments might have been made by the student.
  """



  @doc """

  # Benchmark list

  The following function starts the benchmark  of the list implementation using one argument n that says
  how many runs that'll be carried out. Note that there are two functions with
  the same name and that one of them is called upon by the other with and
  additional argument.

  # Example result
  # benchmark with 10000 operations, time per operation in us
  #    n         add      lookup      remove
  #   16        0.21        0.19        0.07
  #   32        0.35        0.32        0.12
  #   64        1.40        0.93        0.24
  #  128        1.37        1.33        0.46
  #  256        2.58        2.46        0.75
  #  512        5.28        5.05        1.80
  # 1024       10.32        9.79        3.01
  # 2048       22.28       18.94        6.33
  # 4096       44.22       38.71       15.58
  # 8192       94.02       75.15       31.31
  """

  def bench_list(i, n) do
    # Generate a sequence of random numbers.
    seq = Enum.map(
      1..i,
      fn(_) -> :rand.uniform(i) end
      )
    # Generate a list of random numbers (based on seq).
    list = Enum.reduce(
      seq,
      EnvList.new(),
      fn(e, list) -> EnvList.add(list, e, :foo) end
      )
    # Generate a new sequence of random numbers.
    seq = Enum.map(
      1..n,
      fn(_) -> :rand.uniform(i) end
    )
    # Time the adding of the sequence numbers to a list.
    {add, _} = :timer.tc(
      fn() -> Enum.each(
        seq,
        fn(e) -> EnvList.add(list, e, :foo) end
      ) end
    )
    # Time the lookup of the sequence numbers in a list.
    {lookup, _} = :timer.tc(
      fn() -> Enum.each(
        seq,
        fn(e) ->EnvList.lookup(list, e) end
      ) end
    )
    # Time the removal of the numbers in the sequence form the list.
    {remove, _} = :timer.tc(
      fn() -> Enum.each(
        seq,
        fn(e) -> EnvList.remove(list, e) end
      ) end
    )
    # Return the results.
    {i, add, lookup, remove}
  end

  def bench_list(n) do

    # List of sizes to test.
    ls = [16,32,64,128,256,512,1024,2*1024,4*1024,8*1024]
    # Print in console for easier reading of results.
    :io.format("# benchmark with ~w operations, time per operation in us\n", [n])
    :io.format("~6.s~12.s~12.s~12.s\n", ["n", "add", "lookup", "remove"])
    # For each size in the list.
    Enum.each(
      ls,
      fn (i) ->
        {i, tla, tll, tlr} = bench_list(i, n)
        :io.format("~6.w~12.2f~12.2f~12.2f\n", [i, tla/n, tll/n, tlr/n])
      end
    )
  end



  @doc """

  # Benchmark tree

  The following function starts the benchmark of the tree implementation using one argument n that says
  how many runs that'll be carried out. Note that there are two functions with
  the same name and that one of them is called upon by the other with and
  additional argument.

  # Example result
  # benchmark with 100000 operations, time per operation in us
  #     n         add      lookup      remove
  #    16        0.21        0.25        0.14
  #    32        0.20        0.16        0.14
  #    64        0.27        0.25        0.17
  #   128        0.23        0.20        0.18
  #   256        0.50        0.23        0.21
  #   512        0.25        0.22        0.27
  #  1024        0.40        0.29        0.37
  #  2048        0.34        0.30        0.32
  #  4096        0.47        0.36        0.38
  #  8192        0.45        0.34        0.46
  """

  def bench_tree(i, n) do
    # Generate a sequence of random numbers.
    seq = Enum.map(
      1..i,
      fn(_) -> :rand.uniform(i) end
      )
    # Generate a list of random numbers (based on seq).
    list = Enum.reduce(
      seq,
      nil,
      fn(k, list) -> EnvTree.add(list, k, :foo) end
      )
    # Generate a new sequence of random numbers.
    seq = Enum.map(
      1..n,
      fn(_) -> :rand.uniform(i) end
    )
    # Time the adding of the sequence numbers to a list.
    {add, _} = :timer.tc(
      fn() -> Enum.each(
        seq,
        fn(k) -> EnvTree.add(list, k, :foo) end
      ) end
    )
    # Time the lookup of the sequence numbers in a list.
    {lookup, _} = :timer.tc(
      fn() -> Enum.each(
        seq,
        fn(k) ->EnvTree.lookup(list, k) end
      ) end
    )
    # Time the removal of the numbers in the sequence form the list.
    {remove, _} = :timer.tc(
      fn() -> Enum.each(
        seq,
        fn(k) -> EnvTree.remove(list, k) end
      ) end
    )
    # Return the results.
    {i, add, lookup, remove}
  end

  def bench_tree(n) do

    # List of sizes to test.
    ls = [16,32,64,128,256,512,1024,2*1024,4*1024,8*1024]
    # Print in console for easier reading of results.
    :io.format("# benchmark with ~w operations, time per operation in us\n", [n])
    :io.format("~6.s~12.s~12.s~12.s\n", ["n", "add", "lookup", "remove"])
    # For each size in the list.
    Enum.each(
      ls,
      fn (i) ->
        {i, tla, tll, tlr} = bench_tree(i, n)
        :io.format("~6.w~12.2f~12.2f~12.2f\n", [i, tla/n, tll/n, tlr/n])
      end
    )
  end

end

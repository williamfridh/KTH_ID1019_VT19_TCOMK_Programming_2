defmodule Huffman do
  @moduledoc """
  Documentation for `Huffman`.
  """



  @doc """
  Sample.
  """
  def sample do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off'
  end



  @doc """
  Frequence.

  Takes a charlist and returns a map containing the characters
  and the amount of times they each accure.

  # Notes
  - This function is based on a charlist, that is a list of integers.

  # Example
  iex(14)> Huffman.freq('foo this is a test')
  [
    {32, 4},
    {97, 1},
    {101, 1},
    {102, 1},
    {104, 1},
    {105, 2},
    {111, 2},
    {115, 3},
    {116, 3}
  ]
  """
  def freq(sample) do freq(sample, %{}) end
  def freq([], frq) do Map.to_list(frq) end   # Convert the map into a list.
  def freq([char | rest], frq) do
    case Map.get(frq, char) do
      :nil ->
        freq(rest, Map.put(frq, char, 1))
      f ->
        freq(rest, Map.put(frq, char, f + 1))
    end
  end



  @doc """
  Huffman Tree.

  Generates a huffman tree.

  # Example
  iex(17)> Huffman.huffman_tree([{:z, 1}, {:q, 1}, {:f, 3}, {:g, 4}])
  {:g, {{:q, :z}, :f}}
  iex(18)> Huffman.huffman_tree([{:z, 1}, {:q, 1}, {:f, 3}, {:g, 4}, {:h, 4}])
  {{{:q, :z}, :f}, {:h, :g}}
  """
  def huffman_tree(freq) do
    sorted = Enum.sort(freq, fn({_, f1}, {_, f2}) -> f1 < f2 end)   # Sort frequency list.
    huffman(sorted)
  end



  @doc """
  Huffman.

  # Note
  - Used by huffman_tree/1
  """
  def huffman([{tree, _}]) do tree end
  def huffman([{tree1, f1}, {tree2, f2} | rest]) do
    node = {{tree1, tree2}, f1+f2}
    huffman(insert(node, rest))
  end



  @doc """
  Insert.

  # Note
  - Used by huffman/1
  """
  def insert(node, []) do [node] end
  def insert(node1, [node2 | rest] = nodes) do
    if (elem(node1, 1) <= elem(node2, 1)) do
      [node1 | nodes]
    else
      [node2 | insert(node1, rest)]
    end
  end



  @doc """
  Encoding Table.

  Perform a depth first treversal of the huffman tree to generate
  the encoding table. Once you find a leaf, you take the path
  used as the encoding and the character in the leaf.

  # Sources
  Wikipedia: https://en.wikipedia.org/wiki/Depth-first_search
  """
  def encode_table(tree) do encode_table(tree, [], %{}) end
  def encode_table({zero, one}, path, table) do
    table = encode_table(zero, [0 | path], table)   # First go down the left path,
    encode_table(one, [1 | path], table)            # then go down the right path.
  end
  def encode_table(char, path,table) do
    Map.put(table, char, Enum.reverse(path))        # Enum.reverse/1 to fix wrong order
                                                    # (needed as paths around from from leafts to top).
  end



  @doc """

  We reuse the tree to decode the encoded string into
  a list of characters again. It goes down the tree
  until a leaf is found. This is a more straight forward
  than generating a decoding table. It also performs
  better as it's generally more effective.
  """
  def decode(encoded, tree) do decode(encoded, tree, tree) end
  def decode([], _, _) do [] end
  def decode([0 | rest], {zero, _}, root) do
    decode(rest, zero, root)
  end
  def decode([1 | rest], {one, _}, root) do
    decode(rest, one, root)
  end
  def decode(encoded, char, root) do
    [char | decode(encoded, root, root)]
  end



  @doc """
  Test.

  # Example 1
  iex(20)> Huffman.test()
  %{
    10 => [1, 0, 0, 0, 0, 1],
    32 => [0, 1],
    97 => [0, 0, 1, 0],
    98 => [1, 1, 1, 0, 1, 1],
    99 => [1, 1, 0, 1, 1, 0],
    100 => [1, 0, 0, 0, 0, 0],
    101 => [1, 1, 1, 1],
    102 => [1, 1, 1, 0, 1, 0],
    103 => [1, 0, 1, 1, 0, 0, 0],
    104 => [1, 0, 1, 0, 1],
    105 => [1, 1, 1, 0, 0],
    106 => [1, 0, 0, 0, 1, 1, 0, 1],
    107 => [1, 0, 0, 0, 1, 1, 0, 0],
    108 => [1, 0, 0, 1],
    109 => [1, 0, 1, 1, 0, 0, 1],
    110 => [0, 0, 0, 1],
    111 => [0, 0, 1, 1],
    112 => [1, 1, 0, 1, 1, 1],
    113 => [1, 0, 0, 0, 1, 0, 1],
    114 => [1, 1, 0, 1, 0],
    115 => [0, 0, 0, 0],
    116 => [1, 1, 0, 0],
    117 => [1, 0, 1, 1, 1],
    118 => [1, 0, 0, 0, 1, 1, 1, 1],
    119 => [1, 0, 1, 0, 0],
    120 => [1, 0, 0, 0, 1, 0, 0],
    121 => [1, 0, 1, 1, 0, 1],
    122 => [1, 0, 0, 0, 1, 1, 1, 0]
  }
  Note how we're using 2-8 bits to encode the characters.

  # Exmaple 2
  iex(25)> :timer.tc(fn() -> Huffman.test() end)
  chars 318997
  bytes 333816
  alphabet 77
  compressed: 178600

  {318964, :ok}

  # Benchmark
  iex(18)> :timer.tc(fn() -> Huffman.test("data/lorem_100000.txt") end)
  chars 99999
  bytes 99999
  alphabet 41
  compressed: 53233
  eeeeeeeeee
  {80215, :ok}

  iex(22)> :timer.tc(fn() -> Huffman.test("data/lorem_200000.txt") end)
  chars 199999
  bytes 199999
  alphabet 41
  compressed: 106466
  eeeeeeeeee
  {177965, :ok}

  iex(27)> :timer.tc(fn() -> Huffman.test("data/lorem_300000.txt") end)
  chars 299999
  bytes 299999
  alphabet 41
  compressed: 159698
  eeeeeeeeee
  {237636, :ok}

  iex(33)> :timer.tc(fn() -> Huffman.test("data/lorem_400000.txt") end)
  chars 399999
  bytes 399999
  alphabet 41
  compressed: 212931
  eeeeeeeeee
  {462744, :ok}
  """
  def test (file) do
    {:ok, text, n, b} = read(file)
    :io.format("chars ~w\n bytes ~w\n", [n, b])
    freq = freq(text)
    :io.format(" alphabet ~w\n", [length(freq)])
    tree = huffman_tree(freq)
    etable = encode_table(tree)
    encoded = encode(text, etable)
    :io.format(" compressed: ~w\n", [div(length(encoded), 8) ])
    decoded = decode(encoded, tree)
    :io.format("~s \n", [Enum.take(decoded, 10)])
  end



  @doc """
  Read.

  Reads the content form a file and returns a tuple
  containing the data, length, and byte size.

  Note that this code is not written by the student.
  """
  def read(file) do
    text = File.read!(file)
    chars = String.to_charlist(text)
    {:ok, chars, String.length(text), Kernel.byte_size(text)}
  end



  @doc """
  Encode.

  Encode a string using a provided encoding table.
  """
  def encode([], _table) do [] end
  def encode([char | rest], table) do
    case Map.get(table, char) do
      :nil ->
        :io.format("error could not encode ~w\n", [char])
        encode(rest, table)                                     # Ignore and continue.
      seq ->
        seq ++ encode(rest, table)                              # Not tail recursive.
    end
  end

end

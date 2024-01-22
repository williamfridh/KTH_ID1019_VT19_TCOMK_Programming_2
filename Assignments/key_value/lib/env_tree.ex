# TODO LIST
#

# NOTES LIST
#

# =================================================================

defmodule EnvTree do

  @moduledoc """
  This module is used for basic support for trees with pairs. It holds
  the most basic functions one might need.

  The structure is based on the instructions given on the first page
  of the assignment file (see docs/assignment.pdf for details).
  """


  @doc """
  The following functions adds data to the tree in unique ways
  depending on the current state of the tree.

  ## Example
  tree = EnvTree.add(nil, :d, 42)
  tree = EnvTree.add(tree, :d, 1337)
  tree = EnvTree.add(tree, :b, 10)
  tree = EnvTree.add(tree, :a, 8)
  tree = EnvTree.add(tree, :n, 100)
  tree = EnvTree.add(tree, :m, 89)
  """
  def add(nil, key, value) do
    # ... adding a key-value pair to an empty tree ..
    {:node, key, value, nil, nil}
  end

  def add({:node, key, _, left, right}, key, value) do
    # ... if the key is found we replace it ..
    {:node, key, value, left, right}
  end

  def add({:node, k, v, left, right}, key, value) when key < k do
    # ... return a tree that looks like the one we have
    # but where the left branch has been updated ...
    {:node, k, v, add(left, key, value), right}
  end

  def add({:node, k, v, left, right}, key, value) do
    # ... same thing but instead update the right banch
    #right = add(right, key, value)
    {:node, k, v, left, add(right, key, value)}
  end



  @doc"""
  The following functions seaches for certain keys in the tree in unique
  ways depending on the structure of the tree.

  ## Example
  EnvTree.lookup(tree, :d)
  EnvTree.lookup(tree, :b)
  EnvTree.lookup(tree, :a)
  EnvTree.lookup(tree, :m)
  EnvTree.lookup(tree, :o)
  EnvTree.lookup(tree, :n)
  """
  def lookup({:node, key, value, left, right}, key) do
    # Current node id the goal node.
    {:node, key, value, left, right}
  end

  def lookup({:node, k, _, left, _}, key) when key < k and left != nil do
    # Explore left.
    lookup(left, key)
  end

  def lookup({:node, _, _, _, right}, key) when right != nil do
    # Explore right.
    lookup(right, key)
  end

  def lookup(_, key) do
    # Key not found in tree.
    # At a leaf.
    "Error: Key #{key} not found."
  end



  @doc"""
  The following functions are used for removing pairs from the tree with
  methods based on the current state of the tree.

  Note how the value is ignored in some of the functions.

  ## Example 1

  A
    B
      C

  tree = EnvTree(tree, :B)

  A
    C

  ## Example 2

      C
    B   D
  A       E

  tree = EnvTree(tree, C)

      D
    B   E
  A

  ## Example 3

        M
    B       N
  A   C       O

  tree = EnvTree(tree, C)

      D
    B   E
  A

  """
  def remove(nil, _) do
    # Empty tree detected.
    "Error: Empty tree detected."
  end

  def remove({:node, key, _, nil, right}, key) do
    # Found key, and right node exists which will replace the current.
    right
  end

  def remove({:node, key, _, left, nil}, key) do
    # Found key, and left node exists which will replace the current.
    left
  end

  def remove({:node, key, _, left, right}, key) do
    # Found key.
    right = leftmost(right)
    {_, k, v, _, r} = right
    {:node, k, v, left, r}
  end

  def remove({:node, k, v, left, right}, key) when key < k do
    # Explore node to the left.
    {:node, k, v, remove(left, key), right}
  end

  def remove({:node, k, v, left, right}, key) do
    # Explore node to the right.
    {:node, k, v, left, remove(right, key)}
  end

  def leftmost({:node, key, value, nil, rest}) do
    # Leftmost found.
    {:node, key, value, nil, rest}
  end

  def leftmost({:node, k, v, left, right}) do
    # Leftmost not found. Continue search to the left.
    left = leftmost(left)
    {:node, k, v, left, right}
  end

end

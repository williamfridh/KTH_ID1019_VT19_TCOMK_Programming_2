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

  # Example
  # tree = EnvTree.add(tree, :d, 42)
  # tree = EnvTree.add(tree, :d, 1337)
  # tree = EnvTree.add(tree, :b, 10)
  # tree = EnvTree.add(tree, :a, 8)
  # tree = EnvTree.add(tree, :n, 100)
  # tree = EnvTree.add(tree, :m, 89)
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

end

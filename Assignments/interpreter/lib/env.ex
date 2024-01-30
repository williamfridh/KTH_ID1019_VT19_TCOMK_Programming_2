# TODO LIST
#

# NOTES LIST
#

# =================================================================

  defmodule Env do

    @moduledoc """
    This module is used for basic support for lists of pairs. It holds
    the most basic functions one might need.

    The structure is based on the instructions given on the first page
    of the assignment file (see docs/assignment.pdf for details).
    """



    @doc """
    Return an empty list.

    # Exmaple:
    # new_list = Env.new()
    """
    def new() do [] end



    @doc """
    Return a list where an association of the
    key key and the data structure value has been added to the given
    list. If there already is an association of the key the value is changed.

    # Example:
    list = []
    list = Env.add(list, :a, "a")
    >> a a
    list = Env.add(list, :b, "b")
    >> a a, b b
    list = Env.add(list, :c, "c")
    >> a a, b b, c c
    list = Env.add(list, :b, "2")
    >> a a, b 2, c c
    """
    def add([], key, value) do [{key, value }] end
    def add([h | t], key, value) do
      {k, v} = h
      if k == key do # Update current.
        [{k, value} | t]
      else # Dive deeper.
        [h | add(t, key, value)]
      end
    end



    @doc """
    Return either {key, value}, if the key key is associated with
    the data structure value, or nil if no association is found.

    # Exmaple:
    res = Env.lookup(map, :a)
    """
    def lookup([], _) do nil end
    def lookup(map, key) do
      [h | t] = map
      {k, v} = h
      if k == key do
        h
      else
        if h == t do
          nil
        else
          lookup(t, key)
        end
      end
    end



    @doc """
    Returns a map where the association of the key
    key has been removed.

    # Example:
    new_map = Env.remove(map, :a)
    """
    def remove([], key) do nil end
    def remove(map, key) do
      [h | t] = map
      {k, _} = h
      if k == key do
        t
      else
        [h | remove(t, key)]
      end
    end

  end

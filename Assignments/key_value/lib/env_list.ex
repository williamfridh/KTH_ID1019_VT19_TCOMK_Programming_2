# TODO LIST
#

# NOTES LIST
#

# =================================================================

  defmodule EnvList do

    @moduledoc """
    This module is used for basic support for lists of pairs. It holds
    the most basic functions one might need.

    The structure is based on the instructions given on the first page
    of the assignment file (see docs/assignment.pdf for details).
    """



    @doc """
    Return an empty list.

    # Exmaple:
    # new_list = EnvList.new()
    """
    def new() do [] end



    @doc """
    Return a list where an association of the
    key key and the data structure value has been added to the given
    list. If there already is an association of the key the value is changed.

    # Example:
    list = []
    list = EnvList.add(list, :a, "a")
    >> a a
    list = EnvList.add(list, :b, "b")
    >> a a, b b
    list = EnvList.add(list, :c, "c")
    >> a a, b b, c c
    list = EnvList.add(list, :b, "2")
    >> a a, b 2, c c
    """
    def add([], key, value) do
      [{key, value }]
    end

    def add([h | t], key, value) do
      if h == t do
        # Insert new.
        [h | {key, value}]
      else
        {k, v} = h
        if k == key do
          # Update current.
          [{k, value} | t]
        else
          # Dive deeper.
          [h | add(t, key, value)]
        end
      end
    end



    @doc """
    Return either {key, value}, if the key key is associated with
    the data structure value, or nil if no association is found.

    # Exmaple:
    # res = EnvList.lookup(map, :a)
    """
    def lookup([h | t], key) do
      [h | t]
    end



    @doc """
    Returns a map where the association of the key
    key has been removed.

    # Exmaple:
    # new_map = EnvList.remove(map, :a)
    """
    def remove(map, key) do
      {value, updated_map} = Map.pop(map, key)
      updated_map
    end

  end

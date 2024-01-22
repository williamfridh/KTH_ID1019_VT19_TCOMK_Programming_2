# TODO LIST
#

# NOTES LIST
#

# =================================================================

  defmodule EnvList do

    @moduledoc """
    This module is used for basic support for maps with pairs. It holds
    the most basic functions one might need.

    The structure is based on the instructions given on the first page
    of the assignment file (see docs/assignment.pdf for details).
    """



    @doc """
    Return an empty map.

    # Exmaple:
    # new_map = EnvList.new()
    """
    def new() do %{} end



    @doc """
    Return a map where an association of the
    key key and the data structure value has been added to the given
    map. If there already is an association of the key the value is changed.

    # Exmaple:
    # map = EnvList.new(map, :a, 42)
    """
    def add(map, key, value) do
      if Map.has_key?(map, :key) do
        %{map | key: value}
      else
        Map.put(map, key, value)
      end
    end



    @doc """
    Return either {key, value}, if the key key is associated with
    the data structure value, or nil if no association is found.

    # Exmaple:
    # res = EnvList.lookup(map, :a)
    """
    def lookup(map, key) do
      Map.get(map, key)
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

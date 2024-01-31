# TODO LIST
# TODO: Clean up the messy closure/2 and add :error return.

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
    # Environment Closure

    Creates a new environment that only contains the gre variables
    inside the list free.
    """
    def closure(free, env) do
      closure(free, env, new())
    end
    def closure([h | t], env, newenv) do

      if t != [] do

        case lookup(env, h) do
          {k, v} ->
            add(closure(t, env, newenv), k, v)
          nil ->
            []
        end

      else

        case lookup(env, h) do
          {k, v} ->
            add(newenv, k, v)
          nil ->
            []
        end

      end

    end



    @doc """
    # Arguments
    """
    def args(par, strs, closure) do
      IO.puts "##ARGS"
      IO.inspect par
      IO.inspect strs
      IO.inspect closure
      IO.inspect closure ++ par ++ strs
    end



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
    def add([], key, value) do [{key, value}] end
    def add([h | t], key, value) do
      {k, _} = h
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
      {k, _} = h
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
    def remove([], _) do [] end
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

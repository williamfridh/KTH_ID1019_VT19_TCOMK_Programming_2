defmodule Chopstick do
  @moduledoc """
  Documentation for the module Chopstick.
  """


  @doc """
  Start.
  """
  def start() do
    stick = spawn_link(fn -> available() end)
  end



  @doc """
  Available.
  """
  def available() do
    receive do
      {:request, from} ->
        IO.puts("Stick requested by #{from}")
        gone()
      :return ->
        IO.puts("Stick already returned")
        available()
      :quit -> :ok
    end
  end



  @doc """
  Gone.
  """
  def gone() do
    receive do
      {:request, from} ->
        IO.puts("Stick requested by #{from}, but it's already in use")
        gone()
      :return ->
        IO.puts("Stick returned")
        available()
      :quit -> :ok
    end
  end



  @doc """
  Request.
  """
  def request(stick, from) do
    send(stick, {:request, from})
  end



  @doc """
  Return.
  """
  def return(stick) do
    send(stick, :return)
  end



  @doc """
  Remove.
  """
  def remove(stick) do
    Process.exit(stick, :shutdown)
  end

end

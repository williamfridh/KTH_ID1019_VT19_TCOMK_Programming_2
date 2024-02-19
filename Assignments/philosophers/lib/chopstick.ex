defmodule Chopstick do
  @moduledoc """
  Documentation for the module Chopstick.
  """


  @doc """
  Start.
  """
  def start() do
    spawn_link(fn -> available() end)
  end



  @doc """
  Available.
  """
  def available() do
    receive do
      :request ->
        IO.puts("Stick requested")
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
      :request ->
        IO.puts("Stick requested, but it's already in use")
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
  def request(stick) do
    x = send(stick, :request)
    IO.inspect
    #receive do
    #  {:request, from} ->

    #end
  end



  @doc """
  Return.
  """
  def return(stick, name) do
    IO.puts("Chopstick returned by #{name}")
    send(stick, :return)
  end



  @doc """
  Remove.
  """
  def remove(stick) do
    IO.puts("Chopstick removed")
    Process.exit(stick, :shutdown)
  end

end

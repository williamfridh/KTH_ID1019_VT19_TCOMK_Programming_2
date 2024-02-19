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
      {:request, caller} ->
        send(caller, :ok)
        gone()
      {:return, caller} ->
        send(caller, :bad)
        available()
      :quit -> :ok
    end
  end



  @doc """
  Gone.
  """
  def gone() do
    receive do
      {:request, caller} ->
        send(caller, :bad)
        gone()
      {:return, caller} ->
        send(caller, :ok)
        available()
      :quit -> :ok
    end
  end



  @doc """
  Request.
  """
  def request(stick, name, timeout) do
    send(stick, {:request, self()})
    receive do
      :ok ->
        #IO.puts("#{name} -- Got a chopstick")
        :ok
      :bad ->
        #IO.puts("#{name} -- Didn't get a chopstick")
        :bad
    after timeout ->
      IO.puts("#{name} -- Don't want to wait longer for a chopstick")
      :timeout
    end
  end



  @doc """
  Return.
  """
  def return(stick, name) do
    send(stick, {:return, self()})
    receive do
      :ok ->
        #IO.puts("#{name} -- Returned a chopstick")
        :ok
      :bad ->
        #IO.puts("#{name} -- Didn't have a chopstick to return")
        :bad
    end
  end



  @doc """
  Remove.
  """
  def remove(stick) do
    IO.puts("Chopstick removed")
    Process.exit(stick, :shutdown)
  end

end

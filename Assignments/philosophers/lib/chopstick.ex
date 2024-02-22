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
      {:request, ref, caller} ->
        send(caller, :granted)
        gone(ref)
      {:return, caller} ->
        send(caller, :denied)
        available()
      :quit -> :ok
    end
  end



  @doc """
  Gone.
  """
  def gone(ref) do
    receive do
      {:request, caller} ->
        send(caller, :denied)
        gone(ref)
      {:return, ^ref, caller} ->
        send(caller, :granted)
        available()
      :quit -> :ok
    end
  end



  @doc """
  Request.

  Note: This function does not need to listen for :bad.
  """
  def request(stick, name, timeout) do
    send(stick, {:request, self()})
    receive do
      :ok ->
        :ok
    after timeout ->
      #IO.puts("#{name} -- Don't want to wait longer for a chopstick")
      :timeout
    end
  end



  @doc """
  Asynchronous Request.
  """
  def async_request(c1, c2, name, timeout, ref) do async_request(c1, c2, name, timeout, ref, 0) end
  def async_request(c1, c2, name, timeout, ref, count) when count == 2 do :granted end
  def async_request(c1, c2, name, timeout, ref, count) do
    #IO.puts("a")
    if (count == 0) do
      send(c1, {:request, ref, self()})
      send(c2, {:request, ref, self()})
    end
    #IO.puts("b")
    receive do
      :granted ->
        if (count == 0) do
          #IO.puts("#{name} -- Picked up the first chopstick")
        else
          #IO.puts("#{name} -- Picked up the second chopstick")
        end
        async_request(c1, c2, name, timeout, ref, count + 1)
    after timeout ->
      #IO.puts("#{name} -- Don't want to wait longer for a chopstick")
      return(c1, name, ref)
      return(c2, name, ref)
      :timeout
    end
  end



  @doc """
  Return.
  """
  def return(stick, name, ref) do
    send(stick, {:return, ref, self()})
    receive do
      :granted ->
        #IO.puts("#{name} -- Returned a chopstick")
        :granted
      :denied ->
        #IO.puts("#{name} -- Didn't have a chopstick to return")
        :denied
    end
  end



  @doc """
  Asynchronous Return.
  """
  #def async_return(c1, c2, name) do
  #  task1 = Task.async(fn -> return(c1, name) end)
  #  task2 = Task.async(fn -> return(c2, name) end)
  #  r1 = Task.await(task1)
  #  r2 = Task.await(task2)
  #  :ok
  #end



  @doc """
  Remove.
  """
  def remove(stick) do
    #IO.puts("Chopstick removed")
    Process.exit(stick, :shutdown)
  end

end

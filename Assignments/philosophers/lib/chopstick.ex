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
  def async_request(c1, c2, name, timeout) do
    task1 = Task.async(fn -> request(c1, name, timeout) end)
    task2 = Task.async(fn -> request(c2, name, timeout) end)
    r1 = Task.await(task1)
    r2 = Task.await(task2)
    case {r1, r2} do
      {_, :timeout} ->
        IO.puts("#{name} -- Don't want to wait longer for a chopsticks")
        return(c2, name)
        :timeout
      {:timeout, _} ->
        IO.puts("#{name} -- Don't want to wait longer for a chopsticks")
        return(c1, name)
        :timeout
      {:ok, :ok} -> :ok
    end
  end



  @doc """
  Return.
  """
  def return(stick, name) do
    send(stick, {:return, self()})
    receive do
      :ok ->
        IO.puts("#{name} -- Returned a chopstick")
        :ok
      :bad ->
        IO.puts("#{name} -- Didn't have a chopstick to return")
        :bad
    end
  end



  @doc """
  Asynchronous Return.
  """
  def async_return(c1, c2, name) do
    task1 = Task.async(fn -> return(c1, name) end)
    task2 = Task.async(fn -> return(c2, name) end)
    r1 = Task.await(task1)
    r2 = Task.await(task2)
    :ok
  end



  @doc """
  Remove.
  """
  def remove(stick) do
    IO.puts("Chopstick removed")
    Process.exit(stick, :shutdown)
  end

end

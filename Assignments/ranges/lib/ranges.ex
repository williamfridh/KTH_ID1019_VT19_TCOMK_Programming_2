defmodule Ranges do
  @moduledoc """
  Documentation for `Ranges`.
  """



  @doc """
  Run.

  Base function to call with the txt-file path as the only argument.
  """
  def run(path) do
    {seeds, maps} = path |> getFileContent() |> seperateSeedAndMaps()
    followSeed(seeds, maps, nil)
  end



  @doc """
  Follow Seed.

  Follows the seeds in the given list trough the map
  and returns the smallest numer found.
  """
  def followSeed([seed | seedRem], maps, lowest) do
    res = followMapping(seed, maps)
    if (lowest == nil || lowest > res) do
      followSeed(seedRem, maps, res)
    else
      followSeed(seedRem, maps, lowest)
    end
  end
  def followSeed([], _, lowest) do lowest end



  @doc """
  Get File Content.
  """
  def getFileContent(path) do
    case File.read(path) do
      {:ok, content} -> content
      {:error, reason} -> IO.puts("Error reading file: #{reason}")
    end
  end



  @doc """
  Seperate seed and maps.
  """
  def seperateSeedAndMaps([s | m]) do
    [_ | seeds] = String.split(s, " ")
    seeds = seeds |> Enum.map(&String.to_integer/1)
    maps = getMappings(m)
    {seeds, maps}
  end
  def seperateSeedAndMaps(txt) do
    arr = String.split(txt, "\n\n")
    seperateSeedAndMaps(arr)
  end



  @doc """
  Get Mappings.
  """
  def getMappings([h | t]) do
    [_ | maps] = String.split(h, "\n")
    [mapListToTuple(maps) | getMappings(t)]
  end
  def getMappings([]) do [] end



  @doc """
  Map list to tuple.
  """
  def mapListToTuple([map | maps]) do
    [e1, e2, e3] = String.split(map, " ")
    [e1, e2, e3] = [e1, e2, e3] |> Enum.map(&String.to_integer/1)
    [{e1, e2, e3} | mapListToTuple(maps)]
  end
  def mapListToTuple([]) do [] end



  @doc """
  Follow mapping.
  """
  def followMapping(seed, [map | mapRem]) do
    tmp = followMapRow(seed, map)
    followMapping(tmp, mapRem)
  end
  def followMapping(seed, []) do seed end

  def followMapRow(seed, [{dest, src, range} | t]) do
    if seed >= src && seed <= src + range do
      seed - src + dest
    else
      followMapRow(seed, t)
    end
  end

  def followMapRow(seed, []) do seed end

end

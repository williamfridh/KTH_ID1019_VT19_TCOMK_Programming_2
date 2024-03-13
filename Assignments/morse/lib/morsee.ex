defmodule Morsee do

	@doc """
	Decode.
	"""
	def decode(msg) do
		tree = MorseCode.tree()
		decode(msg, tree, tree)
	end
	def decode([], _, _) do [] end
	def decode([?- | rest], {:node, _, long, _}, root) do
		decode(rest, long, root)
	end
	def decode([?. | rest], {:node, _, _, short}, root) do
		decode(rest, short, root)
	end
	def decode([?\s | rest], {:node, char, _, _}, root) do
		[char | decode(rest, root, root)]
	end



	@doc """
	Encode.
	"""
	def encode(text) do
		tree = MorseCode.tree()
		table = encode_table(tree)
		encode(text, table)
	end
	def encode([], _) do [] end
	def encode([char | rest], table) do
		code = table[char]
		code ++ [?\s | encode(rest, table)]
	end



	@doc """
	Encode Table.
	"""
	def encode_table(tree) do
		encode_table(tree, [], %{})
	end
	def encode_table(:nil, _code, map) do map end
	def encode_table({:node, :na, long, short}, code, map) do
		map = encode_table(long, [?- | code], map)
		encode_table(short, [?. | code], map)
	end
	def encode_table({:node, char, long, short}, code, map) do
		map = Map.put(map, char, Enum.reverse(code))
		map = encode_table(long, [?- | code], map)
		encode_table(short, [?. | code], map)
	end

end

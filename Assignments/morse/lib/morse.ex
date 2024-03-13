defmodule Morse do

	@moduledoc """
	Documentation for the module Morse.

	Huffman Tree inly has characters in the leafs, while in the
	morse tree, there are characters in each node. This works since
	morse code has the "pause", the third element that tells when
	us to take the charcter we're currently at in the morse tree.
	"""

	# ASCII codes: . = 46 & - = 45 & space = 32
	# 45 = left
	# 46 = right
	# 32 = end of word
	def decode(code, tree) do List.to_string(decode(code, tree, tree, [], :nil)) end
	def decode([], _, _, res, lastFound) do res ++ [lastFound] end
	def decode([h | t], root, {:node, char, left, _}, res, _lastFound) when h == ?- do
		#IO.puts("Going left")
		decode(t, root, left, res, char)
	end
	def decode([h | t], root, {:node, char, _, right}, res, _lastFound) when h == ?. do
		#IO.puts("Going right")
		decode(t, root, right, res, char)
	end
	def decode([h | t], root, _, res, :na) when h == ?\s do
		#IO.inspect(h)
		decode(t, root, root, res, :nil)
	end
	def decode([h | t], root, _, res, lastFound) when h == ?\s do
		#IO.inspect(h)
		decode(t, root, root, res ++ [lastFound], :nil)
	end

end

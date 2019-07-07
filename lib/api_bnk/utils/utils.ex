defmodule ApiBnK.Utils.Utils do
  def add_prefix_on_atom(atom, prefix) do
    atom
    |> Atom.to_string
    |> (&("#{prefix}#{&1}" )).()
    |> String.to_atom
  end

  def remove_prefix_on_atom(atom, prefix) do
    base = String.length(prefix)
    atom
    |> Atom.to_string
    |> (&(String.slice(&1, base..-1))).()
    |> String.to_atom
  end

end

defmodule BlogAppGql.Utils do
  def add_prefix_on_atom(atom, prefix) do
    atom
    |> Atom.to_string
    |> (&("#{prefix}#{&1}" )).()
    |> String.to_atom
  end
end

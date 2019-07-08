defmodule ApiBnK.Utils.Utils do
  @moduledoc """
  Módulo que contém funções utilitárias
  """

  @doc """
  Adiciona um prefixo no nome do variável do tipo atomo.

  ## Parâmetros

    - atom: Variável do tipo átomo em que o prefixo será adicionado.
    - prefix: Prefixo que será adicionado na variável informada.

  ## Exemplos

      iex> ApiBnK.Utils.Utils.add_prefix_on_atom(:last, "first_")
      :first_last

      iex> ApiBnK.Utils.Utils.add_prefix_on_atom(:last_name, "first_name_")
      :first_name_last_name
  """
  @spec add_prefix_on_atom(Atom.t(), String.t()) :: Atom.t()
  def add_prefix_on_atom(atom, prefix) do
    atom
    |> Atom.to_string
    |> (&("#{prefix}#{&1}" )).()
    |> String.to_atom
  end


  @doc """
  Remove um prefixo no nome do variável do tipo atomo.

  ## Parâmetros

    - atom: Variável do tipo átomo em que o prefixo será removido.
    - prefix: Prefixo que será removido na variável informada.

  ## Exemplos

      iex> ApiBnK.Utils.Utils.remove_prefix_on_atom(:first_last, "first_")
      :last

      iex> ApiBnK.Utils.Utils.remove_prefix_on_atom(:first_name_last_name, "first_name_")
      :last_name
  """
  @spec remove_prefix_on_atom(Atom.t(), String.t()) :: Atom.t()
  def remove_prefix_on_atom(atom, prefix) do
    base = String.length(prefix)
    atom
    |> Atom.to_string
    |> (&(String.slice(&1, base..-1))).()
    |> String.to_atom
  end

end

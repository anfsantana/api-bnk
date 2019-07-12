defmodule ApiBnK.Financial.Functions.FinancialUtils do
  @moduledoc """
  Módulo que contêm funções úteis utilizadas em operações financeiras
  """

  alias Decimal, as: D

  @doc """
  Função que verifica se existe saldo

  ## Parâmetros

    - balance: Saldo em conta
    - value: Valor de comparação

  ## Exemplos

      iex> ApiBnK.Financial.Functions.FinancialUtils.have_balance?(132.59, 102.99)
      {:ok, 132.59}

      iex> ApiBnK.Financial.Functions.FinancialUtils.have_balance?(1486.98, 2000.90)
      {:validation_error, "Não possui saldo suficiente."}
  """
  def have_balance?(balance \\ 0.00, value \\ 0.00) do
    result = D.cmp(D.cast(balance), D.cast(value))
    if result == :eq || result == :gt do
      {:ok, balance}
    else
      {:validation_error, "Não possui saldo suficiente."}
    end

  end

  @doc """
  Verifica se o valor informado é maior do que zero

  ## Parâmetros

    - value: Valor que será verificado

  ## Exemplos

      iex> ApiBnK.Financial.Functions.FinancialUtils.value_greater_than_zero?(132.59)
      {:ok, 132.59}

      iex> ApiBnK.Financial.Functions.FinancialUtils.value_greater_than_zero?(0)
      {:validation_error, "Valor informado é menor ou igual a zero."}

      iex> ApiBnK.Financial.Functions.FinancialUtils.value_greater_than_zero?(-1)
      {:validation_error, "Valor informado é menor ou igual a zero."}
  """
  def value_greater_than_zero?(value \\ 0.00) do
    if D.cmp(D.cast(value), D.cast(0.00)) == :gt do
      {:ok, value}
    else
      {:validation_error, "Valor informado é menor ou igual a zero."}
    end

  end

end

defmodule BlogAppGql.Financial.Functions.FinancialUtils do
  alias Decimal, as: D

  def have_balance?(balance \\ 0.00, value \\ 0.00) do
    result = D.cmp(D.cast(balance), D.cast(value))
    if result == :eq || result == :gt do
      {:ok, balance}
    else
      {:error, "Não possui saldo suficiente."}
    end

  end

  def value_greater_than_zero?(value \\ 0.00) do
    if D.cmp(D.cast(value), D.cast(0.00)) == :gt do
      {:ok, value}
    else
      {:error, "Valor informado é menor ou igual a zero."}
    end

  end

end

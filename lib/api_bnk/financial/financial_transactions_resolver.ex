defmodule ApiBnK.Financial.FinancialTransactionsResolver do
  alias ApiBnK.Financial.FinancialTransactionsQuery
  alias ApiBnK.Financial.Functions.FinancialUtils
  alias ApiBnK.Utils.Utils
  alias ApiBnK.Utils.StatusResponse
  alias ApiBnK.Repo
  alias Decimal, as: D

  # TODO Modificado por anf
  def balance(_args, %{context: %{current_user: current_user}}) do
    balance = FinancialTransactionsQuery.get_balance(current_user.acc_agency, current_user.acc_account)
    {:ok, balance}
  end

  def balance(_args, _info) do
    {:error, "Not Authorized"}
  end


  # TODO Modificado por anf
  def transfer(args, %{context: %{current_user: current_user}}) do

    v_balance = FinancialTransactionsQuery.get_balance(current_user.acc_agency, current_user.acc_account)

    Repo.transaction(fn ->
      with {:ok, value_to_deposit} <- args.value |> FinancialUtils.value_greater_than_zero?(),
           {:ok, _} <- v_balance |> FinancialUtils.have_balance?(value_to_deposit),
           {:ok, _} <- args
                       |> Map.put(:description, "Transferência recebida")
                       |> rename_keys()
                       |> FinancialTransactionsQuery.insert_financial_transaction_deposit(),
           {:ok, _} <- %{account: current_user.acc_account, agency: current_user.acc_agency,
                          bank_code: current_user.acc_bank_code, description: "Transferência enviada",
                          value: D.cast((args.value * -1))}
                        |> rename_keys()
                        |> FinancialTransactionsQuery.insert_financial_transaction_deposit()

      do
        StatusResponse.get_status_response_by_key(:OK)
      else
        {:error, msg} -> {:error, msg}
      end

    end)

  end

  def transfer(_args, _info) do
    {:error, "Not Authorized"}
  end

  def deposit(_args, _info) do
    {:error, "Not Authorized"}
  end

  # TODO Modificado por anf
  def deposit(args) do
    args
    |> rename_keys()
    |> FinancialTransactionsQuery.insert_financial_transaction_deposit()
  end

  # TODO - Função para adicionar o prefixo no nome das colunas
  defp rename_keys(map), do: for {key, val} <- map, into: %{}, do: {Utils.add_prefix_on_atom(key, "fint_"), val}

end

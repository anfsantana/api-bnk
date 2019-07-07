defmodule BlogAppGql.Accounts.AccountsResolver do
  alias BlogAppGql.AccountsQuery
  alias BlogAppGql.Utils
  alias BlogAppGql.Financial.FinancialTransactionsResolver
  import BlogAppGql.AuthHelper
  alias BlogAppGql.Repo

  def all(_args, %{context: %{current_user: _current_user}}) do
    {:ok, AccountsQuery.list_users()}
  end

  def all(_args, _info) do
	  {:error, "Not Authorized"}
  end

  def find(%{agency: agency, account: account}, %{context: %{current_user: _current_user}}) do
    case AccountsQuery.get_account_by_agency_account(agency, account) do
      nil -> {:error, "Account agency #{agency} and #{account}} not found!"}
      user -> {:ok, user}
    end
  end

  def find(_args, _info) do
	  {:error, "Not Authorized"}
  end

  def update(%{agency: agency, account: account, account_params: account_params}, %{context: %{current_user: _current_user}} = info) do
    case find(%{agency: agency, account: account}, info) do
      {:ok, acc} -> acc |> AccountsQuery.update_account(rename_keys(account_params))
      {:error, _} -> {:error, "Account agency #{agency} and #{account} not found"}
    end

  end

  def update(_args, _info) do
    {:error, "Not Authorized"}
  end

  def login(%{agency: agency, account: account, password: password}, _info) do
    with {:ok, user} <- login_with_agency_account_pass(agency, account, password),
         {:ok, jwt, _} <- BlogAppGql.Guardian.encode_and_sign(user) ,
         {:ok, _ } <- BlogAppGql.AccountsQuery.store_token(user, jwt) do
      {:ok, %{token: jwt}}
    end
  end

  def logout(_args,  %{context: %{current_user: current_user, token: _token}}) do
    BlogAppGql.AccountsQuery.revoke_token(current_user, nil)
    {:ok, current_user}
  end

  def logout(_args, _info) do
    {:error, "Please log in first!"}
  end

  def create(params, _info) do
    Repo.transaction(fn ->
      result = params
      |> rename_keys()
      |> AccountsQuery.create_account()

      case result do
        {:ok, params} ->  %{account: params.acc_account, agency: params.acc_agency,
          bank_code: params.acc_bank_code, description: "Cadastro completo!", value: 1000.00} |> FinancialTransactionsResolver.deposit()
        {:error, _} -> {:error, "Error createAccount"}
      end
      params
    end)

  end

  # TODO - Função para adicionar o prefixo no nome das colunas
  defp rename_keys(map), do: for {key, val} <- map, into: %{}, do: {Utils.add_prefix_on_atom(key, "acc_"), val}

end

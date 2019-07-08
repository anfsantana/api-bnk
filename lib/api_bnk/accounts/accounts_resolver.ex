defmodule ApiBnK.Accounts.AccountsResolver do
  alias ApiBnK.Accounts.AccountsQuery
  alias ApiBnK.Utils.Utils
  alias ApiBnK.Utils.StatusResponse
  alias ApiBnK.Financial.FinancialTransactionsResolver
  alias ApiBnK.Repo
  import ApiBnK.AuthHelper

  def update(args, %{context: %{current_user: current_user}} = info) do
    case do_find(%{agency: current_user.acc_agency, account: current_user.acc_account}, info) do
      {:ok, acc} -> AccountsQuery.update_account(acc, rename_keys(args))
      {:error, message} -> {:error, message}
    end

  end
  def update(_args, _info) do
    {:error, "Restrict area"}
  end

  defp find(%{agency: agency, account: account}, %{context: %{current_user: _current_user}}) do
    case AccountsQuery.get_account_by_agency_account(agency, account) do
      nil -> {:error, "Account agency #{agency} and #{account}} not found!"}
      user -> {:ok, user}
    end

  end
  defp find(_args, _info) do
    {:error, "Restrict area"}
  end

  def login(%{agency: agency, account: account, password: password}, _info) do
    with {:ok, user} <- login_with_agency_account_pass(agency, account, password),
         {:ok, jwt, _} <- ApiBnK.Guardian.encode_and_sign(user) ,
         {:ok, _ } <- AccountsQuery.store_token(user, jwt) do
      {:ok, %{token: jwt}}
    end

  end

  def authorization(%{password: password}, %{context: %{current_user: current_user}} = info) do
    with {:ok, user} <- login_with_agency_account_pass(current_user.acc_agency, current_user.acc_account, password),
         {:ok, jwt, _} <- ApiBnK.Guardian.encode_and_sign(user) ,
         {:ok, _ } <- AccountsQuery.store_autho_token(user, jwt) do
      {:ok, %{token: jwt}}
    end

  end
  def authorization(_args, _info) do
    {:error, "Por favor, efetue o login."}
  end

  def create(params, _info) do
    add = fn(map, key, value) -> Map.put(map, key, value) end

    Repo.transaction(fn ->
      with {:ok, params} <- params |> rename_keys()
                                   |> AccountsQuery.create_account(),
           {:ok, _} <- %{}
                       |> add.(:account, params.acc_account)
                       |> add.(:agency, params.acc_agency)
                       |> add.(:bank_code, params.acc_bank_code)
                       |> add.(:description, "Cadastro completo!")
                       |> add.(:value, 1000.00)
                       |> FinancialTransactionsResolver.deposit() do
        StatusResponse.get_status_response_by_key(:CREATED)
      else
        {:error, msg} -> {:error, msg}
      end

    end)

  end

  def logout(_args,  %{context: %{current_user: current_user, token: _token}}) do
    case AccountsQuery.revoke_all_token(current_user, nil, nil) do
      {:ok, _} -> {:ok, StatusResponse.get_status_response_by_key(:OK)}
      {:error, msg} -> {:error, msg}
    end

  end
  def logout(_args, _info) do
    {:error, "Por favor, efetue o login"}
  end

  def revoke(_args,  %{context: %{current_user: current_user, token: _token}}) do
    case AccountsQuery.revoke_autho_token(current_user, nil) do
      {:ok, _} -> {:ok, StatusResponse.get_status_response_by_key(:OK)}
      {:error, msg} -> {:error, msg}
    end

  end

  # TODO - Função para adicionar o prefixo no nome das colunas
  defp rename_keys(map) do
    for {key, val} <- map, into: %{}, do: {Utils.add_prefix_on_atom(key, "acc_"), val}
  end

  defp remove_prefix_keys(map) do
    for {key, val} <- map, into: %{}, do: {Utils.remove_prefix_on_atom(key, "acc_"), val}
  end

end

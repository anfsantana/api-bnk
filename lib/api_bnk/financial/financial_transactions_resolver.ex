defmodule ApiBnK.Financial.FinancialTransactionsResolver do

  alias ApiBnK.Financial.FinancialTransactionsQuery
  alias ApiBnK.Financial.Functions.FinancialUtils
  alias ApiBnK.Accounts.AccountsResolver
  alias ApiBnK.Utils.Utils
  alias ApiBnK.Utils.StatusResponse
  alias ApiBnK.Repo
  alias Decimal, as: D


  def report_back_office(args, _info) do
    add = fn(map, key, value) -> Map.put(map, key, value) end
    date_time_now = NaiveDateTime.add(NaiveDateTime.utc_now(), -(3600 * 3), :second)
    start_date_time_today = %DateTime{year: date_time_now.year, month: date_time_now.month, day: date_time_now.day,
                              zone_abbr: "BRT", hour: 00, minute: 0, second: 0, microsecond: {0, 0}, utc_offset: -(3600 * 3),
                              std_offset: 0, time_zone: "Brasilia Time"}

    end_date_time_today = start_date_time_today
                            |> (&(%{ &1 | hour: 23})).()
                            |> (&(%{ &1 | minute: 59})).()
                            |> (&(%{ &1 | second: 59})).()
                            |> DateTime.to_naive()

    start_date_time_month = start_date_time_today
                            |> (&(%{ &1 | day: 1})).()
                            |> DateTime.to_naive()

    end_date_time_month = start_date_time_today
                            |> (&(%{ &1 | day: Date.days_in_month(&1)})).()
                            |> (&(%{ &1 | hour: 23})).()
                            |> (&(%{ &1 | minute: 59})).()
                            |> (&(%{ &1 | second: 59})).()
                            |> DateTime.to_naive()

    start_date_time_year = start_date_time_today
                            |> (&(%{ &1 | day: 1})).()
                            |> (&(%{ &1 | month: 1})).()
                            |> DateTime.to_naive()

    end_date_time_year = start_date_time_today
                            |> (&(%{ &1 | day: 31})).()
                            |> (&(%{ &1 | month: 12})).()
                            |> (&(%{ &1 | hour: 23})).()
                            |> (&(%{ &1 | minute: 59})).()
                            |> (&(%{ &1 | second: 59})).()
                            |> DateTime.to_naive()

    result = %{}
              |> add.(:total_day, FinancialTransactionsQuery.get_report_back_office(DateTime.to_naive(start_date_time_today), end_date_time_today))
              |> add.(:total_month, FinancialTransactionsQuery.get_report_back_office(start_date_time_month, end_date_time_month))
              |> add.(:total_year, FinancialTransactionsQuery.get_report_back_office(start_date_time_year, end_date_time_year))
    {:ok, result}
  end

  def balance(_args, %{context: %{current_user: current_user}}) do
    balance = FinancialTransactionsQuery.get_balance(current_user.acc_agency, current_user.acc_account)
    {:ok, balance}
  end
  def balance(_args, _info), do: {:error, "Área restrita"}

  def transfer(args, ctx= %{context: %{current_user: current_user, token: _token, autho_token: _autho_token}}) do
    discount = fn(x) -> D.cast((x * -1)) end
    add = fn(map, key, value) -> Map.put(map, key, value) end

    v_balance = FinancialTransactionsQuery.get_balance(current_user.acc_agency, current_user.acc_account)

    Repo.transaction(fn ->
      with {:ok, value_to_deposit} <- args.value |> FinancialUtils.value_greater_than_zero?(),
           {:ok, _} <- v_balance |> FinancialUtils.have_balance?(value_to_deposit),
           {:ok, _} <- args
                       |> add.(:description, "Transferência recebida")
                       |> rename_keys()
                       |> FinancialTransactionsQuery.insert_financial_transaction_deposit(),
           {:ok, _} <- %{}
                       |> add.(:account, current_user.acc_account)
                       |> add.(:agency, current_user.acc_agency)
                       |> add.(:bank_code, current_user.acc_bank_code)
                       |> add.(:description, "Transferência enviada")
                       |> add.(:value, discount.(args.value))
                       |> rename_keys()
                       |> FinancialTransactionsQuery.insert_financial_transaction_deposit()

      do
        AccountsResolver.revoke(args, ctx)
        StatusResponse.get_status_response_by_key(:OK)
      else
        {:validation_error, msg} ->
          AccountsResolver.revoke(args, ctx)
          StatusResponse.format_output(:UNPROCESSABLE_ENTITY, msg)
        {:error, msg} ->
          AccountsResolver.revoke(args, ctx)
          {:error, msg}
      end

    end)

  end
  def transfer(_args, _info), do:  {:error, "Não autorizado."}

  def withdrawal(args, ctx = %{context: %{current_user: current_user, token: _token, autho_token: _autho_token}}) do
    discount = fn(x) -> D.cast((x * -1)) end
    add = fn(map, key, value) -> Map.put(map, key, value) end
    edit_value = fn(map,value) -> %{ map | value: value } end

    v_balance = FinancialTransactionsQuery.get_balance(current_user.acc_agency, current_user.acc_account)

    Repo.transaction(fn ->
      with {:ok, value_to_deposit} <- args.value |> FinancialUtils.value_greater_than_zero?(),
           {:ok, _} <- v_balance |> FinancialUtils.have_balance?(value_to_deposit),
           {:ok, _} <- args
                       |> add.(:description, "Retirada")
                       |> add.(:account, current_user.acc_account)
                       |> add.(:agency, current_user.acc_agency)
                       |> add.(:bank_code, current_user.acc_bank_code)
                       |> edit_value.(discount.(args.value))
                       |> rename_keys()
                       |> FinancialTransactionsQuery.insert_financial_transaction_deposit()

        do
        AccountsResolver.revoke(args, ctx)
        StatusResponse.format_output(:OK, "Saque realizado com sucesso. Um e-mail foi enviado para #{current_user.acc_email}")
      else
        {:validation_error, msg} ->
          AccountsResolver.revoke(args, ctx)
          StatusResponse.format_output(:UNPROCESSABLE_ENTITY, msg)
        {:error, msg} ->
          AccountsResolver.revoke(args, ctx)
          {:error, msg}
      end

    end)

  end

  def withdrawal(_args, _info), do:  {:error, "Não autorizado."}

  def deposit(args) do
    args
    |> rename_keys()
    |> FinancialTransactionsQuery.insert_financial_transaction_deposit()
  end

  # TODO - Função para adicionar o prefixo no nome das colunas
  defp rename_keys(map), do: for {key, val} <- map, into: %{}, do: {Utils.add_prefix_on_atom(key, "fint_"), val}

end

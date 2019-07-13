defmodule ApiBnK.Financial.FinancialTransactionsResolver do
  @moduledoc """
  Módulo para gerenciar as funções que implementam as regras
  de negócio.
  """

  alias ApiBnK.Accounts.AccountsResolver
  alias ApiBnK.Financial.{FinancialTransactionsQuery, Functions.FinancialUtils}
  alias ApiBnK.Repo
  alias ApiBnK.Utils.{StatusResponse, Utils}
  alias Decimal, as: D

  @type account :: %{account: String.t(), agency: String.t(), bank_code: String.t()}
  @type account_logged :: %{context: %{current_user: map()}}
  @type account_logged_with_autho_token :: %{context: %{current_user: map(), token: String.t, autho_token: String.t}}

  @doc """
  Função que retorna o relatório back office sumarizado por dia (atual), mês (atual) e ano (atual)
  """
  @spec report_back_office(none(), none()) :: {atom, %{total_day: Decimal.t(), total_month: Decimal.t() , total_year: Decimal.t()}}
  def report_back_office(_args, _info) do
    add = fn(map, key, value) -> Map.put(map, key, value) end
    date_time_now = NaiveDateTime.add(NaiveDateTime.utc_now(), -(3600 * 3), :second)
    start_date_time_today = %DateTime{year: date_time_now.year, month: date_time_now.month, day: date_time_now.day,
                              zone_abbr: "BRT", hour: 00, minute: 0, second: 0, microsecond: {0, 0}, utc_offset: -(3600 * 3),
                              std_offset: 0, time_zone: "Brasilia Time"}

    end_date_time_today =
      start_date_time_today
      |> (&(%{ &1 | hour: 23})).()
      |> (&(%{ &1 | minute: 59})).()
      |> (&(%{ &1 | second: 59})).()
      |> DateTime.to_naive()

    start_date_time_month =
      start_date_time_today
      |> (&(%{ &1 | day: 1})).()
      |> DateTime.to_naive()

    end_date_time_month =
      start_date_time_today
      |> (&(%{ &1 | day: Date.days_in_month(&1)})).()
      |> (&(%{ &1 | hour: 23})).()
      |> (&(%{ &1 | minute: 59})).()
      |> (&(%{ &1 | second: 59})).()
      |> DateTime.to_naive()

    start_date_time_year =
      start_date_time_today
      |> (&(%{ &1 | day: 1})).()
      |> (&(%{ &1 | month: 1})).()
      |> DateTime.to_naive()

    end_date_time_year =
      start_date_time_today
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

  @doc """
  Função que retorna o saldo atual da conta logada
  """
  @spec balance(none(), account_logged) :: Decimal.t
  def balance(_args, %{context: %{current_user: current_user}}) do
    balance = FinancialTransactionsQuery.get_balance(current_user.acc_agency, current_user.acc_account)
    {:ok, balance}
  end

  @doc false
  def balance(_args, _info) do
    {:error, "Área restrita"}
  end

  # Verifica se a conta de origem é diferente da conta de destino
  defp origin_acc_diff_destiny_acc?(destination_acc, origin_acc) do
    trim = fn(val) -> String.trim(val) end

    dest_acc =
      destination_acc
      |> (&({trim.(&1.account), trim.(&1.agency), trim.(&1.bank_code)})).()

    orin_acc =
      origin_acc
      |> (&({trim.(&1.acc_account), trim.(&1.acc_agency), trim.(&1.acc_bank_code)})).()

    if dest_acc != orin_acc do
      {:ok, :true}
    else
      {:validation_error, "A conta de destino é a mesma de origem."}
    end

  end

  @doc """
  Função que efetua a transferência entre contas. Para essa ação, é necessário possuir o
  token de autenticação e autorização. Após a operação ser executada, o token de autorização é
  consumido; portanto, será necessário solicitar um novo token.
  """
  @spec transfer(account, account_logged_with_autho_token) :: {atom, String.t}
  def transfer(args, %{context: %{current_user: current_user, token: _token, autho_token: _autho_token}} = ctx) do
    discount = fn(x) -> D.cast((x * -1)) end
    add = fn(map, key, value) -> Map.put(map, key, value) end

    v_balance = FinancialTransactionsQuery.get_balance(current_user.acc_agency, current_user.acc_account)

    Repo.transaction(fn ->
      with {:ok, value_to_deposit} <- FinancialUtils.value_greater_than_zero?(args.value),
           {:ok, _} <- FinancialUtils.have_balance?(v_balance, value_to_deposit),
           {:ok, _} <- origin_acc_diff_destiny_acc?(args, current_user),
           {:ok, _} <- args
                       |> add.(:description, "Transferência recebida")
                       |> add.(:value, D.cast(args.value))
                       |> rename_keys()
                       |> FinancialTransactionsQuery.insert_financial_transaction_deposit(),
           {:ok, _} <- %{}
                       |> add.(:account, current_user.acc_account)
                       |> add.(:agency, current_user.acc_agency)
                       |> add.(:bank_code, current_user.acc_bank_code)
                       |> add.(:description, "Transferência enviada")
                       |> add.(:value, discount.(args.value))
                       |> rename_keys()
                       |> FinancialTransactionsQuery.insert_financial_transaction_deposit() do
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
  @spec transfer(none(), none()) :: {atom, String.t}
  def transfer(_args, _info) do
    {:error, "Não autorizado."}
  end

  @doc """
  Função que efetua o saque.
  Para essa ação, é necessário possuir o  token de autenticação e autorização.
  Após a operação ser executada, o token de autorização é consumido; portanto,
  será necessário solicitar um novo token.
  """
  @spec withdrawal(account, account_logged_with_autho_token) :: {atom, String.t}
  def withdrawal(args, %{context: %{current_user: current_user, token: _token, autho_token: _autho_token}} = ctx) do
    discount = fn(x) -> D.cast((x * -1)) end
    add = fn(map, key, value) -> Map.put(map, key, value) end
    edit_value = fn(map, value) -> %{map | value: value} end

    v_balance = FinancialTransactionsQuery.get_balance(current_user.acc_agency, current_user.acc_account)

    Repo.transaction(fn ->
      with {:ok, value_to_deposit} <- FinancialUtils.value_greater_than_zero?(args.value),
           {:ok, _} <- FinancialUtils.have_balance?(v_balance, value_to_deposit),
           {:ok, _} <- args
                       |> add.(:description, "Retirada")
                       |> add.(:account, current_user.acc_account)
                       |> add.(:agency, current_user.acc_agency)
                       |> add.(:bank_code, current_user.acc_bank_code)
                       |> edit_value.(discount.(args.value))
                       |> rename_keys()
                       |> FinancialTransactionsQuery.insert_financial_transaction_deposit() do
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
  @spec withdrawal(none(), none()) :: {atom, String.t}
  def withdrawal(_args, _info) do
    {:error, "Não autorizado."}
  end

  @doc false
  def deposit(args) do
    args
    |> rename_keys()
    |> FinancialTransactionsQuery.insert_financial_transaction_deposit()
  end

  # Função para adicionar o prefixo no nome das colunas
  @doc false
  defp rename_keys(map) do
    for {key, val} <- map, into: %{}, do: {Utils.add_prefix_on_atom(key, "fint_"), val}
  end

end

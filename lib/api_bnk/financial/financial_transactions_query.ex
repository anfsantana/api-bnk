defmodule ApiBnK.Financial.FinancialTransactionsQuery do
  @moduledoc """
  Módulo que efetua operações diretamente com banco
  """

  import Ecto.Query, warn: false

  alias ApiBnK.Repo
  alias ApiBnK.Financial.FinancialTransactions, as: FinancialTransaction
  alias Decimal, as: D

  def get_financial_transaction!(id), do: Repo.get!(FinancialTransaction, id)

  def get_financial_transactions_by_agency_account(agency, account), do: Repo.all(from(t in FinancialTransaction, where: t.fint_agency == ^agency and t.fint_account == ^account))

  def get_balance(agency, account) do
    Repo.aggregate(from(t in FinancialTransaction, where: t.fint_agency == ^agency and t.fint_account == ^account), :sum, :fint_value)
    |> case do
        nil -> D.new(0.00)
        result -> result
    end

  end

  def get_report_back_office(init_date, final_date) do
    _query = from(t in FinancialTransaction, where:  t.inserted_at >= ^init_date and t.inserted_at <= ^final_date)
    |> Repo.aggregate(:sum, :fint_value)
    |> case do
        nil -> D.new(0.00)
        result -> result
    end
  end

  def insert_financial_transaction_deposit(attrs \\ %{}) do
      %FinancialTransaction{}
      |> FinancialTransaction.changeset(attrs)
      |> Repo.insert()

  end

end

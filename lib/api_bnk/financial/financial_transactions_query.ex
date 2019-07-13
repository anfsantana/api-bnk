defmodule ApiBnK.Financial.FinancialTransactionsQuery do
  @moduledoc """
  Módulo que contêm funções que efetuam operações diretamente
  com o banco de dados
  """

  import Ecto.Query, warn: false

  alias ApiBnK.Financial.FinancialTransactions, as: FinancialTransaction
  alias ApiBnK.Repo
  alias Decimal, as: D

  @doc false
  def get_financial_transaction!(id), do: Repo.get!(FinancialTransaction, id)

  @doc false
  def get_financial_transactions_by_agency_account(agency, account), do: Repo.all(from(t in FinancialTransaction, where: t.fint_agency == ^agency and t.fint_account == ^account))

  @doc false
  def get_balance(agency, account) do
    _query = from(t in FinancialTransaction, where: t.fint_agency == ^agency and t.fint_account == ^account)
    |> Repo.aggregate(:sum, :fint_value)
    |> case do
        nil -> D.cast(0.00)
        result -> result
    end

  end

  @doc false
  def get_report_back_office(init_date, final_date) do
    _query = from(t in FinancialTransaction, where:  t.inserted_at >= ^init_date and t.inserted_at <= ^final_date)
    |> Repo.aggregate(:sum, :fint_value)
    |> case do
        nil -> D.cast(0.00)
        result -> result
    end
  end

  @doc false
  def insert_financial_transaction_deposit(attrs \\ %{}) do
      %FinancialTransaction{}
      |> FinancialTransaction.changeset(attrs)
      |> Repo.insert()

  end

end

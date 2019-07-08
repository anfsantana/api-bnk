defmodule ApiBnK.Financial.FinancialTransactionsQuery do
  @moduledoc """
  The boundary for the Accounts system.
  """

  import Ecto.Query, warn: false
  alias ApiBnK.Repo
  alias ApiBnK.Financial.FinancialTransactions, as: FinancialTransaction

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(FinancialTransaction)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_financial_transaction!(id), do: Repo.get!(FinancialTransaction, id)

  def get_financial_transactions_by_agency_account(agency, account), do: Repo.all(from(t in FinancialTransaction, where: t.fint_agency == ^agency and t.fint_account == ^account))

  def get_balance(agency, account), do: Repo.aggregate(from(t in FinancialTransaction, where: t.fint_agency == ^agency and t.fint_account == ^account), :sum, :fint_value)

  def get_report_back_office(init_date, final_date) do
    Repo.aggregate(from(t in FinancialTransaction, where:  t.inserted_at >= ^init_date and t.inserted_at <= ^final_date), :sum, :fint_value)
  end
  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def insert_financial_transaction_deposit(attrs \\ %{}) do
      %FinancialTransaction{}
      |> FinancialTransaction.changeset(attrs)
      |> Repo.insert()

  end

end

defmodule BlogAppGql.AccountsQuery do
  @moduledoc """
  The boundary for the Accounts system.
  """

  import Ecto.Query, warn: false
  alias BlogAppGql.Repo

  alias BlogAppGql.Accounts, as: Account

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(Account)
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
  def get_account!(id), do: Repo.get!(Account, id)

  def get_account_by_agency_account(agency, account), do: Repo.one(from(a in Account, where: a.acc_agency == ^agency and a.acc_account == ^account))

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = acc, attrs) do
    acc
    |> Account.changeset_simple_update(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%Account{} = acc) do
    Repo.delete(acc)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%Account{} = acc) do
    Account.changeset(acc, %{})
  end

  def store_token(%Account{} = acc, token) do
    acc
    |> Account.store_token_changeset(%{acc_token: token})
    |> Repo.update()
  end

  def revoke_token(%Account{} = acc, token) do
    acc
    |> Account.store_token_changeset(%{acc_token: token})
    |> Repo.update()
  end
end

defmodule ApiBnK.Accounts.AccountsQuery do
  @moduledoc """
  Módulo que efetua operações diretamente com o banco de dados
  """

  import Ecto.Query, warn: false

  alias ApiBnK.Repo
  alias ApiBnK.Accounts.Accounts, as: Account

  @doc """
  Função que obtém uma única conta.

  Devolve `Ecto.NoResultsError` se a conta não existir.

  ## Exemplos

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)

  @doc false
  def get_account_by_agency_account(agency, account), do: Repo.one(from(a in Account, where: a.acc_agency == ^agency and a.acc_account == ^account))

  @doc """
  Função que cria uma conta

  ## Exemplos

      iex> create_account(%{field: value})
      {:ok, %User{}}

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Função que atualiza uma conta

  ## Exemplos

      iex> update_account(acc, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(acc, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = acc, attrs) do
    acc
    |> Account.changeset_simple_update(attrs)
    |> Repo.update()
  end

  @doc """
  Função que armazena o token de autenticação na conta

  ## Exemplos

      iex> store_token(acc, token)
      {:ok, %Account{}}

  """
  def store_token(%Account{} = acc, token) do
    acc
    |> Account.store_token_changeset(%{acc_token: token})
    |> Repo.update()
  end


  @doc """
  Remove todos os tokens (autenticação e autorização) associados da conta

  ## Exemplos

      iex> revoke_all_token(acc, token, autho_token)
      {:ok, %Account{}}

  """
  def revoke_all_token(%Account{} = acc, token, autho_token) do
    acc
    |> Account.store_all_token_changeset(%{acc_token: token, acc_autho_token: autho_token})
    |> Repo.update()
  end

  @doc """
  Armazena o token de autorização na conta

  ## Exemplos

      iex> store_autho_token(acc, autho_token)
      {:ok, %Account{}}

  """
  def store_autho_token(%Account{} = acc, token) do
    acc
    |> Account.store_autho_token_changeset(%{acc_autho_token: token})
    |> Repo.update()
  end

  @doc """
  Remove o token de autenticação associado da conta

  ## Exemplos

      iex> revoke_autho_token(acc, token)
      {:ok, %Account{}}

  """
  def revoke_autho_token(%Account{} = acc, token) do
    acc
    |> Account.store_autho_token_changeset(%{acc_autho_token: token})
    |> Repo.update()
  end
end

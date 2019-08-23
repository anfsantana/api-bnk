defmodule ApiBnK.Service.Accounts.Accounts do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__, as: Account

  schema "accounts" do
    field(:acc_name, :string)
    field(:acc_agency, :string)
    field(:acc_account, :string)
    field(:acc_bank_code, :string)
    field(:acc_cpf, :string)
    field(:acc_email, :string)
    field(:acc_password, :string, virtual: true)
    field(:acc_password_hash, :string)
    field(:acc_token, :string)
    field(:acc_autho_token, :string)

    timestamps()
  end

  @doc false
  def changeset(%Account{} = acc, attrs) do
    acc
    |> cast(attrs, [:acc_name, :acc_agency, :acc_account, :acc_bank_code, :acc_cpf, :acc_password, :acc_email])
    |> validate_required([:acc_name, :acc_agency, :acc_account, :acc_bank_code, :acc_cpf, :acc_password, :acc_email])
    |> validate_length(:acc_name, min: 3, max: 60, message: "O nome do titular da conta, deve ter de 3 até 60 caracteres")
    |> validate_length(:acc_password, min: 5, max: 20, message: "A senha deve ter no mínimo de 5 até 20 caracteres")
    |> validate_format(:acc_email, ~r/@/, message: "O formato de e-mail é inválido.")
    |> unique_constraint(:acc_email, downcase: true, name: :idx_unique_accounts_email, message: "O e-mail informado já está sendo utilizado.")
    |> unique_constraint(:acc_cpf, name: :idx_unique_accounts_cpf, message: "O CPF informado já está sendo utilizado.")
    |> unique_constraint(:acc_account, name: :idx_unique_bankcode_accounts_agency_account, message: "Conta, Agência e Código do banco, já estão sendo utilizado.")
    |> put_password_hash()
  end

  @doc false
  def store_token_changeset(%Account{} = acc, attrs) do
    acc
    |> cast(attrs, [:acc_token])
  end

  @doc false
  def store_autho_token_changeset(%Account{} = acc, attrs) do
    acc
    |> cast(attrs, [:acc_autho_token])
  end

  @doc false
  def store_all_token_changeset(%Account{} = acc, attrs) do
    acc
    |> cast(attrs, [:acc_token, :acc_autho_token])
  end

  @doc false
  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{acc_password: pass}} ->
        put_change(changeset, :acc_password_hash, Comeonin.Bcrypt.hashpwsalt(pass))

      _ ->
        changeset
    end
  end
end

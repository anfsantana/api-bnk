defmodule ApiBnK.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :acc_name, :string, null: false, comment: "Nome do titular"
      add :acc_agency, :string, null: false, comment: "Agência"
      add :acc_account, :string, null: false, comment: "Conta"
      add :acc_bank_code, :string, null: false, comment: "Código do banco"
      add :acc_cpf, :string, null: false, comment: "CPF do titular"
      add :acc_email, :string, null: false, comment: "E-mail do titular"
      add :acc_password_hash, :string, comment: "Senha"
      add :acc_token, :text, comment: "Token de autenticação"
      timestamps()
    end
    create unique_index(:accounts, [:acc_cpf], name: :idx_unique_accounts_cpf)
    create unique_index(:accounts, [:acc_email], name: :idx_unique_accounts_email)
    create unique_index(:accounts, [:acc_bank_code, :acc_agency, :acc_account], name: :idx_unique_bankcode_accounts_agency_account)
  end
end

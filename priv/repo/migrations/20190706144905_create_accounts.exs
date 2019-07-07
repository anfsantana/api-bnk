defmodule BlogAppGql.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :acc_name, :string, null: false
      add :acc_agency, :string, null: false
      add :acc_account, :string, null: false
      add :acc_bank_code, :string, null: false
      add :acc_cpf, :string, null: false
      add :acc_email, :string
      add :acc_password_hash, :string
      add :acc_token, :text
      timestamps()
    end
    create unique_index(:accounts, [:acc_cpf], name: :idx_unique_accounts_cpf)
    create unique_index(:accounts, [:acc_email], name: :idx_unique_accounts_email)
    create unique_index(:accounts, [:acc_bank_code, :acc_agency, :acc_account], name: :idx_unique_bankcode_accounts_agency_account)
  end
end

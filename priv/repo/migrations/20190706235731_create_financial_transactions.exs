defmodule ApiBnK.Repo.Migrations.CreateFinancialTransactions do
  use Ecto.Migration

  def change do
      create table(:financial_transactions) do
        add :fint_agency, :string, null: false, comment: "Agência"
        add :fint_account, :string, null: false, comment: "Conta"
        add :fint_bank_code, :string, null: false, comment: "Código do banco"
        add :fint_description, :string, comment: "Descrição da transação"
        add :fint_value, :decimal, default: 0.00, null: false, comment: "Valor"

        timestamps()
      end

  end
end

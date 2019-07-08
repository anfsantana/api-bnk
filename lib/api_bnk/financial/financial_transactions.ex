defmodule ApiBnK.Financial.FinancialTransactions do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__, as: FinancialTransaction

  schema "financial_transactions" do
    field(:fint_agency, :string)
    field(:fint_account, :string)
    field(:fint_bank_code, :string)
    field(:fint_description, :string)
    field(:fint_value, :decimal)

    timestamps()
  end

  @doc false
  def changeset(%FinancialTransaction{} = financial_transaction, attrs) do
    financial_transaction
    |> cast(attrs, [:fint_agency, :fint_account, :fint_bank_code, :fint_description, :fint_value])
    |> validate_required([:fint_agency, :fint_account, :fint_bank_code, :fint_description, :fint_value])
  end

end

defmodule ApiBnK.Web.Schema.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: ApiBnK.Repo

  object :session do
    field(:token, :string)
  end

  # TODO Novos - Contas

  object :accounts do
    field(:acc_name, :string)
    field(:acc_agency, :string)
    field(:acc_account, :string)
    field(:acc_bank_code, :string)
    field(:acc_cpf, :string)
    field(:acc_email, :string)
  end

  input_object :create_account_params do
    field(:name, :string)
    field(:email, :string)
  end

  # TODO Transação

  input_object :account_destination do
    field(:name, :string)
    field(:email, :string)
  end

  # TODO Mensagem

  object :status_response do
    field(:code, :integer)
    field(:message, :string)
  end

end

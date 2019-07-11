defmodule ApiBnK.Web.Schema.Types do
  @moduledoc """
  Módulo que contêm os tipos utilizados nos mutations e/ou queries GraphQL
  """

  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: ApiBnK.Repo

  @desc "Sessão autorizada"
  object :autho_session do
    field(:token, :string, description: "Token de autorização")
  end

  @desc "Sessão autenticada"
  object :authe_session do
    field(:token, :string, description: "Token de autenticação")
  end

  @desc "Conta"
  object :accounts do
    field(:acc_name, :string, description: "Nome do titular da conta")
    field(:acc_agency, :string, description: "Agência")
    field(:acc_account, :string, description: "Conta")
    field(:acc_bank_code, :string, description: "Código do banco")
    field(:acc_cpf, :string, description: "CPF do titular da conta")
    field(:acc_email, :string, description: "E-mail do titular da conta")
  end

  @desc "Relatório back office"
  object :report_back_office do
    field(:total_day, :float, description: "Total transacionado no dia.")
    field(:total_month, :float, description: "Total transacionado no mês.")
    field(:total_year, :float, description: "Total transacionado no ano.")
  end

  @desc "Resposta"
  object :status_response do
    field(:code, :integer, description: "Código de retorno")
    field(:message, :string, description: "Mensagem de retorno")
  end

end

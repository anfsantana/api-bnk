defmodule ApiBnK.Web.Schema do
  use Absinthe.Schema

  import_types ApiBnK.Web.Schema.Types
  import_types Absinthe.Type.Custom

  alias ApiBnK.Accounts.AccountsResolver
  alias ApiBnK.Financial.FinancialTransactionsResolver


  query do

    @desc """
    Query para obter o saldo da conta logada. É necessário possuir o
    token de autenticação
    """
    field(:balance, type: :float)  do
      resolve(&FinancialTransactionsResolver.balance/2)
    end

    field(:login, type: :authe_session, description: "Query para efetuar o login.") do
      arg(:agency, non_null(:string), description: "Agência")
      arg(:account, non_null(:string), description: "Conta")
      arg(:password, non_null(:string), description: "Senha")

      resolve(&AccountsResolver.login/2)
    end

    @desc """
    Query para obter o token de autorização para efetuar cada transação
    """
    field(:authorization, type: :autho_session) do
      arg(:password, non_null(:string), description: "Senha da conta logada.")
      resolve(&AccountsResolver.authorization/2)

    end

    @desc """
    Query para emitir relatório de back office.
    """
    field(:report_back_office, type: :report_back_office) do
      resolve(&FinancialTransactionsResolver.report_back_office/2)

    end

  end

  mutation do

      field(:create_account, type: :status_response, description: "Mutation para criar a conta") do
        arg(:name, non_null(:string), description: "Nome do titular da conta")
        arg(:email, non_null(:string), description: "E-mail do titular da conta")
        arg(:agency, non_null(:string), description: "Agência")
        arg(:account, non_null(:string), description: "Conta")
        arg(:bank_code, non_null(:string), description: "Código do banco")
        arg(:cpf, non_null(:string), description: "CPF do titular da conta ")
        arg(:password, non_null(:string), description: "Senha")

        resolve(&AccountsResolver.create/2)
      end

      @desc """
      Mutation para atualizar a conta. É necessário possuir o token de autenticação.
      """
      field(:update_account, type: :accounts) do
        arg(:name, non_null(:string), description: "Nome do titular da conta")
        arg(:email, non_null(:string), description: "E-mail do titular da conta")

        resolve(&AccountsResolver.update/2)

      end

      field(:logout, type: :status_response, description: "Mutation para efetuar logout") do
        resolve(&AccountsResolver.logout/2)
      end

      @desc """
      Mutation para efetuar transferência. É necessário possuir o token de autenticação e autorização.
      Para cada operação de transferência, é necessário gerar um novo token de autorização.
      """
      field(:transferency, type: :status_response) do
        arg(:agency, non_null(:string), description: "Agência da conta de destino")
        arg(:account, non_null(:string), description: "Conta de destino")
        arg(:bank_code, non_null(:string), description: "Código do banco da conta de destino")
        arg(:value, non_null(:float), description: "Valor para transferência")

        resolve(&FinancialTransactionsResolver.transfer/2)

      end

      @desc """
      Mutation para efetuar saque. É necessário possuir o token de autenticação e autorização.
      Para cada operação de saque, é necessário gerar um novo token de autorização.
      """
      field(:withdrawal, type: :status_response) do
        arg(:value, non_null(:float), description: "Valor para sacar")
        resolve(&FinancialTransactionsResolver.withdrawal/2)

      end



  end

end

defmodule ApiBnK.Web.Schema do
  use Absinthe.Schema

  import_types ApiBnK.Web.Schema.Types


  query do

    field :balance, type: :float do
      resolve(&ApiBnK.Financial.FinancialTransactionsResolver.balance/2)
    end

    field :login, type: :session do
      arg(:agency, non_null(:string))
      arg(:account, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&ApiBnK.Accounts.AccountsResolver.login/2)
    end

  end

  mutation do

      field :create_account, type: :status_response do
        arg(:name, non_null(:string))
        arg(:email, :string)
        arg(:agency, non_null(:string))
        arg(:account, non_null(:string))
        arg(:bank_code, non_null(:string))
        arg(:cpf, non_null(:string))
        arg(:password, non_null(:string))

        resolve(&ApiBnK.Accounts.AccountsResolver.create/2)
      end

      field :update_account, type: :accounts do
        arg(:name, :string)
        arg(:email, :string)

        resolve(&ApiBnK.Accounts.AccountsResolver.update/2)
      end

      field :logout, type: :status_response do
        resolve(&ApiBnK.Accounts.AccountsResolver.logout/2)
      end

      field :transferency, type: :status_response do
        arg(:agency, non_null(:string))
        arg(:account, non_null(:string))
        arg(:bank_code, non_null(:string))
        arg(:value, non_null(:float))

        resolve(&ApiBnK.Financial.FinancialTransactionsResolver.transfer/2)
      end
#      field :update_post, type: :blog_post do
#        arg(:id, non_null(:id))
#        arg(:post, :update_post_params)
#
#        resolve(&ApiBnK.Blog.PostResolver.update/2)
#      end


  end

end

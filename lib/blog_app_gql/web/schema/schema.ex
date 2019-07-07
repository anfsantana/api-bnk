defmodule BlogAppGql.Web.Schema do
  use Absinthe.Schema

  import_types BlogAppGql.Web.Schema.Types


  query do

    field :blog_posts, type: list_of(:blog_post) do
      resolve(&BlogAppGql.Blog.PostResolver.all/2)
    end

    field :balance, type: :float do
      resolve(&BlogAppGql.Financial.FinancialTransactionsResolver.balance/2)
    end

#    field :accounts_users, type: list_of(:accounts_user) do
#      resolve(&BlogAppGql.Accounts.UserResolver.all/2)
#    end
#
#    field :accounts_user, type: :accounts_user do
#      arg(:email, non_null(:string))
#      resolve(&BlogAppGql.Accounts.UserResolver.find/2)
#    end

    # TODO modificado
    field :login, type: :session do
      arg(:agency, non_null(:string))
      arg(:account, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&BlogAppGql.Accounts.AccountsResolver.login/2)
    end

  end

  mutation do

#      field :create_post, type: :blog_post do
#        arg(:title, non_null(:string))
#        arg(:body, non_null(:string))
#        arg(:accounts_user_id, non_null(:id))
#
#        resolve(&BlogAppGql.Blog.PostResolver.create/2)
#      end

#      field :create_user, type: :accounts_user do
#	      arg(:name, non_null(:string))
#	      arg(:email, non_null(:string))
#	      arg(:password, non_null(:string))
#
#	      resolve(&BlogAppGql.Accounts.UserResolver.create/2)
#      end

      # TODO Novo
      field :create_account, type: :accounts do
        arg(:name, non_null(:string))
        arg(:email, :string)
        arg(:agency, non_null(:string))
        arg(:account, non_null(:string))
        arg(:bank_code, non_null(:string))
        arg(:cpf, non_null(:string))
        arg(:password, non_null(:string))

        resolve(&BlogAppGql.Accounts.AccountsResolver.create/2)
      end


      # TODO - Fazer o update de conta
      field :update_account, type: :accounts do
        arg(:agency, non_null(:string))
        arg(:account, non_null(:string))
        arg(:account_params, :create_account_params)

        resolve(&BlogAppGql.Accounts.AccountsResolver.update/2)
      end

      # TODO Transações

      field :transferency, type: :status_response do
        arg(:agency, non_null(:string))
        arg(:account, non_null(:string))
        arg(:bank_code, non_null(:string))
        arg(:value, non_null(:float))

        resolve(&BlogAppGql.Financial.FinancialTransactionsResolver.transfer/2)
      end
#      field :update_post, type: :blog_post do
#        arg(:id, non_null(:id))
#        arg(:post, :update_post_params)
#
#        resolve(&BlogAppGql.Blog.PostResolver.update/2)
#      end
#
#      field :delete_post, type: :blog_post do
#        arg(:id, non_null(:id))
#        resolve(&BlogAppGql.Blog.PostResolver.delete/2)
#      end
#
#      field :sign_out, type: :accounts_user do
#	      arg(:id, non_null(:id))
#	      resolve(&BlogAppGql.Accounts.UserResolver.logout/2)
#      end

  end

end

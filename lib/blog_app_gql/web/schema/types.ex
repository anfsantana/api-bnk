defmodule BlogAppGql.Web.Schema.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: BlogAppGql.Repo

  object :accounts_user do
    field(:id, :id)
    field(:name, :string)
    field(:email, :string)
    field(:posts, list_of(:blog_post), resolve: assoc(:blog_posts))
  end

  object :blog_post do
    field(:id, :id)
    field(:title, :string)
    field(:body, :string)
    field(:user, :accounts_user, resolve: assoc(:accounts_user))
  end

  object :session do
    field(:token, :string)
  end

  input_object :update_post_params do
    field(:title, :string)
    field(:body, :string)
    field(:accounts_user_id, :id)
  end

  # TODO Novos - Contas

  object :accounts do
    field(:name, :string)
    field(:agency, :string)
    field(:account, :string)
    field(:bank_code, :string)
    field(:cpf, :string)
    field(:email, :string)
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

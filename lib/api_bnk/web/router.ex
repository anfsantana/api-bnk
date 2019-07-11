defmodule ApiBnK.Web.Router do
  @moduledoc false

  use ApiBnK.Web, :router

  pipeline :graphql do
	  plug ApiBnK.Context
  end

  scope "/api" do
    pipe_through(:graphql)

    forward("/", Absinthe.Plug, schema: ApiBnK.Web.Schema)
    forward("/graphiql", Absinthe.Plug.GraphiQL, schema: ApiBnK.Web.Schema)
  end
end

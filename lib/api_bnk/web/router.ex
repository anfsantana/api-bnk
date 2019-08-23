defmodule ApiBnK.Web.Router do
  @moduledoc false

  use ApiBnK.Web, :router

  pipeline :graphql do
	  plug ApiBnK.Context
  end

  scope "/api/graphiql" do
    pipe_through(:graphql)
    forward("/", Absinthe.Plug.GraphiQL, schema: ApiBnK.Schema.Schema)
  end
end

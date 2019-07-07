defmodule ApiBnK.Context do
	@behaviour Plug

	import Plug.Conn
	import Ecto.Query, only: [where: 2]

	alias ApiBnK.Repo
	alias ApiBnK.Accounts.Accounts, as: Account

	def init(opts), do: opts

	def call(conn, _) do
		case build_context(conn) do
			{:ok, context} ->
				put_private(conn, :absinthe, %{context: context})
			_ ->
				conn
		end
	end

	defp build_context(conn) do
		with ["Bearer " <> token] <- get_req_header(conn, "authentication"),
		     {:ok, current_user} <- authenticate(token) do
			{:ok, %{current_user: current_user, token: token}}
		end
	end

#	defp build_context(conn) do
#		case get_req_header(conn, "authorization")
#		with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
#				 ["Bearer " <> authen_token] <- get_req_header(conn, "authentication"),
#		     {:ok, current_user} <- authentication(token, authen_token) do
#			{:ok, %{current_user: current_user, token: token, authen_token: authen_token}}
#			else
#				with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
#						 {:ok, current_user} <- authentication(token, authen_token) do
#					end
#		end
#	end

	defp authenticate(token) do
		Account
    |> where(acc_token: ^token)
    |> Repo.one()
		|> case do
	      nil -> {:error, "Invalid authentication token"}
				user -> {:ok, user}
		   end
	end

#	defp authentication(token, authen_token) do
#		Account
#		|> where(acc_token: ^token, acc_authen_token: ^authen_token)
#		|> Repo.one()
#		|> case do
#				 nil -> {:error, "Invalid authorization token"}
#				 user -> {:ok, user}
#			 end
#	end
end
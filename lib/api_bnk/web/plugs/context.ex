defmodule ApiBnK.Context do
	@moduledoc false

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

	defp is_authenticated(header_authentication) do
		with ["Bearer " <> authe_token] <- header_authentication,
		 {:ok, current_user} <- authenticate(authe_token)
			do
		 		{:ok, %{current_user: current_user, token: authe_token}}
			else
				_ -> {:error, "Não autenticado"}
		end

	end

	defp is_authorized(header_authentication, header_authorization) do

		with {:ok, current_user} <- is_authenticated(header_authentication),
				 ["Bearer " <> autho_token] <- header_authorization,
				 {:ok, current_user} <- current_user.token |> authorization(autho_token)
			do
						{:ok, %{current_user: current_user, token: current_user.acc_token, autho_token: autho_token}}
			else
				_ -> {:error, "Não autorizado"}
	 end

	end

	defp build_context(conn) do
		header_authe = get_req_header(conn, "authentication")
		header_autho = get_req_header(conn, "authorization")

		case is_authorized(header_authe, header_autho) do
			{:ok, current_user} -> {:ok, current_user}
			{:error,_} ->
				case is_authenticated(header_authe) do
					{:ok, current_user} -> {:ok, current_user}
					{:error, message} -> {:error, message}
				end

		end

	end

	defp authenticate(token) do
		Account
    |> where(acc_token: ^token)
    |> Repo.one()
		|> case do
	      nil -> {:error, "Invalid authentication token"}
				user -> {:ok, user}
		   end
	end

	defp authorization(token, autho_token) do
		Account
		|> where(acc_token: ^token, acc_autho_token: ^autho_token)
		|> Repo.one()
		|> case do
				 nil -> {:error, "Invalid authorization token"}
				 user -> {:ok, user}
			 end
	end
end
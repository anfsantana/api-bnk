defmodule ApiBnK.AuthHelper do
  @moduledoc false

  import Comeonin.Bcrypt, only: [checkpw: 2]
  alias ApiBnK.Repo
  alias ApiBnK.Accounts.Accounts, as: Account

  def login_with_agency_account_pass(agency, account, given_pass) do
    acc = Repo.get_by(Account, acc_agency: agency, acc_account: account)

    cond do
      acc && checkpw(given_pass, acc.acc_password_hash) ->
        {:ok, acc}
      acc ->
        {:error, "Incorrect login credentials"}
      true ->
        {:error, :"Account not found"}
    end

  end

end

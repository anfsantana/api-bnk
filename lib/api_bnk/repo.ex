defmodule ApiBnK.Repo do
  @moduledoc false

  use Ecto.Repo, otp_app: :api_bnk

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    opts = opts
             |> Keyword.put(:username, System.get_env("PGUSER") || "postgres")
             |> Keyword.put(:password, System.get_env("PGPASSWORD") || "postgres")
             |> Keyword.put(:database, System.get_env("PGDATABASE") || "api_bnk_dev")
             |> Keyword.put(:hostname, System.get_env("PGHOST") || "localhost")
             |> Keyword.put(:port, System.get_env("PGPORT") || "5000")
             |> Keyword.put(:url, System.get_env("DATABASE_URL"))
    {:ok, opts}
  end
end

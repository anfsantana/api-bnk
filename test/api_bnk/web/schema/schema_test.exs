defmodule ApiBnK.SchemaTest do
  use ApiBnK.Support.ConnCase, async: true
  alias ApiBnK.Accounts.AccountsResolver

  describe "account" do

    @login_info %{agency: "0002", account: "456783", password: "123456789"}
    @account_info %{email: "ric@email.com", name: "João", cpf: "31671727460",
                    agency: "0002", account: "456783", password: "123456789",
                    bank_code: "005"}
    setup do

      {:ok, _} = AccountsResolver.create(@account_info, nil)
      {:ok, %{token: authe_token}} = AccountsResolver.login(@login_info, nil)
      conn = Phoenix.ConnTest.build_conn()
             |> Plug.Conn.put_req_header("content-type", "application/json")
             |> Plug.Conn.put_req_header("authentication", "Bearer #{authe_token}")

      {:ok, %{conn: conn}}
    end

    test "[Query] createAccount: sucesso na criação de conta. ", %{conn: conn} do
      mutation = """
          mutation {
            createAccount(
                account: "456785",
                agency: "0002",
                bankCode: "005",
                name: "João",
                password: "123456",
                cpf: "31671727467",
                email: "roselitest@email.com"
            ){
            code
            message
            }
          }
      """
      res =
        conn
        |> post("/api/graphiql", %{query: mutation})
        |> json_response(200)

      assert %{"data" => %{"createAccount" => %{"code" => 201, "message" => _}}} = res
    end

    test "[Mutation] updateAccount: sucesso na atualização de dados da conta.", %{conn: conn} do
        new_email = "silvajoao@email.com"

        mutation = """
        mutation {
          updateAccount(
              name: "João",
              email: "#{new_email}"
          ){
            accEmail
          }
        }
        """
        res =
          conn
          |> post("/api/graphiql", %{query: mutation})
          |> json_response(200)

        assert %{"data" => %{"updateAccount" => %{"accEmail" => new_email}}} = res
    end

    test "[Query] balance: sucesso na consulta de saldo da conta.", %{conn: conn} do
      query = """
      query {
        balance
      }
      """
      res =
        conn
        |> post("/api/graphiql", %{query: query})
        |> json_response(200)

      %{"data" => %{"balance" => value}} = res
      assert value == "1000"

    end
  end
#
#  describe "createUser" do
#    test "it creates a User with proper params", %{conn: conn} do
#      query = """
#      {
#        createUser(username: "duder", email: "dude@dude.dude" password: "dudedude", passwordConfirmation: "dudedude") {
#          id
#        }
#      }
#      """
#      res =
#        conn
#        |> post("/api", %{query: query})
#        |> json_response(200)
#
#      assert %{"data" => %{"createUser" => %{"id" => _}}} = res
#    end
#
#    test "it provides an error if validations fail", %{conn: conn} do
#      query = """
#      {
#        createUser(username: "dude", email: "bad", password: "dudedude", passwordConfirmation: "dudedude") {
#          id
#        }
#      }
#      """
#      res =
#        conn
#        |> post("/api", %{query: query})
#        |> json_response(200)
#
#      assert %{"errors" => [%{"message" => message}]} = res
#      assert message == "Failed: email has invalid format"
#    end
#  end
#
#  describe "user" do
#    setup do
#      [user: insert(:user, %{username: "dude"})]
#    end
#
#    test "gets a User by username", %{conn: conn, user: %{username: username}} do
#      query = """
#      {
#        user(username: "#{username}") {
#          username
#        }
#      }
#      """
#      res =
#        conn
#        |> post("/api", %{query: query})
#        |> json_response(200)
#
#      assert res == %{"data" => %{"user" => %{"username" => username}}}
#    end
#
#    test "returns nil if the User is not found", %{conn: conn, user: user} do
#      query = """
#      {
#        user(username: "not#{user.username}") {
#          username
#        }
#      }
#      """
#      res =
#        conn
#        |> post("/api", %{query: query})
#        |> json_response(200)
#
#      assert res == %{"data" => %{"user" => nil}}
#    end
#  end
#
#  describe "games" do
#    setup do
#      1..5 |> Enum.map(fn _ -> insert(:player) end)
#
#      :ok
#    end
#
#    test "gets a list of Games", %{conn: conn} do
#      query = """
#      { games { id } }
#      """
#      res =
#        conn
#        |> post("/api", %{query: query})
#        |> json_response(200)
#
#      %{"data" => %{"games" => games}} = res
#      assert length(games) == 5
#    end
#  end
#
#  describe "game" do
#    setup do
#      [game: insert(:game)]
#    end
#
#    test "gets a game by id", %{conn: conn, game: %{id: id}} do
#      query = """
#      {
#        game(id: #{id}) {
#          id
#        }
#      }
#      """
#      res =
#        conn
#        |> post("/api", %{query: query})
#        |> json_response(200)
#
#      assert res == %{"data" => %{"game" => %{"id" => "#{id}"}}}
#    end
#
#    test "returns nil if the Game is not found", %{conn: conn, game: %{id: id}} do
#      query = """
#      {
#        game(id: #{id}1) {
#          id
#        }
#      }
#      """
#      res =
#        conn
#        |> post("/api", %{query: query})
#        |> json_response(200)
#
#      assert res == %{"data" => %{"game" => nil}}
#    end
#  end
#
#  describe "createPlayer" do
#    setup do
#      user = insert(:user)
#      game = insert(:game)
#
#      [user: user, game: game]
#    end
#
#    test "creates a Player with valid params", %{conn: conn, user: %{id: user_id}, game: %{id: game_id}} do
#      query = """
#      {
#        createPlayer(userId: #{user_id}, gameId: #{game_id}, status: "user-pending") {
#          id
#        }
#      }
#      """
#      res =
#        conn
#        |> post("/api", %{query: query})
#        |> json_response(200)
#
#      assert %{"data" => %{"createPlayer" => %{"id" => _}}} = res
#    end
#
#    test "returns errors with invalid params", %{conn: conn, user: %{id: user_id}, game: %{id: game_id}} do
#      query = """
#      {
#        createPlayer(userId: #{user_id}1, gameId: #{game_id}, status: "user-pending") {
#          id
#        }
#      }
#      """
#
#      res =
#        conn
#        |> post("/api", %{query: query})
#        |> json_response(200)
#
#      assert %{"errors" => [%{"message" => message}]} = res
#      assert message == "Failed: user does not exist"
#    end
#  end
#
#  describe "player" do
#    setup do
#      [player: insert(:player)]
#    end
#
#    test "gets a Player by id", %{conn: conn, player: %{id: id}} do
#      query = """
#      {
#        player(id: #{id}) {
#          id
#        }
#      }
#      """
#
#      res =
#        conn
#        |> post("/api", %{query: query})
#        |> json_response(200)
#
#      assert res == %{"data" => %{"player" => %{"id" => "#{id}"}}}
#    end
#
#    test "returns nil if the Player is not found", %{conn: conn, player: %{id: id}} do
#      query = """
#      {
#        player(id: #{id}1) {
#          id
#        }
#      }
#      """
#      res =
#        conn
#        |> post("/api", %{query: query})
#        |> json_response(200)
#
#      assert res == %{"data" => %{"player" => nil}}
#    end
#  end
end
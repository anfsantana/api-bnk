defmodule ApiBnK.Schema.SchemaTest do
  @moduledoc """
  Módulo responsável por efetuar os testes das chamadas GraphQL no módulo Schema.
  """
  use ApiBnK.Support.ConnCase, async: true
  alias ApiBnK.Service.Accounts.AccountsResolver

  describe "account" do

    @login_info %{agency: "0002", account: "456783", password: "123456789", bank_code: "005"}
    @account_info %{email: "ric@email.com", name: "João",
                    cpf: "31671727460"}
    setup do

      with {:ok, _} <- AccountsResolver.create(Map.merge(@account_info, @login_info), nil),
      {:ok, %{token: authe_token}} = AccountsResolver.login(@login_info, nil) do
        conn = Phoenix.ConnTest.build_conn()
               |> Plug.Conn.put_req_header("content-type", "application/json")
               |> Plug.Conn.put_req_header("authentication", "Bearer #{authe_token}")

        {:ok, %{conn: conn}}
      else
        {:error, msg} -> {:error, msg}
      end
    end

    test "[Query GraphQL] login: sucesso em efetuar o login/obter o token de autenticação.", %{conn: conn} do
      query = """
        query {
            login(agency: "#{@login_info.agency}", account: "#{@login_info.account}", bankCode: "#{@login_info.bank_code}",
                            password: "#{@login_info.password}") {
            token
          }
        }
      """

      res =
        conn
        |> post("/api/graphiql", %{query: query})
        |> json_response(200)

      %{"data" => %{"login" => %{"token" => token}}} = res
      assert String.length(token) > 0

    end

    test "[Query GraphQL] authorization: sucesso em obter o token de autorização da conta logada.", %{conn: conn} do
      query = """
        query {
            authorization(password: "#{@login_info.password}") {
            token
          }
        }
      """

      res =
        conn
        |> post("/api/graphiql", %{query: query})
        |> json_response(200)

      %{"data" => %{"authorization" => %{"token" => token}}} = res
      assert String.length(token) > 0

    end

    test "[Query GraphQL] balance: sucesso na consulta de saldo da conta da conta logada.", %{conn: conn} do
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

    test "[Mutation GraphQL] createAccount: sucesso na criação de conta. ", %{conn: conn} do
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

    test "[Mutation GraphQL] logout: sucesso ao efetuar logout.", %{conn: conn} do
      mutation = """
        mutation {
          logout {
            code
            message
          }
      }
      """
      res =
        conn
        |> post("/api/graphiql", %{query: mutation})
        |> json_response(200)

      %{"data" => %{"logout" => %{"code" => code, "message" => _}}} = res
      assert code == 200

    end

  end

  describe "financial_transactions" do

    @login_info %{agency: "0002", account: "456784", password: "323245", bank_code: "005"}
    @login_info_authorization %{acc_agency: "0002", acc_account: "456784", acc_password: "323245", acc_bank_code: "005"}
    @account_origin_info %{email: "ric@email.com", name: "Ricardo", cpf: "31671727460"}

    @account_destination_info %{email: "jo@email.com", name: "João",
                                cpf: "41671727460", agency: "0002",
                                account: "456785", password: "123456789",
                                bank_code: "005"}

    setup do
      with {:ok, _} <- AccountsResolver.create(Map.merge(@account_origin_info, @login_info), nil),
      {:ok, _} <- AccountsResolver.create(@account_destination_info, nil),
      {:ok, %{token: authe_token}} <- AccountsResolver.login(@login_info, nil),
      {:ok, %{token: autho_token}} <- AccountsResolver.authorization(@login_info, %{context: %{current_user: @login_info_authorization}}) do
        conn = Phoenix.ConnTest.build_conn()
               |> Plug.Conn.put_req_header("content-type", "application/json")
               |> Plug.Conn.put_req_header("authentication", "Bearer #{authe_token}")
               |> Plug.Conn.put_req_header("authorization", "Bearer #{autho_token}")
          {:ok, %{conn: conn}}
      else
        {:error, msg} -> {:error, msg}
      end

    end

    test "[Mutation GraphQL] transferency: sucesso na transferência de valores. ", %{conn: conn} do
      interpolation = fn(map) -> ("""
          mutation {
            transferency(account: "#{map.account}",
                         agency: "#{map.agency}",
                         bankCode: "#{map.bank_code}", value: 500.55){
              message
              code
            }
          }
      """) end

      mutation_transferency = interpolation.(@account_destination_info)

      res =
        conn
        |> post("/api/graphiql", %{query: mutation_transferency})
        |> json_response(200)

        assert %{"data" => %{"transferency" => %{"code" => 200, "message" => _}}} = res
    end

    test "[Mutation GraphQL] withdrawal: sucesso no saque. ", %{conn: conn} do

      mutation = """
          mutation {
            withdrawal(value: 500){
              message
              code
            }
          }
      """

      res =
        conn
        |> post("/api/graphiql", %{query: mutation})
        |> json_response(200)

      assert %{"data" => %{"withdrawal" => %{"code" => 200, "message" => _}}} = res
    end

    test "[Query GraphQL] reportBackOffice: sucesso na consulta do relatório back office.", %{conn: conn} do
      query = """
      query {
        reportBackOffice {
          totalDay
          totalYear
          totalMonth
        }
      }
      """
      res =
        conn
        |> post("/api/graphiql", %{query: query})
        |> json_response(200)

      %{"data" =>
                %{"reportBackOffice" =>
                                      %{
                                        "totalYear" => total_year,
                                        "totalMonth" => total_month}}} = res
      # Duas contas foram criadas nos testes, portanto R$ 1000 de cada conta
      assert {"2000", "2000"} == {total_month, total_year}

    end

  end

end

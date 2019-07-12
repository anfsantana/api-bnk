#defmodule ApiBnK.AccountsTest do
#  use ApiBnK.DataCase
#
#  alias ApiBnK.Accounts.Accounts
#
#  describe "accounts" do
#    alias ApiBnK.Accounts.Account
#
#    @valid_attrs %{email: "some email", name: "some name", password: "some password", toke: "some token"}
#    @update_attrs %{email: "some updated email", name: "some updated name"}
#    @invalid_attrs %{email: nil, name: nil}
#
#    def account_fixture(attrs \\ %{}) do
#      {:ok, account} =
#        attrs
#        |> Enum.into(@valid_attrs)
#        |> Accounts.create_account()
#
#      account
#    end
#
#    test "list_accounts/0 returns all accounts" do
#      account = account_fixture()
#      assert Accounts.list_accounts() == [account]
#    end
#
#    test "get_account!/1 returns the account with given id" do
#      account = account_fixture()
#      assert Accounts.get_account!(account.id) == account
#    end
#
#    test "create_account/1 with valid data creates a account" do
#      assert {:ok, %Account{} = account} = Accounts.create_account(@valid_attrs)
#      assert account.email == "some email"
#      assert account.name == "some name"
#    end
#
#    test "create_account/1 with invalid data returns error changeset" do
#      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs)
#    end
#
#    test "update_account/2 with valid data updates the account" do
#      account = account_fixture()
#      assert {:ok, account} = Accounts.update_account(account, @update_attrs)
#      assert %Account{} = account
#      assert account.email == "some updated email"
#      assert account.name == "some updated name"
#    end
#
#    test "update_account/2 with invalid data returns error changeset" do
#      account = account_fixture()
#      assert {:error, %Ecto.Changeset{}} = Accounts.update_account(account, @invalid_attrs)
#      assert account == Accounts.get_account!(account.id)
#    end
#
#    test "delete_account/1 deletes the account" do
#      account = account_fixture()
#      assert {:ok, %Account{}} = Accounts.delete_account(account)
#      assert_raise Ecto.NoResultsError, fn -> Accounts.get_account!(account.id) end
#    end
#
#    test "change_account/1 returns a account changeset" do
#      account = account_fixture()
#      assert %Ecto.Changeset{} = Accounts.change_account(account)
#    end
#  end
#end

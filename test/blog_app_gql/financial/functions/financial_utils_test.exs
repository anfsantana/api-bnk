defmodule BlogAppGql.Financial.Functions.FinancialUtilsTest do
  use BlogAppGql.DataCase

  alias BlogAppGql.Financial.Functions.FinancialUtils, as: Utils

  describe "financial_utils" do

    test "have_balance/2 returns :ok with balance" do
      assert Utils.have_balance?(30.55, 30.00) == {:ok, 30.55}
    end

    test "value_greater_than_zero/1 returns :ok with value" do
      assert Utils.value_greater_than_zero?(20) == {:ok, 20}
    end

  end
end

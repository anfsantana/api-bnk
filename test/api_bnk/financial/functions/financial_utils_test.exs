defmodule ApiBnK.Financial.Functions.FinancialUtilsTest do
  @moduledoc """
  Módulo que testa as funcções implementadas no módulo
  ApiBnK.Financial.Functions.FinancialUtils
  """
  use ApiBnK.DataCase

  alias ApiBnK.Financial.Functions.FinancialUtils, as: Utils

  describe "financial_utils" do

    test "have_balance/2 returns :ok with balance" do
      assert {:ok, 30.55} == Utils.have_balance?(30.55, 30.00)
    end

    test "value_greater_than_zero/1 returns :ok with value" do
      assert {:ok, 20} == Utils.value_greater_than_zero?(20)
    end

  end
end

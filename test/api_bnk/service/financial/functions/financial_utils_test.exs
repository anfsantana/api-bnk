defmodule ApiBnK.Service.Financial.Functions.FinancialUtilsTest do
  @moduledoc """
  Módulo que testa as funcções implementadas no módulo
  ApiBnK.Financial.Functions.FinancialUtils
  """
  use ApiBnK.DataCase

  doctest ApiBnK.Service.Financial.Functions.FinancialUtils

  alias ApiBnK.Service.Financial.Functions.FinancialUtils, as: Utils

  describe "financial_utils" do

    test "have_balance/2 : sucesso retorna uma tupla com :ok e o saldo" do
      assert {:ok, 30.55} == Utils.have_balance?(30.55, 30.00)
    end

    test "value_greater_than_zero/1 : sucesso retorna uma tupla com :ok e o valor informado" do
      assert {:ok, 20} == Utils.value_greater_than_zero?(20)
    end

  end
end

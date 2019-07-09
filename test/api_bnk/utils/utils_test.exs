defmodule ApiBnK.UtilsTest do
  use ApiBnK.DataCase
  use ExUnit.Case

  alias ApiBnK.Utils.Utils, as: Utils
  doctest ApiBnK.Utils.Utils

  describe "utils" do

    test "add_prefix_on_atom/2 retorna o átomo informado com o prefixo" do
      assert Utils.add_prefix_on_atom(:account, "acc_") == :acc_account
    end

  end

end

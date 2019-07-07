defmodule ApiBnK.UtilsTest do
  use ApiBnK.DataCase

  alias ApiBnK.Utils, as: Utils

  describe "utils" do

    test "add_prefix_on_atom/2 returns atom with prefix" do
      atom = :acc_account
      assert Utils.add_prefix_on_atom(:account, "acc_") == atom
    end

  end
end

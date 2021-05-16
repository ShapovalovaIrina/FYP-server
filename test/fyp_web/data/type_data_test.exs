defmodule TypeDataTest do
  use ExUnit.Case
  use Fyp.DataCase, async: false

  alias Fyp.Type

  test "Get all types" do
    type_list = Type.get_all_types()
    assert length(type_list) == 2
    assert %{id: _, type: _} = hd(type_list)
  end
end

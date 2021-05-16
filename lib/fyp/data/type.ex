defmodule Fyp.Type do
  @moduledoc """
  """

  alias Schemas.Type
  alias Fyp.Repo

  def get_all_types() do
    query = Type
    Repo.all(query)
  end

  def type_struct_to_type_map(%Type{} = type) do
    Map.take(type, [
      :id,
      :type
    ])
  end

  def type_struct_to_type_map(_incorrect_input) do
    %{}
  end
end

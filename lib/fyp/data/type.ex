defmodule Fyp.Type do
  @moduledoc """
  """

  alias Schemas.Type
  alias Fyp.Repo

  def get_all_types() do
    query = Type
    Repo.all(query)
  end
end

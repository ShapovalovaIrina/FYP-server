# Script for populating the database. You can run it as:
#
#     mix run priv/repo/shelter_seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Fyp.Repo.insert!(%Fyp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

require Logger

shelter_data =
  %Schemas.Shelter{
    id: 1,
    title: "Shelter Friend",
    vk_link: "",
    site_link: ""
  }

opts = [
  on_conflict: :replace_all,
  conflict_target: :id
]

case Fyp.Repo.insert(shelter_data, opts) do
  {:ok, _} ->
    Logger.info("Insert shelter info")
    :ok
  {:error, reason} ->
    Logger.warn("Insertion failed. Reason: #{inspect(reason)}")
    :error
end
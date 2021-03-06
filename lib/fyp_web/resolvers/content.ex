defmodule FypWeb.Resolvers.Content do

  def list_pets(_parent, _args, _resolution) do
    {:ok, Fyp.Pets.pet_list()}
  end

  def pet_by_id(_parent, %{id: id} = _args, _resolution) do
    case Fyp.Pets.pet_by_id(id) do
      {:error, :not_found} -> {:error, "Pet with #{id} not found"}
      {:ok, pet} -> {:ok, pet}
    end
  end

  def photo_amount(%{photos: photos} = _parent, args, _resolution) do
    amount = case args[:amount] do
      nil -> 1000
      value -> if value > 0, do: value, else: 0
    end
    {:ok, Enum.take(photos, amount)}
  end
end

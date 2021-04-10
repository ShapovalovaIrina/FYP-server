defmodule Fyp.Repo.Migrations.Users do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
    end

    create table(:favourite_pets) do
      add :user_id, references(:users, column: :id, type: :id)
      add :pet_id, references(:pets, column: :id, type: :uuid)
    end

    create unique_index(:favourite_pets, [:user_id, :pet_id])
  end
end

defmodule Fyp.Repo.Migrations.Users do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :string, primary_key: true
      add :email, :string
    end

    create unique_index(:users, :email)

    create table(:favourite_pets) do
      add :user_id, references(:users, column: :id, type: :string, on_delete: :delete_all, on_update: :update_all)
      add :pet_id, references(:pets, column: :id, type: :uuid, on_delete: :delete_all, on_update: :update_all)
    end

    create unique_index(:favourite_pets, [:user_id, :pet_id])
  end
end

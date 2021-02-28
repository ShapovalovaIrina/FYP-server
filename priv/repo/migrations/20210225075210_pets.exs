defmodule Fyp.Repo.Migrations.Pets do
  use Ecto.Migration

  def change do
    create table(:pets, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :breed, :string
      add :gender, :string
      add :birth, :string
      add :height, :string
      add :description, :string
      timestamps()
    end

    create table(:photos) do
      add :photo_url, :string, null: false
      add :pets_id, references(:pets, column: :id, type: :uuid)
      timestamps()
    end
  end
end

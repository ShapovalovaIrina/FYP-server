defmodule Fyp.Repo.Migrations.Pets do
  use Ecto.Migration

  def change do
    create table(:shelter) do
      add :title, :string, null: false
      add :vk_link, :string
      add :site_link, :string
    end

    create unique_index(:shelter, :title)

    create table(:pets, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :breed, :string
      add :gender, :string
      add :birth, :string
      add :height, :string
      add :description, :string
      add :shelter_id, references(:shelter, column: :id, type: :id)
    end

    create unique_index(:pets, [:name, :shelter_id])

    create table(:photos, primary_key: false) do
      add :photo_url, :string, primary_key: true
      add :pets_id, references(:pets, column: :id, type: :uuid)
    end
  end
end

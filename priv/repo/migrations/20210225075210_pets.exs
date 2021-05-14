defmodule Fyp.Repo.Migrations.Pets do
  use Ecto.Migration

  def change do
    create table(:shelter) do
      add :title, :string, null: false
      add :vk_link, :string
      add :site_link, :string
    end

    create unique_index(:shelter, :title)

    create table(:type) do
      add :type, :string, null: false
    end

    create unique_index(:type, :type)

    create table(:pets, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :breed, :string
      add :gender, :string
      add :birth, :string
      add :height, :string
      add :description, :text
      add :shelter_id, references(:shelter, column: :id, type: :id)
      add :type_id, references(:type, column: :id, type: :id)
    end

    create unique_index(:pets, [:name, :shelter_id, :type_id])

    create table(:photos, primary_key: false) do
      add :photo_url, :string, primary_key: true
      add :pets_id, references(:pets, column: :id, type: :uuid, on_delete: :delete_all)
    end
  end
end

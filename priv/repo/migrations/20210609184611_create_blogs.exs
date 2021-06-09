defmodule Statusblog.Repo.Migrations.CreateBlogs do
  use Ecto.Migration

  def change do
    create table(:blogs) do
      add :name, :string, null: false
      add :description, :string
      add :subdomain, :string, null: false
      add :domain, :string

      timestamps()
    end

    create unique_index(:blogs, [:domain])
    create unique_index(:blogs, [:subdomain])
  end
end

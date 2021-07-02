defmodule Statusblog.Repo.Migrations.CreateBlogs do
  use Ecto.Migration

  def change do
    create table(:blogs) do
      add :name, :text, null: false
      add :description, :text
      add :subdomain, :text, null: false
      add :domain, :text

      timestamps()
    end

    create unique_index(:blogs, [:domain])
    create unique_index(:blogs, [:subdomain])
  end
end

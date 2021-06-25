defmodule Statusblog.Repo.Migrations.CreateIncidents do
  use Ecto.Migration

  def change do
    create table(:incidents) do
      add :name, :string, null: false
      add :blog_id, references(:blogs, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:incidents, [:blog_id])
  end
end

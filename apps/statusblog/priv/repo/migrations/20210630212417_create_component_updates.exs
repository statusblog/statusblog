defmodule Statusblog.Repo.Migrations.CreateComponentUpdates do
  use Ecto.Migration

  def change do
    create table(:component_updates) do
      add :status, :string, null: false
      add :component_id, references(:components, on_delete: :delete_all)

      timestamps()
    end

    create index(:component_updates, [:component_id])
  end
end

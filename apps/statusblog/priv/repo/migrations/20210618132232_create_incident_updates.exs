defmodule Statusblog.Repo.Migrations.CreateIncidentUpdates do
  use Ecto.Migration

  def change do
    create table(:incident_updates) do
      add :message, :text, null: false
      add :status, :text, null: false
      add :incident_id, references(:incidents, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:incident_updates, [:incident_id])
  end
end

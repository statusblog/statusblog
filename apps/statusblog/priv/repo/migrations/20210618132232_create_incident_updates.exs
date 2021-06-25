defmodule Statusblog.Repo.Migrations.CreateIncidentUpdates do
  use Ecto.Migration

  def change do
    create table(:incident_updates) do
      add :body, :string, null: false
      add :status, :string, null: false
      add :incident_id, references(:incidents, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:incident_updates, [:incident_id])
  end
end

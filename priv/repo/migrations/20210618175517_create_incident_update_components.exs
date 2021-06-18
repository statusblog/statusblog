defmodule Statusblog.Repo.Migrations.CreateIncidentUpdateComponents do
  use Ecto.Migration

  def change do
    alter table(:incident_updates) do
      add :components, :map
    end
  end
end

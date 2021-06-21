defmodule Statusblog.Repo.Migrations.IncidentStatusResolved do
  use Ecto.Migration

  def change do
    alter table(:incidents) do
       add :status, :string, null: false, default: "investigating"
       add :resolved_at, :naive_datetime
    end
  end
end

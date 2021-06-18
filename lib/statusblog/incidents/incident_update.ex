defmodule Statusblog.Incidents.IncidentUpdate do
  use Ecto.Schema
  import Ecto.Changeset
  alias Statusblog.Incidents.Incident

  schema "incident_updates" do
    field :body, :string
    field :status, Ecto.Enum, values: [:investigating, :identified, :monitoring, :resolved]
    belongs_to :incident, Incident

    timestamps()
  end

  @doc false
  def changeset(incident_update, attrs) do
    incident_update
    |> cast(attrs, [:body, :status])
    |> validate_required([:body, :status])
  end
end

defmodule Statusblog.Incidents.IncidentUpdate do
  use Ecto.Schema
  import Ecto.Changeset
  alias Statusblog.Incidents.Incident
  alias Statusblog.Incidents.IncidentUpdateComponent

  @status_values [:investigating, :identified, :monitoring, :resolved]
  def status_values(), do: @status_values

  schema "incident_updates" do
    field :body, :string
    field :status, Ecto.Enum, values: @status_values
    embeds_many :components, IncidentUpdateComponent
    belongs_to :incident, Incident

    timestamps()
  end

  @doc false
  def changeset(incident_update, attrs) do
    incident_update
    |> cast(attrs, [:body, :status])
    |> cast_embed(:components)
    |> validate_required([:body, :status])
  end

  def filter_unselected_components(incident_update) do
    incident_update
    |> put_embed(:components, Enum.filter(incident_update.changes.components, fn cs -> cs.changes.selected end))
  end
end

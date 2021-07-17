defmodule Statusblog.Incidents.IncidentUpdate do
  use Ecto.Schema
  import Ecto.Changeset
  alias Statusblog.Incidents.Incident
  alias Statusblog.Incidents.IncidentUpdateComponent

  @status_values [:investigating, :identified, :monitoring, :resolved]
  def status_values(), do: @status_values

  schema "incident_updates" do
    field :message, :string
    field :status, Ecto.Enum, values: @status_values
    embeds_many :components, IncidentUpdateComponent
    belongs_to :incident, Incident

    timestamps()
  end

  @doc false
  def changeset(incident_update, attrs) do
    incident_update
    |> cast(attrs, [:message, :status])
    |> cast_embed(:components)
    |> validate_required([:message, :status])
  end

end

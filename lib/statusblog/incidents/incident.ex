defmodule Statusblog.Incidents.Incident do
  use Ecto.Schema
  import Ecto.Changeset
  alias Statusblog.Blogs.Blog
  alias Statusblog.Incidents.IncidentUpdate

  schema "incidents" do
    field :name, :string
    field :status, Ecto.Enum, values: IncidentUpdate.status_values()
    field :resolved_at, :utc_datetime

    belongs_to :blog, Blog
    has_many :incident_updates, IncidentUpdate

    timestamps()
  end

  @doc false
  def changeset(incident, attrs) do
    incident
    |> cast(attrs, [:name, :status, :resolved_at])
    |> validate_required([:name])
  end
end

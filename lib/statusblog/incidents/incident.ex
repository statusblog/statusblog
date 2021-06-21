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
    |> cast_assoc(:incident_updates)
    |> validate_required([:name])
  end

  def filter_unselected_components(changeset) do
    filtered_updates =
      get_change(changeset, :incident_updates)
      |> Enum.map(&IncidentUpdate.filter_unselected_components/1)

    put_change(changeset, :incident_updates, filtered_updates)
  end
end

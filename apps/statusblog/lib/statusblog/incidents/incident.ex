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
    |> cast_assoc(:incident_updates, required: true)
    |> validate_required([:name, :status])
    |> prepare_changes(&maybe_set_resolved_at/1)
  end

  defp maybe_set_resolved_at(changeset) do
    case get_change(changeset, :status) do
      :resolved -> put_change(changeset, :resolved_at, DateTime.utc_now() |> DateTime.truncate(:second))
      _ -> changeset
    end
  end
end

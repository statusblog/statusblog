defmodule Statusblog.Incidents.IncidentUpdateComponent do
  use Ecto.Schema
  import Ecto.Changeset
  alias Statusblog.Components.Component

  @primary_key false
  embedded_schema do
    # this _should_ be virtual so that we only use it to drive UI and eventually
    # just filter out before insertion. unfortunately there is no good way to do that
    # it is worth taking the miniscule storage hit instead of making Ecto happy, and filtering
    # when displaying in UI, instead, for now.
    field :selected, :boolean

    field :id, :integer, primary_key: true
    field :name, :string
    field :status, Ecto.Enum, values: Component.status_values()
  end

  def changeset(component, attrs) do
    component
    |> cast(attrs, [:id, :name, :status, :selected])
    |> validate_required([:id, :name, :status, :selected])
  end
end

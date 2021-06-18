defmodule Statusblog.Incidents.IncidentUpdateComponent do
  use Ecto.Schema
  import Ecto.Changeset
  alias Statusblog.Components.Component

  @primary_key false
  embedded_schema do
    field :selected, :boolean, virtual: true

    field :id, :integer, primary_key: true
    field :name, :string
    field :status, Ecto.Enum, values: Component.status_values()
  end

  def changeset(_component, %{selected: false}) do
    %Ecto.Changeset{action: :ignore}
  end

  def changeset(component, attrs) do
    component
    |> cast(attrs, [:id, :name, :status])
    |> validate_required([:id, :name, :status])
  end
end

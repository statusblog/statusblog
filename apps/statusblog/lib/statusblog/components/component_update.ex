defmodule Statusblog.Components.ComponentUpdate do
  use Ecto.Schema
  import Ecto.Changeset
  alias Statusblog.Components.Component

  # these are in ascending order of "importance"
  @status_values [:operational, :under_maintenance, :degraded_performance, :partial_outage, :major_outage]

  schema "component_updates" do
    field :status, Ecto.Enum, values: @status_values

    belongs_to :component, Component

    timestamps()
  end

  @doc false
  def changeset(component_update, attrs) do
    component_update
    |> cast(attrs, [:status])
    |> validate_required([:status])
  end
end

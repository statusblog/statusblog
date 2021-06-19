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

  # def changeset(_component, %{selected: false}) do
  #   %Ecto.Changeset{action: :ignore}
  # end

  def changeset(component, attrs) do
    component
    |> cast(attrs, [:id, :name, :status, :selected])
    |> validate_required([:id, :name, :status, :selected])
    #|> ignore_if_not_selected()
    # |> IO.inspect
  end

  def ignore_if_not_selected(%Ecto.Changeset{changes: %{selected: false}} = c), do: %{c | action: :ignore}
  def ignore_if_not_selected(c), do: c
end

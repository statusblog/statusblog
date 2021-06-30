defmodule Statusblog.Components.Component do
  use Ecto.Schema
  import Ecto.Changeset
  alias Statusblog.Blogs.Blog
  alias Statusblog.Components.ComponentUpdate

  # these are in ascending order of "importance"
  @status_values [:operational, :under_maintenance, :degraded_performance, :partial_outage, :major_outage]
  def status_values(), do: @status_values

  schema "components" do
    field :description, :string
    field :display_uptime, :boolean, default: false
    field :name, :string
    field :position, :integer
    field :start_date, :date
    field :status, Ecto.Enum, values: @status_values

    belongs_to :blog, Blog
    has_many :component_updates, ComponentUpdate, preload_order: [desc: :inserted_at]

    timestamps()
  end

  @doc false
  def changeset(component, attrs) do
    component
    |> cast(attrs, [:name, :description, :position, :status, :display_uptime, :start_date])
    |> add_default_start_date()
    |> validate_required([:name, :position, :status, :display_uptime, :start_date])
    |> unique_constraint([:blog_id, :position])
    |> prepare_changes(&maybe_create_component_update/1)
  end

  defp maybe_create_component_update(changeset) do
    case {get_change(changeset, :status), fetch_field(changeset, :component_updates)} do
      {nil, _any} ->
        changeset

      # will later raise on insert
      {status, {:data, %Ecto.Association.NotLoaded{}}} ->
        put_assoc(changeset, :component_updates, [%ComponentUpdate{status: status}])

      {status, {:data, existing_updates}} ->
        put_assoc(changeset, :component_updates, [%ComponentUpdate{status: status} | existing_updates])
    end
  end

  # its in the changes already
  defp add_default_start_date(%Ecto.Changeset{changes: %{start_date: _}} = changeset) do
    changeset
  end

  # not in the changes, nor in the data
  defp add_default_start_date(%Ecto.Changeset{data: %__MODULE__{start_date: nil}} = changeset) do
    changeset |> put_change(:start_date, Date.utc_today())
  end

  defp add_default_start_date(changeset), do: changeset
end

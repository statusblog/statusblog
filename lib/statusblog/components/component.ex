defmodule Statusblog.Components.Component do
  use Ecto.Schema
  import Ecto.Changeset
  alias Statusblog.Blogs.Blog

  @status_values [:operational, :under_maintenance, :degraded_performance, :partial_outage, :major_outage]

  schema "components" do
    field :description, :string
    field :display_uptime, :boolean, default: false
    field :name, :string
    field :position, :integer
    field :start_date, :date
    field :status, Ecto.Enum, values: @status_values
    belongs_to :blog, Blog

    timestamps()
  end

  @doc false
  def changeset(component, attrs) do
    component
    |> cast(attrs, [:name, :description, :position, :status, :display_uptime, :start_date])
    |> add_default_start_date()
    |> validate_required([:name, :position, :status, :display_uptime, :start_date])
    |> unique_constraint([:blog_id, :position])
    |> validate_inclusion(:status, @status_values)
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

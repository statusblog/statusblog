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
    |> cast(attrs, [:name, :description, :position, :status, :display_uptime, :start_date, :blog_id])
    |> validate_required([:name, :position, :status, :display_uptime, :start_date, :blog_id])
    |> unique_constraint([:blog_id, :status])
    |> validate_inclusion(:status, @status_values)
  end
end

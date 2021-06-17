defmodule Statusblog.Incidents.Incident do
  use Ecto.Schema
  import Ecto.Changeset
  alias Statusblog.Blogs.Blog

  schema "incidents" do
    field :name, :string
    belongs_to :blog, Blog

    timestamps()
  end

  @doc false
  def changeset(incident, attrs) do
    incident
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end

defmodule Statusblog.Blogs.Blog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "blogs" do
    field :description, :string
    field :domain, :string
    field :name, :string
    field :subdomain, :string

    timestamps()
  end

  @doc false
  def changeset(blog, attrs) do
    blog
    |> cast(attrs, [:name, :description, :subdomain, :domain])
    |> validate_required([:name, :description, :subdomain, :domain])
    |> unique_constraint(:domain)
    |> unique_constraint(:subdomain)
  end
end

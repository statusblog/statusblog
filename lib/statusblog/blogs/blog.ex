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
    |> validate_required([:name])
    |> validate_subdomain()
    |> unique_constraint(:domain)
  end

  defp validate_subdomain(changeset) do
    changeset
    |> validate_required([:subdomain])
    |> validate_format(:subdomain, ~r/^(?![0-9]+$)(?!.*-$)(?!-)[a-zA-Z0-9-]{1,63}$/,
      message: "must only contain characters a-z, 0-9, hyphens, and cannot begin with a hyphen")
    |> unique_constraint(:subdomain)
  end
end

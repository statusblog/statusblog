defmodule Statusblog.Subscriptions.Subscription do
  use Ecto.Schema
  import Ecto.Changeset
  alias Statusblog.Blogs.Blog

  schema "subscriptions" do
    field :email, :string
    belongs_to :blog, Blog

    timestamps()
  end

  @doc false
  def changeset(subscription, attrs) do
    subscription
    |> cast(attrs, [:email])
    |> validate_email()
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique([:email, :blog_id], Statusblog.Repo)
    |> unique_constraint([:email, :blog_id])
  end
end

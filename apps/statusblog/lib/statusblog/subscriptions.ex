defmodule Statusblog.Subscriptions do
  @moduledoc """
  The Subscriptions context.
  """

  import Ecto.Query, warn: false
  alias Statusblog.Repo

  alias Statusblog.Blogs.Blog
  alias Statusblog.Subscriptions.Subscription

  def list_subscriptions(blog_id) do
    from(Subscription, where: [blog_id: ^blog_id])
    |> Repo.all()
  end

  @doc """
  Gets a single subscription.

  Raises `Ecto.NoResultsError` if the Subscription does not exist.

  ## Examples

      iex> get_subscription!(123)
      %Subscription{}

      iex> get_subscription!(456)
      ** (Ecto.NoResultsError)

  """
  def get_subscription!(id), do: Repo.get!(Subscription, id)

  @doc """
  Creates a subscription.

  ## Examples

      iex> create_subscription(%{field: value})
      {:ok, %Subscription{}}

      iex> create_subscription(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_subscription(%Blog{} = blog, attrs \\ %{}) do
    %Subscription{blog_id: blog.id}
    |> Subscription.insert_changeset(attrs)
    |> Repo.insert()
  end

  def confirm_subscription(%Blog{} = blog, token) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)
    query = Subscription.token_query(blog, token)

    with %Subscription{} = subscription <- Repo.one(query),
         {:ok, updated_subscription} = update_subscription(subscription, %{confirmed_at: now}) do
      {:ok, updated_subscription}
    else
      _ -> :error
    end
  end

  # if already unsubscribed (token not found) returns success
  def unsubscribe_subscription(%Blog{} = blog, token) do
    subscription =
      Subscription.token_query(blog, token)
      |> Repo.one()

    if subscription != nil do
      delete_subscription(subscription)
    else
      {:ok, nil}
    end
  end

  @doc """
  Updates a subscription.

  ## Examples

      iex> update_subscription(subscription, %{field: new_value})
      {:ok, %Subscription{}}

      iex> update_subscription(subscription, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_subscription(%Subscription{} = subscription, attrs) do
    subscription
    |> Subscription.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a subscription.

  ## Examples

      iex> delete_subscription(subscription)
      {:ok, %Subscription{}}

      iex> delete_subscription(subscription)
      {:error, %Ecto.Changeset{}}

  """
  def delete_subscription(%Subscription{} = subscription) do
    Repo.delete(subscription)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking subscription changes.

  ## Examples

      iex> change_subscription(subscription)
      %Ecto.Changeset{data: %Subscription{}}

  """
  def change_subscription(%Subscription{} = subscription, attrs \\ %{}) do
    Subscription.changeset(subscription, attrs)
  end
end

defmodule Statusblog.Components do
  @moduledoc """
  The Components context.
  """

  import Ecto.Query, warn: false
  alias Statusblog.Repo

  alias Statusblog.Components.Component
  alias Statusblog.Blogs.Blog

  #def list_components(%Blog{id: id} = blog), do: list_components(id)
  def list_components(blog_id) do
    from(Component, where: [blog_id: ^blog_id], order_by: [asc: :position])
    |> Repo.all()
  end

  @doc """
  Gets a single component.

  Raises `Ecto.NoResultsError` if the Component does not exist.

  ## Examples

      iex> get_component!(123)
      %Component{}

      iex> get_component!(456)
      ** (Ecto.NoResultsError)

  """
  def get_component!(id), do: Repo.get!(Component, id)

  @doc """
  Creates a component.

  ## Examples

      iex> create_component(%{field: value})
      {:ok, %Component{}}

      iex> create_component(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_component(%Blog{} = blog, attrs \\ %{}) do
    position = Repo.one!(from c in Component, select: coalesce(max(c.position), 0))
    %Component{blog_id: blog.id, position: position + 1}
    |> Component.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a component.

  ## Examples

      iex> update_component(component, %{field: new_value})
      {:ok, %Component{}}

      iex> update_component(component, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_component(%Component{} = component, attrs) do
    component
    |> Component.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a component.

  ## Examples

      iex> delete_component(component)
      {:ok, %Component{}}

      iex> delete_component(component)
      {:error, %Ecto.Changeset{}}

  """
  def delete_component(%Component{} = component) do
    Repo.delete(component)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking component changes.

  ## Examples

      iex> change_component(component)
      %Ecto.Changeset{data: %Component{}}

  """
  def change_component(%Component{} = component, attrs \\ %{}) do
    component
    |> Repo.preload(:component_updates)
    |> Component.changeset(attrs)
  end
end

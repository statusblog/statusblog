defmodule Statusblog.Incidents do
  @moduledoc """
  The Incidents context.
  """

  import Ecto.Query, warn: false
  alias Statusblog.Repo

  alias Statusblog.Components
  alias Statusblog.Incidents.Incident
  alias Statusblog.Blogs.Blog

  def list_incidents(blog_id) do
    from(Incident, where: [blog_id: ^blog_id], order_by: [desc: :inserted_at])
    |> Repo.all()
  end

  def list_open_incidents(blog_id) do
    from(i in Incident,
      where: i.blog_id == ^blog_id and is_nil(i.resolved_at),
      order_by: [desc: :inserted_at],
      preload: [:incident_updates]
    )
    |> Repo.all()
  end

  def list_resolved_incidents(blog_id) do
    from(i in Incident,
      where: i.blog_id == ^blog_id and not is_nil(i.resolved_at),
      order_by: [desc: :inserted_at],
      preload: [:incident_updates]
    )
    |> Repo.all()
  end

  @doc """
  Gets a single incident.

  Raises `Ecto.NoResultsError` if the Incident does not exist.

  ## Examples

      iex> get_incident!(123)
      %Incident{}

      iex> get_incident!(456)
      ** (Ecto.NoResultsError)

  """
  def get_incident!(id), do: Repo.get!(Incident, id)

  @doc """
  Creates a incident.

  ## Examples

      iex> create_incident(%{field: value})
      {:ok, %Incident{}}

      iex> create_incident(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_incident(%Blog{} = blog, attrs \\ %{}) do
    changeset =
      %Incident{blog_id: blog.id}
      |> Incident.changeset(attrs)

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:incident, changeset)
    |> Ecto.Multi.merge(fn %{incident: incident} ->
      [incident_update] = incident.incident_updates

      multi =
        Ecto.Multi.new()
        |> Oban.insert(
          :job,
          Statusblog.Workers.ProcessIncidentUpdate.new(%{
            incident_update_id: incident_update.id,
            is_new?: true
          })
        )

      Enum.filter(incident_update.components, fn iuc -> iuc.selected end)
      |> Enum.reduce(multi, fn iuc, multi ->
        component = Components.get_component!(iuc.id)

        if component.status != iuc.status do
          Ecto.Multi.update(
            multi,
            "component_#{iuc.id}",
            Components.change_component(component, %{status: iuc.status})
          )
        else
          multi
        end
      end)
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{incident: incident}} ->
        {:ok, incident}

      {:error, :incident, changeset, _} ->
        {:error, changeset}
        # don't handle component issues
    end
  end

  @doc """
  Updates a incident.

  ## Examples

      iex> update_incident(incident, %{field: new_value})
      {:ok, %Incident{}}

      iex> update_incident(incident, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_incident(%Incident{} = incident, attrs) do
    incident
    |> Incident.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a incident.

  ## Examples

      iex> delete_incident(incident)
      {:ok, %Incident{}}

      iex> delete_incident(incident)
      {:error, %Ecto.Changeset{}}

  """
  def delete_incident(%Incident{} = incident) do
    Repo.delete(incident)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking incident changes.

  ## Examples

      iex> change_incident(incident)
      %Ecto.Changeset{data: %Incident{}}

  """
  def change_incident(%Incident{} = incident, attrs \\ %{}) do
    Incident.changeset(incident, attrs)
  end

  alias Statusblog.Incidents.IncidentUpdate

  def list_incident_updates(incident_id) do
    from(IncidentUpdate, where: [incident_id: ^incident_id], order_by: [desc: :inserted_at])
    |> Repo.all()
  end

  @doc """
  Gets a single incident_update.

  Raises `Ecto.NoResultsError` if the Incident update does not exist.

  ## Examples

      iex> get_incident_update!(123)
      %IncidentUpdate{}

      iex> get_incident_update!(456)
      ** (Ecto.NoResultsError)

  """
  def get_incident_update!(id), do: Repo.get!(IncidentUpdate, id)

  @doc """
  Creates a incident_update.

  ## Examples

      iex> create_incident_update(%{field: value})
      {:ok, %IncidentUpdate{}}

      iex> create_incident_update(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_incident_update(%Incident{} = incident, attrs \\ %{}) do
    iu_changeset =
      %IncidentUpdate{incident_id: incident.id}
      |> IncidentUpdate.changeset(attrs)

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:incident_update, iu_changeset)
    |> Ecto.Multi.merge(fn %{incident_update: incident_update} ->
      # update incident
      multi =
        Ecto.Multi.new()
        |> Ecto.Multi.update(
          :incident,
          change_incident(incident, %{status: incident_update.status})
        )
        |> Oban.insert(
          :job,
          Statusblog.Workers.ProcessIncidentUpdate.new(%{
            incident_update_id: incident_update.id,
            is_new?: false
          })
        )

      # update components
      Enum.filter(incident_update.components, fn iuc -> iuc.selected end)
      |> Enum.reduce(multi, fn iuc, multi ->
        component = Components.get_component!(iuc.id)

        if component.status != iuc.status do
          Ecto.Multi.update(
            multi,
            "component_#{iuc.id}",
            Components.change_component(component, %{status: iuc.status})
          )
        else
          multi
        end
      end)
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{incident_update: incident_update}} ->
        {:ok, incident_update}

      {:error, :incident_update, changeset, _} ->
        {:error, changeset}
        # don't handle component issues
    end
  end

  @doc """
  Updates a incident_update.

  ## Examples

      iex> update_incident_update(incident_update, %{field: new_value})
      {:ok, %IncidentUpdate{}}

      iex> update_incident_update(incident_update, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_incident_update(%IncidentUpdate{} = incident_update, attrs) do
    incident_update
    |> IncidentUpdate.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a incident_update.

  ## Examples

      iex> delete_incident_update(incident_update)
      {:ok, %IncidentUpdate{}}

      iex> delete_incident_update(incident_update)
      {:error, %Ecto.Changeset{}}

  """
  def delete_incident_update(%IncidentUpdate{} = incident_update) do
    Repo.delete(incident_update)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking incident_update changes.

  ## Examples

      iex> change_incident_update(incident_update)
      %Ecto.Changeset{data: %IncidentUpdate{}}

  """
  def change_incident_update(%IncidentUpdate{} = incident_update, attrs \\ %{}) do
    IncidentUpdate.changeset(incident_update, attrs)
  end
end

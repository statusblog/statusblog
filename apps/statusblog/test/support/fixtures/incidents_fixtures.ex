defmodule Statusblog.IncidentsFixtures do
  alias Statusblog.BlogsFixtures
  alias Statusblog.Incidents

  @moduledoc """
  This module defines test helpers for creating
  entities via the `Statusblog.Incidents` context.
  """

  @doc """
  Generate a incident.
  """
  def incident_fixture(), do: incident_fixture(BlogsFixtures.blog_fixture())

  def incident_fixture(blog, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        name: "some name",
        status: :investigating,
        incident_updates: [
          %{
            message: "some body",
            status: :investigating
          }
        ]
      })

    {:ok, incident} = Incidents.create_incident(blog, attrs)

    incident
  end

  def incident_update_fixture(), do: incident_update_fixture(incident_fixture())

  @doc """
  Generate a incident_update.
  """
  def incident_update_fixture(incident, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        message: "some body",
        status: :investigating
      })

    {:ok, incident_update} = Incidents.create_incident_update(incident, attrs)

    incident_update
  end
end

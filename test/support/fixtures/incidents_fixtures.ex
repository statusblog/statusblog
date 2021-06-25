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
  def incident_fixture(attrs \\ %{}) do
    {:ok, incident} =
      attrs
      |> Enum.into(%{
        name: "some name",
        status: :investigating,
        incident_updates: [
          %{
            body: "some body",
            status: :investigating
          }
        ]
      })
      |> create_incident()

    incident
  end

  defp create_incident(attrs), do: Incidents.create_incident(BlogsFixtures.blog_fixture(), attrs)

  @spec incident_update_fixture(any) :: any
  @doc """
  Generate a incident_update.
  """
  def incident_update_fixture(attrs \\ %{}) do
    {:ok, incident_update} =
      attrs
      |> Enum.into(%{
        body: "some body",
        status: :investigating
      })
      |> create_incident_update()

    incident_update
  end

  defp create_incident_update(attrs), do: Incidents.create_incident_update(incident_fixture(), attrs)
end

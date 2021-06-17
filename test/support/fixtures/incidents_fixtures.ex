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
        name: "some name"
      })
      |> create_incident()

    incident
  end

  defp create_incident(attrs), do: Incidents.create_incident(BlogsFixtures.blog_fixture(), attrs)
end

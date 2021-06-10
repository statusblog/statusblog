defmodule Statusblog.ComponentsFixtures do
  alias Statusblog.BlogsFixtures

  @moduledoc """
  This module defines test helpers for creating
  entities via the `Statusblog.Components` context.
  """

  @doc """
  Generate a component.
  """
  def component_fixture(attrs \\ %{}) do
    {:ok, component} =
      attrs
      |> Enum.into(%{
        description: "some description",
        display_uptime: true,
        name: "some name",
        position: 0,
        start_date: ~D[2021-06-09],
        status: :operational,
        blog_id: BlogsFixtures.blog_fixture().id
      })
      |> Statusblog.Components.create_component()

    component
  end
end

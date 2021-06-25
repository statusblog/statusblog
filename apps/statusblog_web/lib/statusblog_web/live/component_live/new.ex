defmodule StatusblogWeb.ComponentLive.New do
  use StatusblogWeb, :live_view

  alias Statusblog.Blogs
  alias Statusblog.Components
  alias Statusblog.Components.Component
  alias StatusblogWeb.MountHelpers

  def mount(params, session, socket) do
    {:ok,
      socket
      |> MountHelpers.assign_defaults(params, session)
      |> assign(:menu, :components)
      |> assign(:page_title, "New component")
      |> assign(:component, %Component{})}
  end
end

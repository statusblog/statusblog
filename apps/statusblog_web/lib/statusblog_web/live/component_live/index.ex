defmodule StatusblogWeb.ComponentLive.Index do
  use StatusblogWeb, :live_view

  alias Statusblog.Blogs
  alias Statusblog.Components
  alias StatusblogWeb.MountHelpers

  @impl true
  def mount(params, session, socket) do
    {:ok,
     socket
     |> MountHelpers.assign_defaults(params, session)
     |> assign_components()
     |> assign(:page_title, "Components")
     |> assign(:menu, :components)}
  end

  defp assign_components(socket) do
    socket
    |> assign(:components, Components.list_components(socket.assigns.blog.id))
  end
end

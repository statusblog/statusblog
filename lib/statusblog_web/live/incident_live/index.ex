defmodule StatusblogWeb.IncidentLive.Index do
  use StatusblogWeb, :live_view

  alias Statusblog.Incidents
  alias StatusblogWeb.MountHelpers

  @impl true
  def mount(params, session, socket) do
    {:ok,
      socket
      |> MountHelpers.assign_defaults(params, session)
      |> assign_incidents()
      |> assign(:page_title, "Incidents")
      |> assign(:menu, :incidents)}
  end

  defp assign_incidents(socket) do
    socket
    |> assign(:incidents, Incidents.list_incidents(socket.assigns.blog.id))
  end

end

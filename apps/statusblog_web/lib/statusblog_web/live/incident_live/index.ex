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
    |> assign(:incidents, list_incidents(socket))
  end

  defp list_incidents(socket) do
    case socket.assigns.live_action do
      :resolved -> Incidents.list_resolved_incidents(socket.assigns.blog.id)
      :index -> Incidents.list_open_incidents(socket.assigns.blog.id)
    end
  end

  defp tab_class(true),
    do:
      "border-indigo-500 text-indigo-600 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm"

  defp tab_class(false),
    do:
      "border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm"
end

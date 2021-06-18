defmodule StatusblogWeb.IncidentLive.Edit do
  use StatusblogWeb, :live_view

  alias Statusblog.Incidents
  alias StatusblogWeb.MountHelpers

  @impl true
  def mount(%{"incident_id" => incident_id} = params, session, socket) do
    {:ok,
      socket
      |> MountHelpers.assign_defaults(params, session)
      |> assign(:page_title, "Edit incident")
      |> assign(:menu, :incidents)
      |> assign(:incident, Incidents.get_incident!(incident_id))}
  end
end

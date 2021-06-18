defmodule StatusblogWeb.IncidentLive.New do
  use StatusblogWeb, :live_view

  alias Statusblog.Incidents
  alias Statusblog.Incidents.Incident
  alias StatusblogWeb.MountHelpers

  @impl true
  def mount(params, session, socket) do
    {:ok,
      socket
      |> MountHelpers.assign_defaults(params, session)
      |> assign(:menu, :incidents)
      |> assign(:page_title, "New incident")
      |> assign(:changeset, Incidents.change_incident(%Incident{}))}
  end

  @impl true
  def handle_event("validate", %{"incident" => incident_params}, socket) do
    changeset =
      %Incident{}
      |> Incidents.change_incident(incident_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"incident" => incident_params}, socket) do
    case Incidents.create_incident(socket.assigns.blog, incident_params) do
      {:ok, incident} ->
        {:noreply,
          socket
          |> put_flash(:info, "Incident created successfully")
          |> push_redirect(to: Routes.incident_edit_path(socket, :edit, socket.assigns.blog, incident))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

end

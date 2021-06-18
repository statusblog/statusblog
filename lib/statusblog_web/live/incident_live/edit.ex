defmodule StatusblogWeb.IncidentLive.Edit do
  use StatusblogWeb, :live_view

  alias Statusblog.Incidents
  alias Statusblog.Incidents.IncidentUpdate
  alias StatusblogWeb.MountHelpers

  @impl true
  def mount(%{"incident_id" => incident_id} = params, session, socket) do
    {:ok,
      socket
      |> MountHelpers.assign_defaults(params, session)
      |> assign(:menu, :incidents)
      |> assign(:incident, Incidents.get_incident!(incident_id))
      |> assign(:incident_updates, Incidents.list_incident_updates(incident_id))
      |> assign(:changeset, Incidents.change_incident_update(%IncidentUpdate{}))}
  end

  @impl true
  def handle_event("validate", %{"incident_update" => incident_update_params}, socket) do
    changeset =
      %IncidentUpdate{}
      |> Incidents.change_incident_update(incident_update_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"incident_update" => incident_update_params}, socket) do
    case Incidents.create_incident_update(socket.assigns.incident, incident_update_params) do
      {:ok, _incident_update} ->
        {:noreply,
          socket
          |> put_flash(:info, "Updated incident successfully")
          |> push_redirect(to: Routes.incident_edit_path(socket, :edit, socket.assigns.blog, socket.assigns.incident))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp status_options() do
    Ecto.Enum.values(IncidentUpdate, :status)
    |> Enum.map(&({status_option_display(&1), &1}))
  end

  defp status_option_display(status) do
    status
    |> Atom.to_string()
    |> String.replace("_", " ")
    |> String.capitalize()
  end
end

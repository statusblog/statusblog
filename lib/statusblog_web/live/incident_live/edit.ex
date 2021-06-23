defmodule StatusblogWeb.IncidentLive.Edit do
  use StatusblogWeb, :live_view

  alias Statusblog.Components
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
      |> assign_changeset()}
  end

  defp assign_changeset(socket) do
    changeset =
      Incidents.change_incident_update(%IncidentUpdate{})
      |> Ecto.Changeset.put_change(:status, socket.assigns.incident.status)
      |> Ecto.Changeset.put_embed(:components, default_components(socket))

    assign(socket, :changeset, changeset)
  end

  defp default_components(socket) do
    blog_id = socket.assigns.blog.id
    incident_updates = socket.assigns.incident_updates

    Components.list_components(blog_id)
    |> Enum.map(fn c ->
      %{id: c.id, status: c.status, name: c.name, selected: default_component_selected(c, incident_updates)}
    end)
  end

  defp default_component_selected(_component, []), do: false
  defp default_component_selected(component, [iu | _]) do
    Enum.any?(iu.components, fn c -> c.selected && c.id == component.id end)
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

  defp update_time(%IncidentUpdate{} = incident_update) do
    hour_min = Timex.format!( incident_update.inserted_at, "%H:%M", :strftime)
    time_ago = Timex.from_now(incident_update.inserted_at)
    "#{time_ago} (#{hour_min} UTC)"
  end

end

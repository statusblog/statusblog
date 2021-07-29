defmodule StatusblogWeb.IncidentLive.New do
  use StatusblogWeb, :live_view

  alias Statusblog.Components
  alias Statusblog.Incidents
  alias Statusblog.Incidents.Incident
  alias Statusblog.Incidents.IncidentUpdate
  alias StatusblogWeb.MountHelpers

  @impl true
  def mount(params, session, socket) do
    {:ok,
     socket
     |> MountHelpers.assign_defaults(params, session)
     |> assign(:menu, :incidents)
     |> assign(:page_title, "New incident")
     |> assign_changeset()}
  end

  defp assign_changeset(socket) do
    changeset =
      Incidents.change_incident(%Incident{})
      |> Ecto.Changeset.put_assoc(:incident_updates, [incident_update_changeset(socket)])

    assign(socket, :changeset, changeset)
  end

  defp incident_update_changeset(socket) do
    Incidents.change_incident_update(%IncidentUpdate{})
    |> Ecto.Changeset.put_embed(:components, default_components(socket))
  end

  defp default_components(socket) do
    blog_id = socket.assigns.blog.id

    Components.list_components(blog_id)
    |> Enum.map(fn c ->
      %{id: c.id, status: c.status, name: c.name, selected: false}
    end)
  end

  @impl true
  def handle_event("validate", %{"incident" => incident_params}, socket) do
    changeset =
      %Incident{}
      |> Incidents.change_incident(copy_status_to_incident(incident_params))
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"incident" => incident_params}, socket) do
    case Incidents.create_incident(socket.assigns.blog, copy_status_to_incident(incident_params)) do
      {:ok, incident} ->
        {:noreply,
         socket
         |> put_flash(:info, "Incident created successfully")
         |> push_redirect(
           to: Routes.incident_edit_path(socket, :edit, socket.assigns.blog, incident)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp copy_status_to_incident(incident_params) do
    Map.put_new(
      incident_params,
      "status",
      get_in(incident_params, ["incident_updates", "0", "status"])
    )
  end
end

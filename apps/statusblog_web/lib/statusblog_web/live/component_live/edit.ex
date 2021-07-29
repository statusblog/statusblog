defmodule StatusblogWeb.ComponentLive.Edit do
  use StatusblogWeb, :live_view

  alias Statusblog.Components
  alias StatusblogWeb.MountHelpers

  @impl true
  def mount(%{"id" => id} = params, session, socket) do
    {:ok,
     socket
     |> MountHelpers.assign_defaults(params, session)
     |> assign(:menu, :components)
     |> assign(:page_title, "Edit component")
     |> assign(:component, Components.get_component!(id))}
  end
end

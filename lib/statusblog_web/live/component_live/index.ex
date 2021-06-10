defmodule StatusblogWeb.ComponentLive.Index do
  use StatusblogWeb, :live_view

  alias Statusblog.Components
  alias Statusblog.Components.Component

  @impl true
  def mount(%{"blog_id" => blog_id}, _session, socket) do
    # todo: validate blog_id is valid
    {:ok, assign(socket, :components, Components.list_components(blog_id))}
  end

end

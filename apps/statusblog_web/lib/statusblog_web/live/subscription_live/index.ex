defmodule StatusblogWeb.SubscriptionLive.Index do
  use StatusblogWeb, :live_view

  alias Statusblog.Subscriptions
  alias StatusblogWeb.MountHelpers

  @impl true
  def mount(params, session, socket) do
    {:ok,
      socket
      |> MountHelpers.assign_defaults(params, session)
      |> assign_subscriptions()
      |> assign(:page_title, "Subscribers")
      |> assign(:menu, :subscriptions)}
  end

  defp assign_subscriptions(socket) do
    socket
    |> assign(:subscriptions, Subscriptions.list_subscriptions(socket.assigns.blog.id))
  end

end

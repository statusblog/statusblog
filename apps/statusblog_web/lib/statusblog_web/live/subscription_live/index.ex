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
      |> assign(:menu, :subscriptions)
      |> assign(:confirm_delete_subscription_id, nil)}
  end

  defp assign_subscriptions(socket) do
    socket
    |> assign(:subscriptions, Subscriptions.list_subscriptions(socket.assigns.blog.id))
  end

  @impl true
  def handle_event("remove", %{"id" => subscription_id}, socket) do
    id = String.to_integer(subscription_id)
    {[subscription_to_delete], subscriptions} = Enum.split_with(socket.assigns.subscriptions, fn x -> x.id == id end)
    {:ok, _} = Subscriptions.delete_subscription(subscription_to_delete)

    {:noreply,
      assign(socket, :subscriptions, subscriptions)}
  end

  @impl true
  def handle_event("resend", %{"id" => subscription_id}, socket) do
    id = String.to_integer(subscription_id)
    subscription = Enum.find(socket.assigns.subscriptions, fn s -> s.id == id end)
    Subscriptions.deliver_email_confirmation_instructions(subscription)

    {:noreply,
      put_flash(socket, :info, "Confirmation email sent")}
  end

end

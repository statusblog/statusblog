defmodule StatusblogWeb.SubscriptionLive.New do
  use StatusblogWeb, :live_view

  alias StatusblogWeb.MountHelpers
  alias Statusblog.Subscriptions
  alias Statusblog.Subscriptions.Subscription

  @impl true
  def mount(params, session, socket) do
    {:ok,
      socket
      |> MountHelpers.assign_defaults(params, session)
      |> assign(:menu, :subscriptions)
      |> assign(:page_title, "New subscriber")
      |> assign(:changeset, Subscriptions.change_subscription(%Subscription{}))}
  end

  @impl true
  def handle_event("validate", %{"subscription" => subscription_params}, socket) do
    changeset =
      %Subscription{}
      |> Subscriptions.change_subscription(subscription_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"subscription" => subscription_params}, socket) do
    case Subscriptions.create_subscription(socket.assigns.blog, subscription_params) do
      {:ok, _subscription} ->
        {:noreply,
          socket
          |> put_flash(:info, "Subscriber added successfully")
          |> push_redirect(to: Routes.subscription_index_path(socket, :index, socket.assigns.blog))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

end

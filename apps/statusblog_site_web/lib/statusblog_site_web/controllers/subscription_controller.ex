defmodule StatusblogSiteWeb.SubscriptionController do
  use StatusblogSiteWeb, :controller
  alias Statusblog.Subscriptions

  def create(conn, %{"subscription" => subscriber_params}) do
    blog = conn.assigns[:current_blog]
    case Subscriptions.create_subscription(blog, subscriber_params) do
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Failed to create subscription")
        |> redirect(to: Routes.page_path(conn, :index))

      {:ok, subscription} ->
        {:ok, _} = Subscriptions.deliver_email_confirmation_instructions(subscription)

        conn
        |> put_flash(:info, "Please check your email inbox and confirm your subscription")
        |> redirect(to: Routes.page_path(conn, :index))

    end

  end
end

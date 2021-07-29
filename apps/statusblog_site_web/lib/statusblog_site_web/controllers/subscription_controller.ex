defmodule StatusblogSiteWeb.SubscriptionController do
  use StatusblogSiteWeb, :controller
  alias Statusblog.Subscriptions

  def create(conn, %{"subscription" => subscriber_params}) do
    # TODO: check if already exists!

    blog = conn.assigns[:current_blog]

    case Subscriptions.create_subscription(blog, subscriber_params) do
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Failed to create subscription")
        |> redirect(to: Routes.page_path(conn, :index))

      {:ok, subscription} ->
        {:ok, _} =
          Statusblog.Emails.subscription_confirmation(subscription, blog)
          |> Statusblog.Mailer.deliver_better()

        conn
        |> put_flash(:info, "Please check your email inbox and confirm your subscription")
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def confirm(conn, %{"token" => token}) do
    blog = conn.assigns[:current_blog]

    case Subscriptions.confirm_subscription(blog, token) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Email successfully verified")
        # should we explicitly set full url here?
        |> redirect(to: "/")

      :error ->
        conn
        |> put_flash(:error, "Email confirmation link is invalid or has expired")
        |> redirect(to: "/")
    end
  end

  def unsubscribe(conn, %{"token" => token}) do
    blog = conn.assigns[:current_blog]

    case Subscriptions.unsubscribe_subscription(blog, token) do
      {:ok, _} ->
        conn
        |> put_flash(
          :info,
          "You have been successfully unsubscribed and will not receive any further notifications."
        )
        # should we explicitly set full url here?
        |> redirect(to: "/")

      :error ->
        conn
        |> put_flash(:error, "Unknown error during unsubscribe, please try again later")
        |> redirect(to: "/")
    end
  end
end

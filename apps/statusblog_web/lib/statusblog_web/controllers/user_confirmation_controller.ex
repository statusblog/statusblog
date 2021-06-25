defmodule StatusblogWeb.UserConfirmationController do
  use StatusblogWeb, :controller

  alias Statusblog.Accounts

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, _params) do # %{"user" => %{"email" => email}}) do
    Accounts.deliver_user_confirmation_instructions(
      conn.assigns[:current_user],
      &Routes.user_confirmation_url(conn, :confirm, &1)
    )

    conn
    |> put_flash(:info, "Confirmation email sent.")
    |> redirect(to: Routes.user_confirmation_path(conn, :new))
  end

  # Do not log in the user after confirmation to avoid a
  # leaked token giving the user access to the account.
  def confirm(conn, %{"token" => token}) do
    case Accounts.confirm_user(token) do
      {:ok, _} ->
        conn = put_flash(conn, :info, "Email successfully verified.")
        case conn.assigns do
          %{current_user: %{}} ->
            redirect(conn, to: "/")

          %{} ->
            redirect(conn, to: Routes.user_session_path(conn, :new))
        end

      :error ->
        # If there is a current user and the account was already confirmed,
        # then odds are that the confirmation link was already visited, either
        # by some automation or by the user themselves, so we redirect without
        # a warning message.
        case conn.assigns do
          %{current_user: %{confirmed_at: confirmed_at}} when not is_nil(confirmed_at) ->
            redirect(conn, to: "/")

          %{} ->
            conn
            |> put_flash(:error, "User confirmation link is invalid or it has expired.")
            |> redirect(to: Routes.user_session_path(conn, :new))
        end
    end
  end
end

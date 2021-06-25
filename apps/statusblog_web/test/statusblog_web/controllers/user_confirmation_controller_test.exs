defmodule StatusblogWeb.UserConfirmationControllerTest do
  use StatusblogWeb.ConnCase, async: true

  alias Statusblog.Accounts
  alias Statusblog.Repo
  import Statusblog.AccountsFixtures

  setup do
    %{user: user_fixture()}
  end

  describe "GET /users/confirm" do
    test "renders the confirmation page if logged in, not confirmed", %{conn: conn, user: user} do
      conn =
        log_in_user(conn, user)
        |> get(Routes.user_confirmation_path(conn, :new))

      response = html_response(conn, 200)
      assert response =~ "Resend confirmation email"
    end

    test "redirects from confirmation page if not logged in", %{conn: conn} do
      conn = get(conn, Routes.user_confirmation_path(conn, :new))
      assert redirected_to(conn) == "/users/log_in"
    end

    test "redirects from confirmation page if confirmed", %{conn: conn, user: user} do
      user = Repo.update!(Accounts.User.confirm_changeset(user))
      conn =
        log_in_user(conn, user)
        |> get(Routes.user_confirmation_path(conn, :new))

      assert redirected_to(conn) == "/"
    end
  end

  describe "POST /users/confirm" do
    @tag :capture_log
    test "sends a new confirmation token", %{conn: conn, user: user} do
      conn =
        log_in_user(conn, user)
        |> post(Routes.user_confirmation_path(conn, :create), %{})

      assert redirected_to(conn) == "/users/confirm"
      assert get_flash(conn, :info) =~ "Confirmation"
      assert Repo.get_by!(Accounts.UserToken, user_id: user.id, context: "confirm")
    end
  end

  describe "GET /users/confirm/:token" do
    test "confirms the given token once", %{conn: conn, user: user} do
      token =
        extract_user_token(fn url ->
          Accounts.deliver_user_confirmation_instructions(user, url)
        end)

      conn = get(conn, Routes.user_confirmation_path(conn, :confirm, token))
      assert redirected_to(conn) == "/users/log_in"
      assert get_flash(conn, :info) =~ "Email successfully verified"
      assert Accounts.get_user!(user.id).confirmed_at
      refute get_session(conn, :user_token)
      assert Repo.all(Accounts.UserToken) == []

      # When not logged in
      conn = get(conn, Routes.user_confirmation_path(conn, :confirm, token))
      assert redirected_to(conn) == "/users/log_in"
      assert get_flash(conn, :error) =~ "User confirmation link is invalid or it has expired"

      # When logged in
      conn =
        build_conn()
        |> log_in_user(user)
        |> get(Routes.user_confirmation_path(conn, :confirm, token))

      assert redirected_to(conn) == "/"
      refute get_flash(conn, :error)
    end

    test "does not confirm email with invalid token", %{conn: conn, user: user} do
      conn = get(conn, Routes.user_confirmation_path(conn, :confirm, "oops"))
      assert redirected_to(conn) == "/users/log_in"
      assert get_flash(conn, :error) =~ "User confirmation link is invalid or it has expired"
      refute Accounts.get_user!(user.id).confirmed_at
    end
  end
end

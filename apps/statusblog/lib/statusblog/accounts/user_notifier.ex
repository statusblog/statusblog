defmodule Statusblog.Accounts.UserNotifier do
  import Swoosh.Email
  alias Statusblog.Mailer

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    confirmation_instructions_email(user, url)
    |> Mailer.deliver_better()
  end

  defp confirmation_instructions_email(user, url) do
    new()
    |> to(user.email)
    # todo - load from config
    |> from("noreply@statusblog.io")
    |> subject("Verify your Statusblog email address")
    |> text_body("""

    Hi #{user.email},

    You can confirm your account by visiting the URL below:

    #{url}

    If you didn't create an account with us, please ignore this.

    """)
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    reset_password_instructions(user, url)
    |> Mailer.deliver_better()
  end

  defp reset_password_instructions(user, url) do
    new()
    |> to(user.email)
    # todo - load from config
    |> from("noreply@statusblog.io")
    |> subject("Confirm your email")
    |> text_body("""

    Hi #{user.email},

    You can reset your password by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    """)
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    update_email_instructions(user, url)
    |> Mailer.deliver_better()
  end

  defp update_email_instructions(user, url) do
    new()
    |> to(user.email)
    # todo - load from config
    |> from("noreply@statusblog.io")
    |> subject("Confirm your email")
    |> text_body("""

    Hi #{user.email},

    You can change your email by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    """)
  end
end

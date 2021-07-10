defmodule Statusblog.Accounts.UserNotifier do
  import Swoosh.Email
  alias Statusblog.Mailer

  # For simplicity, this module simply logs messages to the terminal.
  # You should replace it by a proper email or notification tool, such as:
  #
  #   * Swoosh - https://hexdocs.pm/swoosh
  #   * Bamboo - https://hexdocs.pm/bamboo
  #
  defp deliver(email) do
    require Logger
    Logger.debug("========\n#{email.text_body}\n=======")
    case Mailer.deliver(email) do
      :ok -> {:ok, email}
      {:ok, _} -> {:ok, email}
      any ->
        Logger.warn("Failed to deliver email.\nResult: #{IO.inspect(any)}")
        any
    end
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    confirmation_instructions_email(user, url)
    |> deliver()
  end

  defp confirmation_instructions_email(user, url) do
    new()
    |> to(user.email)
    # todo - load from config
    |> from("noreply@statusblog.io")
    |> subject("Confirm your email")
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
    |> deliver()
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
    |> deliver()
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

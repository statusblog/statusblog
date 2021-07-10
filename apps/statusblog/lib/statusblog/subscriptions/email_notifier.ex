defmodule Statusblog.Subscriptions.EmailNotifier do
  import Swoosh.Email
  alias Statusblog.Mailer

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
  def deliver_confirmation_instructions(subscription, url) do
    confirmation_instructions_email(subscription, url)
    |> deliver()
  end

  defp confirmation_instructions_email(subscription, url) do
    new()
    |> to(subscription.email)
    # todo - load from config
    |> from("noreply@statusblog.io")
    # todo: could prefix with [blog_name]
    |> subject("Confirm your email")
    |> text_body("""

    Hi #{subscription.email},

    You can confirm your subscription by visiting the URL below:

    #{url}

    """)
  end
end

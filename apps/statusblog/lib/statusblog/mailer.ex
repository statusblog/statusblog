defmodule Statusblog.Mailer do
  use Swoosh.Mailer, otp_app: :statusblog

  def deliver_better(email) do
    require Logger
    Logger.debug("========\n#{email.text_body}\n=======")

    case deliver(email) do
      {:ok, _} ->
        {:ok, email}

      any ->
        Sentry.capture_message("failed_to_deliver_email", extra: %{email: email, result: any})
        any
    end
  end
end

defmodule Statusblog.Subscriptions.EmailNotifier do
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
    Statusblog.Emails.subscription_confirmation_email(subscription, url)
    |> deliver()
  end
end

defmodule Statusblog.Subscriptions.EmailNotifier do
 # For simplicity, this module simply logs messages to the terminal.
  # You should replace it by a proper email or notification tool, such as:
  #
  #   * Swoosh - https://hexdocs.pm/swoosh
  #   * Bamboo - https://hexdocs.pm/bamboo
  #
  defp deliver(to, body) do
    require Logger
    Logger.debug(body)
    {:ok, %{to: to, body: body}}
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(subscription, url) do
    deliver(subscription.email, """

    ==============================

    Hi #{subscription.email},

    You can confirm your subscription by visiting the URL below:

    #{url}

    ==============================
    """)
  end
end

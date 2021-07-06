defmodule Statusblog.SubscriptionsFixtures do
  alias Statusblog.BlogsFixtures

  def unique_email, do: "user#{System.unique_integer()}@example.com"

  def subscription_fixture(attrs \\ %{}) do
    {:ok, subscription} =
      attrs
      |> Enum.into(%{
        email: unique_email(),
      })
      |> create_subscription()

    subscription
  end

  defp create_subscription(attrs), do: Statusblog.Subscriptions.create_subscription(BlogsFixtures.blog_fixture(), attrs)
end

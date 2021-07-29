defmodule Statusblog.SubscriptionsFixtures do
  alias Statusblog.BlogsFixtures

  def unique_email, do: "user#{System.unique_integer()}@example.com"

  def subscription_fixture(), do: subscription_fixture(BlogsFixtures.blog_fixture())

  def subscription_fixture(blog, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        email: unique_email()
      })

    {:ok, subscription} = Statusblog.Subscriptions.create_subscription(blog, attrs)

    subscription
  end
end

defmodule Statusblog.SubscriptionsTest do
  use Statusblog.DataCase

  alias Statusblog.Subscriptions

  describe "subscriptions" do
    alias Statusblog.Subscriptions.Subscription

    import Statusblog.SubscriptionsFixtures
    import Statusblog.BlogsFixtures

    @invalid_attrs %{email: nil}

    test "list_subscriptions/1 returns all subscriptions" do
      subscription = subscription_fixture()
      assert Subscriptions.list_subscriptions(subscription.blog_id) == [subscription]
    end

    test "get_subscription!/1 returns the subscription with given id" do
      subscription = subscription_fixture()
      assert Subscriptions.get_subscription!(subscription.id) == subscription
    end

    test "create_subscription/1 with valid data creates a subscription" do
      valid_attrs = %{email: "some@email.com"}

      assert {:ok, %Subscription{} = subscription} =
               Subscriptions.create_subscription(blog_fixture(), valid_attrs)

      assert subscription.email == "some@email.com"
    end

    test "create_subscription/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Subscriptions.create_subscription(blog_fixture(), @invalid_attrs)
    end

    test "create_subscription/1 validates email uniqueness" do
      %{blog_id: blog_id, email: email} = subscription_fixture()
      blog = Statusblog.Blogs.get_blog!(blog_id)
      {:error, changeset} = Subscriptions.create_subscription(blog, %{email: email})
      assert "has already been taken" in errors_on(changeset).email

      # Now try with the upper cased email too, to check that email case is ignored.
      {:error, changeset} =
        Subscriptions.create_subscription(blog, %{email: String.upcase(email)})

      assert "has already been taken" in errors_on(changeset).email
    end

    test "update_subscription/2 with valid data updates the subscription" do
      subscription = subscription_fixture()
      update_attrs = %{email: "someupdated@email.com"}

      assert {:ok, %Subscription{} = subscription} =
               Subscriptions.update_subscription(subscription, update_attrs)

      assert subscription.email == "someupdated@email.com"
    end

    test "update_subscription/2 with invalid data returns error changeset" do
      subscription = subscription_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Subscriptions.update_subscription(subscription, @invalid_attrs)

      assert subscription == Subscriptions.get_subscription!(subscription.id)
    end

    test "delete_subscription/1 deletes the subscription" do
      subscription = subscription_fixture()
      assert {:ok, %Subscription{}} = Subscriptions.delete_subscription(subscription)
      assert_raise Ecto.NoResultsError, fn -> Subscriptions.get_subscription!(subscription.id) end
    end

    test "change_subscription/1 returns a subscription changeset" do
      subscription = subscription_fixture()
      assert %Ecto.Changeset{} = Subscriptions.change_subscription(subscription)
    end
  end
end

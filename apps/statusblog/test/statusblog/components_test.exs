defmodule Statusblog.ComponentsTest do
  use Statusblog.DataCase

  alias Statusblog.Components

  describe "components" do
    alias Statusblog.Components.Component

    import Statusblog.ComponentsFixtures
    import Statusblog.BlogsFixtures

    @invalid_attrs %{
      description: nil,
      display_uptime: nil,
      name: nil,
      position: nil,
      start_date: nil,
      status: nil
    }

    test "list_components/1 returns all components" do
      component = component_fixture()
      [found_component] = Components.list_components(component.blog_id)
      assert component.id == found_component.id
    end

    test "get_component!/1 returns the component with given id" do
      component = component_fixture()
      assert Components.get_component!(component.id).id == component.id
    end

    test "create_component/1 with valid data creates a component" do
      valid_attrs = %{
        description: "some description",
        display_uptime: true,
        name: "some name",
        position: 42,
        start_date: ~D[2021-06-09],
        status: :operational
      }

      assert {:ok, %Component{} = component} =
               Components.create_component(blog_fixture(), valid_attrs)

      assert component.description == "some description"
      assert component.display_uptime == true
      assert component.name == "some name"
      assert component.start_date == ~D[2021-06-09]
      assert component.status == :operational
      [component_update] = component.component_updates
      assert component_update.status == :operational
    end

    # test "create_component/1 with duplicate positions" do
    #   valid_attrs = %{description: "some description", display_uptime: true, name: "some name", position: 42, start_date: ~D[2021-06-09], status: :operational}

    #   assert {:ok, %Component{}} = Components.create_component(blog_fixture(), valid_attrs)
    #   assert_raise Ecto.ConstraintError, fn ->
    #     Components.create_component(blog_fixture(), valid_attrs)
    #   end

    #   assert {:ok, %Component{}} = Components.create_component(blog_fixture(), %{valid_attrs | position: 41})
    # end

    test "create_component/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Components.create_component(blog_fixture(), @invalid_attrs)
    end

    test "update_component/2 with valid data updates the component" do
      component = component_fixture()

      update_attrs = %{
        description: "some updated description",
        display_uptime: false,
        name: "some updated name",
        position: 43,
        start_date: ~D[2021-06-10],
        status: :degraded_performance
      }

      assert {:ok, %Component{} = component} =
               Components.update_component(component, update_attrs)

      assert component.description == "some updated description"
      assert component.display_uptime == false
      assert component.name == "some updated name"
      assert component.start_date == ~D[2021-06-10]
      assert component.status == :degraded_performance
      [this_component_update, _init_component_update] = component.component_updates
      assert this_component_update.status == :degraded_performance
    end

    test "update_component/2 with invalid data returns error changeset" do
      component = component_fixture()
      assert {:error, %Ecto.Changeset{}} = Components.update_component(component, @invalid_attrs)
    end

    test "update_component/2 with invalid status returns error changeset" do
      component = component_fixture()
      assert {:error, %Ecto.Changeset{}} = Components.update_component(component, %{status: :foo})
    end

    test "update_component/2 with invalid date returns error changeset" do
      component = component_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Components.update_component(component, %{start_date: ~D"3000-01-01"})
    end

    test "delete_component/1 deletes the component" do
      component = component_fixture()
      assert {:ok, %Component{}} = Components.delete_component(component)
      assert_raise Ecto.NoResultsError, fn -> Components.get_component!(component.id) end
    end

    test "change_component/1 returns a component changeset" do
      component = component_fixture()
      assert %Ecto.Changeset{} = Components.change_component(component)
    end
  end

  describe "component uptime" do
    alias Statusblog.Components.{Component, ComponentUpdate}

    import Statusblog.ComponentsFixtures

    test "get_component_uptime/2 returns correct uptime for new component" do
      component = component_fixture(%{start_date: Date.utc_today()})
      uptime = Components.get_component_uptime(component)
      assert uptime.total_percent == 100.0

      [today | rest] = Enum.reverse(uptime.days)
      assert today.operational_seconds == 86400
      assert today.date == Date.utc_today()

      [yesterday | _rest] = rest
      assert yesterday.operational_seconds == 0
      assert yesterday.date == Date.add(Date.utc_today(), -1)
    end

    test "get_component_uptime/4 returns correct uptime for new component" do
      now = ~N[2021-07-02 05:20:07]
      start_date = ~D[2021-07-01]

      uptime = Components.get_component_uptime(1, [], start_date, 90, now)
      assert uptime.total_percent == 100.0

      [today | _rest] = Enum.reverse(uptime.days)
      assert today.operational_seconds == 86400
    end

    test "get_component_uptime/4 returns correct uptime for component with period of major_outage" do
      now = ~N[2021-07-02 05:20:07]
      start_date = ~D[2021-07-01]

      hour_ago_update = %ComponentUpdate{
        status: :major_outage,
        inserted_at: NaiveDateTime.add(now, -3600)
      }

      uptime = Components.get_component_uptime(1, [hour_ago_update], start_date, 90, now)
      assert uptime.total_percent == 97.91

      [today | _rest] = Enum.reverse(uptime.days)
      assert today.major_outage_seconds == 3600
      assert today.operational_seconds == 82800
    end
  end
end

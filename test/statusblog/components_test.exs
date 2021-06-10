defmodule Statusblog.ComponentsTest do
  use Statusblog.DataCase

  alias Statusblog.Components

  describe "components" do
    alias Statusblog.Components.Component

    import Statusblog.ComponentsFixtures
    import Statusblog.BlogsFixtures

    @invalid_attrs %{description: nil, display_uptime: nil, name: nil, position: nil, start_date: nil, status: nil}

    test "list_components/0 returns all components" do
      component = component_fixture()
      assert Components.list_components() == [component]
    end

    test "get_component!/1 returns the component with given id" do
      component = component_fixture()
      assert Components.get_component!(component.id) == component
    end

    test "create_component/1 with valid data creates a component" do
      valid_attrs = %{description: "some description", display_uptime: true, name: "some name", position: 42, start_date: ~D[2021-06-09], status: :operational, blog_id: blog_fixture().id}

      assert {:ok, %Component{} = component} = Components.create_component(valid_attrs)
      assert component.description == "some description"
      assert component.display_uptime == true
      assert component.name == "some name"
      assert component.position == 42
      assert component.start_date == ~D[2021-06-09]
      assert component.status == :operational
    end

    test "create_component/1 with duplicate positions" do
      valid_attrs = %{description: "some description", display_uptime: true, name: "some name", position: 42, start_date: ~D[2021-06-09], status: :operational, blog_id: blog_fixture().id}

      assert {:ok, %Component{}} = Components.create_component(valid_attrs)
      assert_raise Ecto.ConstraintError, fn ->
        Components.create_component(valid_attrs)
      end

      assert {:ok, %Component{}} = Components.create_component(%{valid_attrs | position: 41})
    end

    test "create_component/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Components.create_component(@invalid_attrs)
    end

    test "update_component/2 with valid data updates the component" do
      component = component_fixture()
      update_attrs = %{description: "some updated description", display_uptime: false, name: "some updated name", position: 43, start_date: ~D[2021-06-10], status: :degraded_performance}

      assert {:ok, %Component{} = component} = Components.update_component(component, update_attrs)
      assert component.description == "some updated description"
      assert component.display_uptime == false
      assert component.name == "some updated name"
      assert component.position == 43
      assert component.start_date == ~D[2021-06-10]
      assert component.status == :degraded_performance
    end

    test "update_component/2 with invalid data returns error changeset" do
      component = component_fixture()
      assert {:error, %Ecto.Changeset{}} = Components.update_component(component, @invalid_attrs)
      assert component == Components.get_component!(component.id)
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
end

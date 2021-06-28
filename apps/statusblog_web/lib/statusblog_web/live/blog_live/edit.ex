defmodule StatusblogWeb.BlogLive.Edit do
  use StatusblogWeb, :live_view

  alias Statusblog.Blogs
  alias StatusblogWeb.MountHelpers

  @impl true
  def mount(params, session, socket) do
    {:ok,
      socket
      |> MountHelpers.assign_defaults(params, session)
      |> assign(:menu, :blog_info)
      |> assign(:page_title, "Edit blog")
      |> assign_changeset()}
  end

  defp assign_changeset(socket) do
    socket
    |> assign(:changeset, Blogs.change_blog(socket.assigns.blog))
  end

  defp domain_set(f), do: String.length(input_value(f, :domain) || "") > 0

  @impl true
  def handle_event("validate", %{"blog" => blog_params}, socket) do
    changeset =
      socket.assigns.blog
      |> Blogs.change_blog(blog_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"blog" => blog_params}, socket) do
    case Blogs.update_blog(socket.assigns.blog, blog_params) do
      {:ok, _blog} ->
        {:noreply,
         socket
         |> put_flash(:info, "Blog updated successfully")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end

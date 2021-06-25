defmodule StatusblogWeb.BlogLive.New do
  use StatusblogWeb, :live_view_no_sidebar

  alias Statusblog.Blogs
  alias Statusblog.Blogs.Blog
  alias StatusblogWeb.MountHelpers

  @impl true
  def mount(_params, session, socket) do
    {:ok,
      socket
      |> MountHelpers.assign_current_user(session)
      |> assign(:changeset, Blogs.change_blog(%Blog{}))}
  end

  @impl true
  def handle_event("validate", %{"blog" => blog_params}, socket) do
    changeset =
      %Blog{}
      |> Blogs.change_blog(blog_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"blog" => blog_params}, socket) do
    case Blogs.create_blog(socket.assigns.current_user, blog_params) do
      {:ok, blog} ->
        {:noreply,
          socket
          |> put_flash(:info, "Blog created successfully")
          |> push_redirect(to: Routes.blog_edit_path(socket, :edit, blog))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end

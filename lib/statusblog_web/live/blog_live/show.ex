defmodule StatusblogWeb.BlogLive.Show do
  use StatusblogWeb, :live_view

  alias Statusblog.Blogs

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
      socket
      |> assign(:menu, :blog_info)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    blog = Blogs.get_blog!(id)
    {:noreply,
     socket
     |> assign(:page_title, "Edit blog")
     |> assign(:blog, blog)
     |> assign(:changeset, Blogs.change_blog(blog))}
  end

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

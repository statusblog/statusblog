defmodule StatusblogWeb.SidebarComponent do
  use StatusblogWeb, :live_component

  # @impl update here

  # @impl true
  # def update(assigns, socket) do
  #   IO.puts "hiiii"
  #   IO.inspect assigns
  #   {:ok, socket}
  # end

  # defp nav_item(opts) do
  #   ~E"""

  #   """
  # end

  defp blog_redirect_class(current_blog, blog), do: blog_redirect_class(current_blog == blog)
  defp blog_redirect_class(true), do: "p-2 w-full flex items-center text-lg font-medium bg-gray-50 hover:bg-gray-100"
  defp blog_redirect_class(false), do: "p-2 w-full flex items-center text-lg font-medium hover:bg-gray-100"

  defp redirect_to(socket, blog, :blog_info), do: Routes.blog_edit_path(socket, :edit, blog)
  defp redirect_to(socket, blog, :components), do: Routes.component_index_path(socket, :index, blog)
  defp redirect_to(socket, blog, :incidents), do: Routes.incident_index_path(socket, :index, blog)

  defp mobile_redirect_class(menu, item), do: mobile_redirect_class(menu == item)
  defp mobile_redirect_class(true), do: "bg-gray-100 text-gray-900 group flex items-center px-2 py-2 text-base font-medium rounded-md"
  defp mobile_redirect_class(false), do: "text-gray-600 hover:bg-gray-50 hover:text-gray-900 group flex items-center px-2 py-2 text-base font-medium rounded-md"

  defp desktop_redirect_class(menu, item), do: desktop_redirect_class(menu == item)
  defp desktop_redirect_class(true), do: "bg-gray-100 text-gray-900 group flex items-center px-2 py-2 text-sm font-medium rounded-md"
  defp desktop_redirect_class(false), do: "text-gray-600 hover:bg-gray-50 hover:text-gray-900 group flex items-center px-2 py-2 text-sm font-medium rounded-md"

  defp svg_class(menu, item), do: svg_class(menu == item)
  defp svg_class(true), do: "text-gray-500 mr-3 flex-shrink-0 h-6 w-6"
  defp svg_class(false), do: "text-gray-400 group-hover:text-gray-500 mr-3 flex-shrink-0 h-6 w-6"

end

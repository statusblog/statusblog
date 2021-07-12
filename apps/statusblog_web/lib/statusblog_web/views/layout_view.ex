defmodule StatusblogWeb.LayoutView do
  use StatusblogWeb, :view

  def flash_alert(_, nil), do: nil

  def flash_alert(:info, msg) do
    ~E"""
    <div
      id="info"
      phx-hook="flash"
      x-data="{ show: true }"
      x-show.transition="show"
      x-init="setTimeout(() => show = false, 4000)"
      class="rounded-md border bg-green-50 border-green-300 p-4 fixed z-10 shadow-lg top-4 left-1/2 transform -translate-x-1/2"
    >
      <div class="flex">
        <div class="flex-shrink-0">
          <!-- Heroicon name: solid/check-circle -->
          <svg class="h-5 w-5 text-green-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
          </svg>
        </div>
        <div class="ml-3">
          <h3 class="text-sm font-medium text-green-800">
            <%= msg %>
          </h3>
        </div>
      </div>
    </div>
    """
  end

  def flash_alert(:error, msg) do
    ~E"""
    <div
      id="error"
      phx-hook="flash"
      x-data="{ show: true }"
      x-show.transition="show"
      x-init="setTimeout(() => show = false, 4000)"
      class="rounded-md bg-red-50 border border-red-300 p-4 fixed z-10 shadow-lg top-4 left-1/2 transform -translate-x-1/2"
    >
      <div class="flex">
        <div class="flex-shrink-0">
          <!-- Heroicon name: solid/x-circle -->
          <svg class="h-5 w-5 text-red-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
          </svg>
        </div>
        <div class="ml-3">
          <h3 class="text-sm font-medium text-red-800">
            <%= msg %>
          </h3>
        </div>
      </div>
    </div>
    """
  end

  defp blog_url(blog), do: Statusblog.Blogs.get_blog_base_url!(blog)

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

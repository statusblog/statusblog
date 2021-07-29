defmodule Statusblog.Utils do
  alias Statusblog.Blogs.Blog

  def site_origin_uri(%Blog{} = blog) do
    %URI{
      port: Application.get_env(:statusblog, :site_port),
      host: get_host(blog),
      scheme: Application.get_env(:statusblog, :site_scheme)
    }
  end

  defp get_host(%Blog{} = blog) do
    if blog.domain do
      blog.domain
    else
      site_root_domain = Application.get_env(:statusblog, :site_root_domain)
      "#{blog.subdomain}.#{site_root_domain}"
    end
  end
end

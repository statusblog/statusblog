defmodule Statusblog.Emails.Macros do
  defmacro text_template(name, args \\ []) do
    quote do
      EEx.function_from_file(
        :defp,
        unquote(:"#{name}_txt"),
        unquote(Path.absname("lib/statusblog/emails/#{name}.txt.eex")),
        unquote(args)
      )
    end
  end
end

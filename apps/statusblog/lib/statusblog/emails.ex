defmodule Statusblog.Emails do
  require EEx
  import Swoosh.Email
  import Statusblog.Emails.Macros

  # defmacro text_template(name, assigns \\ []) do
  #   quote do
  #     EEx.function_from_file(:defp, Atom.to_string("#{unquote(name)}_txt"), Path.absname("lib/statusblog/emails/#{unquote(name)}.txt.eex"), unquote(assigns))
  #   end
  # end

  # text_template(:subscription_confirmation_email, [])

  # defmacro text_template(name, args \\ []) do
  #   quote do
  #     EEx.function_from_file(
  #       :defp,
  #       unquote(:"#{name}_txt"),
  #       unquote(Path.absname("lib/statusblog/emails/#{name}.txt.eex")),
  #       unquote(args))
  #   end
  # end

  # @after_compile __MODULE__

  # def __after_compile__(_env, _bytecode) do
  # end

  text_template(:subscription_confirmation_email, [:subscription, :url])

  # EEx.function_from_file(
  #   :defp,
  #   :subscription_confirmation_email_txt,
  #   Path.absname("lib/statusblog/emails/subscription_confirmation_email.txt.eex"),
  #   [:subscription, :url])


  def subscription_confirmation_email(subscription, url) do
    new()
    |> to(subscription.email)
    # todo - load from config
    |> from("noreply@statusblog.io")
    # todo: could prefix with [blog_name]
    |> subject("Confirm your email")
    |> text_body(subscription_confirmation_email_txt(subscription, url))
  end

end

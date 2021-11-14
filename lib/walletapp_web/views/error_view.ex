defmodule WalletappWeb.ErrorView do
  use WalletappWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.html", _assigns) do
  #   "Internal Server Error"
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end

  def render("422.json", %{changeset: changeset}) do
    %{
      status: "failure",
      # this line causes the error
      errors: Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
    }
  end

  def render("400.json", %{message: message}) do
    %{
      status: "failure",
      # this line causes the error
      message: message
    }
  end
end

defmodule WalletappWeb.PageController do
  use WalletappWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

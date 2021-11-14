defmodule WalletappWeb.TransactionController do
  use WalletappWeb, :controller

  alias Walletapp.Wallet

  def index(conn, _params) do
    Wallet.list_transactions()
    |> response_transactions(conn)
  end

  def index_by_user_id(conn, %{"user_id" => user_id}) do
    Wallet.list_transactions_by_user_id(user_id)
    |> response_transactions(conn)
  end

  defp response_transactions(transactions, conn) do
    render(conn, "index.json", %{transactions: transactions})
  end

  def create(conn, %{"transaction" => params}) do
    case Wallet.create_transaction(params) do
      {:ok, transaction} ->
        conn
        |> put_status(:created)
        |> render("show.json", transaction: transaction)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(WalletappWeb.ErrorView)
        |> render("422.json", changeset: changeset)
    end
  end

  def create(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> put_view(WalletappWeb.ErrorView)
    |> render("400.json", message: "transaction field is required")
  end
end

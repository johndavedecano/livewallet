defmodule WalletappWeb.TransactionView do
  use WalletappWeb, :view

  alias WalletappWeb.{TransactionView}

  def render("index.json", %{transactions: transactions}) do
    %{data: render_many(transactions, TransactionView, "show.json")}
  end

  def render("show.json", %{transaction: transaction}) do
    %{
      id: transaction.id,
      user_id: transaction.user_id,
      amount: transaction.amount,
      type: transaction.type,
      description: transaction.description,
      balance: transaction.balance,
      status: transaction.status,
      inserted_at: transaction.inserted_at
    }
  end
end

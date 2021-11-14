defmodule Walletapp.TransactionWorker do
  alias Walletapp.Wallet

  def perform(id) do
    IO.puts("received transaction #{id}")

    try do
      transaction = Wallet.get_transaction!(id)
      balance = Wallet.get_account_balance(transaction.user_id)

      IO.puts(transaction.type)

      if transaction.type == "debit" do
        deduction = 0 + transaction.amount

        if balance < deduction do
          Wallet.update_transaction(transaction, %{status: "failed"})
        else
          latest_balance = balance - transaction.amount

          Wallet.update_transaction(transaction, %{
            status: "completed",
            balance: latest_balance
          })
        end
      else
        latest_balance = balance + transaction.amount

        Wallet.update_transaction(transaction, %{
          status: "completed",
          balance: latest_balance
        })
      end

      Phoenix.PubSub.broadcast(
        Walletapp.PubSub,
        "user:#{transaction.user_id}",
        {__MODULE__}
      )
    catch
      RuntimeError -> {:error, "unable to process"}
    end
  end
end

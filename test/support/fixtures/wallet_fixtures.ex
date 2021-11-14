defmodule Walletapp.WalletFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Walletapp.Wallet` context.
  """

  @doc """
  Generate a transaction.
  """
  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{
        amount: 1000,
        balance: 1000,
        description: "some description",
        type: "credit",
        user_id: 42,
        status: "pending"
      })
      |> Walletapp.Wallet.create_transaction_fixture()

    transaction
  end
end

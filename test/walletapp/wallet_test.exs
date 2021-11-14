defmodule Walletapp.WalletTest do
  use Walletapp.DataCase

  alias Walletapp.Wallet

  import Walletapp.WalletFixtures
  import Walletapp.AccountsFixtures

  describe "transactions" do
    @invalid_attrs %{amount: nil, balance: nil, description: nil, type: nil, user_id: nil}

    test "list_transactions/0 returns all transactions" do
      %{id: user_id} = user_fixture()
      transaction = transaction_fixture(%{user_id: user_id})
      [result | _] = Wallet.list_transactions()
      assert result.id == transaction.id
    end

    test "list_transactions_by_user_id/0 returns all transactions by given user_id" do
      %{id: user_id} = user_fixture()
      transaction = transaction_fixture(%{user_id: user_id})
      [result | _] = Wallet.list_transactions_by_user_id(user_id)
      assert result.id == transaction.id
    end

    test "get_transaction!/1 returns the transaction with given id" do
      %{id: user_id} = user_fixture()
      transaction = transaction_fixture(%{user_id: user_id})
      result = Wallet.get_transaction!(transaction.id)
      assert result.id == transaction.id
    end

    test "get_account_balance/1 returns user account balance" do
      %{id: user_id} = user_fixture()

      transaction_fixture(%{
        amount: 1000,
        description: "some description",
        type: "credit",
        user_id: user_id,
        status: "completed"
      })

      assert Wallet.get_account_balance(user_id) == 1000
    end

    test "get_account_balance/1 returns user account zero balance" do
      %{id: user_id} = user_fixture()
      assert Wallet.get_account_balance(user_id) == 0
    end

    test "create_transaction/1 with valid data creates a transaction" do
      %{id: user_id} = user_fixture()

      valid_attrs = %{
        amount: 1000,
        description: "some description",
        type: "credit",
        user_id: user_id
      }

      Wallet.create_transaction(valid_attrs)
      {:ok, transaction} = Wallet.create_transaction(valid_attrs)
      assert transaction.amount == 1000
      assert transaction.description == "some description"
      assert transaction.type == "credit"
      assert transaction.user_id == user_id
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Wallet.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      %{id: user_id} = user_fixture()
      transaction = transaction_fixture(%{user_id: user_id})

      update_attrs = %{
        amount: 1000,
        description: "some updated description",
        type: "credit"
      }

      assert {:ok, transaction} = Wallet.update_transaction(transaction, update_attrs)
      assert transaction.amount == 1000
      assert transaction.description == "some updated description"
      assert transaction.type == "credit"
      assert transaction.user_id == user_id
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      %{id: user_id} = user_fixture()
      transaction = transaction_fixture(%{user_id: user_id})
      assert {:error, %Ecto.Changeset{}} = Wallet.update_transaction(transaction, @invalid_attrs)
      result = Wallet.get_transaction!(transaction.id)
      assert transaction.id == result.id
    end

    test "delete_transaction/1 deletes the transaction" do
      %{id: user_id} = user_fixture()
      transaction = transaction_fixture(%{user_id: user_id})
      assert {:ok, _} = Wallet.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Wallet.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      %{id: user_id} = user_fixture()
      transaction = transaction_fixture(%{user_id: user_id})
      assert %Ecto.Changeset{} = Wallet.change_transaction(transaction)
    end
  end
end

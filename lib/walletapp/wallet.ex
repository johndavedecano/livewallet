defmodule Walletapp.Wallet do
  @moduledoc """
  The Wallet context.
  """

  import Ecto.Query, warn: false
  alias Walletapp.Repo

  alias Walletapp.Wallet.Transaction

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}, ...]

  """
  def list_transactions do
    Repo.all(Transaction)
  end

  def list_transactions_by_user_id(user_id) do
    Repo.all(
      from(t in Transaction, where: t.user_id == ^user_id, order_by: [desc: t.inserted_at])
    )
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs \\ %{}) do
    transaction = %Transaction{} |> Transaction.changeset(attrs)

    if transaction.valid? do
      Repo.insert(transaction) |> create_queue()
    else
      {:error, transaction}
    end
  end

  def create_transaction_fixture(attrs \\ %{}) do
    transaction = %Transaction{} |> Transaction.changeset_test(attrs)

    if transaction.valid? do
      Repo.insert(transaction) |> create_queue()
    else
      {:error, transaction}
    end
  end

  defp create_queue(transaction) do
    {:ok, t} = transaction

    Exq.enqueue(Exq, "default", Walletapp.TransactionWorker, [t.id])

    transaction
  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{data: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    Transaction.changeset(transaction, attrs)
  end

  def get_account_balance(user_id) do
    balance =
      Repo.one(
        from t in Transaction,
          select: sum(t.amount),
          where: t.user_id == ^user_id and t.status == "completed"
      )

    if is_nil(balance) do
      0
    else
      balance
    end
  end
end

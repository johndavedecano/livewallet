defmodule Walletapp.Wallet.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :amount, :integer
    field :balance, :integer
    field :description, :string
    field :type, :string
    field :status, :string, default: "pending"
    belongs_to :user, Walletapp.Accounts.User

    timestamps()
  end

  def negate_amount(changeset) do
    type = get_change(changeset, :type)
    amount = get_change(changeset, :amount)

    if type == "debit" do
      changeset
      |> put_change(:amount, 0 - amount)
    else
      changeset
    end
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:user_id, :description, :type, :amount])
    |> validate_required([:user_id, :description, :type, :amount])
    |> negate_amount()
  end

  def update_changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:user_id, :description, :type, :amount, :status, :balance])
    |> validate_required([:status, :balance])
  end

  @doc false
  def changeset_test(transaction, attrs) do
    transaction
    |> cast(attrs, [:user_id, :description, :type, :amount, :status, :balance])
    |> validate_required([:user_id, :description, :type, :amount])
  end
end

defmodule Walletapp.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :description, :string
      add :type, :string
      add :amount, :integer
      add :balance, :integer
      add :status, :string
      timestamps()
    end
  end
end

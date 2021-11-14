defmodule WalletappWeb.TransactionControllerTest do
  use WalletappWeb.ConnCase, async: true

  import Walletapp.WalletFixtures
  import Walletapp.AccountsFixtures

  @invalid_attrs %{amount: nil, balance: nil, description: nil, type: nil, user_id: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index transactions" do
    test "lists all transactions", %{conn: conn} do
      conn = get(conn, Routes.transaction_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end

    test "list all transactions by user_id", %{conn: conn} do
      %{id: user_id} = user_fixture()
      transaction = transaction_fixture(%{user_id: user_id})
      conn = get(conn, Routes.transaction_path(conn, :index_by_user_id, user_id))
      [response] = json_response(conn, 200)["data"]
      assert response["id"] == transaction.id
      assert response["type"] == transaction.type
      assert response["amount"] == transaction.amount
      assert response["user_id"] == transaction.user_id
      assert response["description"] == transaction.description
    end
  end

  describe "create transaction" do
    test "create transaction success", %{conn: conn} do
      %{id: user_id} = user_fixture()

      conn =
        post(conn, Routes.transaction_path(conn, :create),
          transaction: %{
            amount: 1000,
            description: "some description",
            type: "credit",
            user_id: user_id
          }
        )

      assert json_response(conn, 201)
    end

    test "create transaction failed", %{conn: conn} do
      conn = post(conn, Routes.transaction_path(conn, :create), %{transaction: @invalid_attrs})

      assert json_response(conn, 422)
    end
  end
end

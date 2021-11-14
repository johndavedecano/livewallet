defmodule WalletappWeb.LiveBalance do
  use WalletappWeb, :live_view

  alias Walletapp.Accounts
  alias Walletapp.Wallet

  def mount(_params, session, socket) do
    %{"user_token" => user_token} = session

    user = Accounts.get_user_by_session_token(user_token)

    balance = Wallet.get_account_balance(user.id)

    current_balance = format_number_to_money(balance)

    transactions = Wallet.list_transactions_by_user_id(user.id)

    WalletappWeb.Endpoint.subscribe("user:#{user.id}")

    {:ok, assign(socket, current_balance: current_balance, transactions: transactions)}
  end

  defp format_number_to_money(number) do
    if is_integer(number) and number > 0 do
      Number.Currency.number_to_currency(number / 100)
    else
      "0.00"
    end
  end

  defp format_date(date) do
    case Timex.format(date, "%Y-%m-%d", :strftime) do
      {:ok, formatted} -> formatted
      {:error, _} -> "invalid date"
    end
  end

  def render(assigns) do
    ~L"""
    <div class="card balance">
      <div class="card-body">
          <h1 class="h1 text-center"><%= @current_balance %></h1>
          <div class="text-center">Current Balance</div>
          <div class="text-center card-actions">
              <div class="button">Withdraw</div>
              <div class="button">Cash-In</div>
          </div>
      </div>
    </div>
    
    <div class="card transactions">
      <div class="card-header">
          Transactions
      </div>
      <div class="card-body">
          <table>
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Description</th>
                  <th>Type</th>
                  <th>Status</th>
                  <th>Amount</th>
                  <th>Balance</th>
                  <th>Date</th>
                </tr>
              </thead>
              <tbody>
                <%= for t <- @transactions do %>
                <tr>
                  <td><%= t.id %></td>
                  <td><%= t.description %></td>
                  <td><%= t.type %></td>
                  <td><%= t.status %></td>
                  <td><%= format_number_to_money(t.amount) %></td>
                  <td><%= format_number_to_money(t.balance) %></td>
                  <td><%= format_date(t.inserted_at) %></td>
                </tr>
                <% end %>
              </tbody>
            </table>
      </div>
    </div>
    """
  end
end

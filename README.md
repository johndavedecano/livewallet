# Walletapp

```
git clone <URL> walletapp
cd walletapp
docker-compose up -d
mix deps.get
mix ecto.create
mix ecto.migrate
mix phx.server
```

# Listing Routes

```
mix phx.routes
```

## Test Live View

Make sure you register an account first.

```
curl --location --request POST 'http://localhost:4000/api/transactions' \
--header 'Content-Type: application/json' \
--data-raw '{
    "transaction": {
        "user_id": 1,
        "amount": 20000,
        "description": "cash in from bank",
        "status": "pending",
        "type": "credit"
    }
}'
```

![My Image](https://github.com/johndavedecano/livewallet/blob/b3859943d4c2c367fc38159be5049a40e75fb860/screenshot.png)

## Unit Test

```
mix test
```

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix

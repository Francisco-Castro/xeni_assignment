# Xeni

The API exposes two endpoints:
- POST `localhost:4000/api/insert` that adds data to the application
- GET `localhost:4000/api/average` that returns the moving average given an specific time or number of elements. For example:

  - [`localhost:4000/api/average?window=last_20_items`](localhost:4000/api/average?window=last_20_items) - should return the moving average of the last 20 items
  - [`localhost:4000/api/average?window=last_1_hour`](localhost:4000/api/average?window=last_1_hour) - should return the moving average of all items that were inserted to the data store in the past hour

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

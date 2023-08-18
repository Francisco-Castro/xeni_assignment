defmodule XeniWeb.FallbackController do
  use Phoenix.Controller

  def call(conn, {:error, error}) do
    json(conn, %{error: error})
  end
end

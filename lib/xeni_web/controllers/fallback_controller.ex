defmodule XeniWeb.FallbackController do
  use Phoenix.Controller

  def call(conn, {:error, %Ecto.Changeset{errors: errors}}) do
    conn |> put_status(:unprocessable_entity) |> json(%{errors: inspect(errors)})
  end

  def call(conn, {:error, :empty_db}) do
    conn |> put_status(:internal_server_error) |> json(%{error: "Our DB looks empty"})
  end

  def call(conn, {:error, error}) do
    conn |> put_status(:bad_request) |> json(%{error: error})
  end
end

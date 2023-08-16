defmodule XeniWeb.RecordController do
  use XeniWeb, :controller
  alias XeniWeb.UrlHelper

  def average(conn, %{"window" => window} = _params) do
    result =
      case UrlHelper.split_string(window) do
        {:items, items} -> make_call(:items, items)
        {:time, time} -> make_call(:time, time)
        error -> error
      end
      |> case do
        {:ok, value} -> %{data: %{moving_average: value}}
        {:error, error} -> %{error: error}
      end

    json(conn, result)
  end

  def average(conn, _params) do
    json(conn, %{error: "Invalid params"})
  end

  defp make_call(:items, items) do
    with {:ok, items} <- UrlHelper.cast_number(items) do
      {:ok, items}
    end
  end

  defp make_call(:time, time) do
    with {:ok, time} <- UrlHelper.cast_number(time) do
      {:ok, time}
    end
  end


end

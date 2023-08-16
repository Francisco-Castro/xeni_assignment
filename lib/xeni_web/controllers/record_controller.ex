defmodule XeniWeb.RecordController do
  use XeniWeb, :controller
  alias XeniWeb.UrlHelper
  alias Xeni.Core.RecordCall

  def average(conn, %{"window" => window} = _params) do
    result =
      case UrlHelper.split_string(window) do
        {:items, items} -> RecordCall.call(:items, items)
        {:time, time} -> RecordCall.call(:time, time)
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
end

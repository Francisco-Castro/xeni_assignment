defmodule XeniWeb.RecordController do
  use XeniWeb, :controller
  use OpenApiSpex.ControllerSpecs
  alias XeniWeb.UrlHelper
  alias Xeni.Core.RecordCall

  alias OpenApiSpex.Schema

  tags ["Records"]
  operation(:insert,
    summary: "Insert a record",
    description: "Insert a record by the given paramaters.",
    request_body: {"User params", "application/json", RecordParams},
    responses: [
      ok: {"Record", "application/json", RecordSpec}
    ]
  )

  def insert(conn, params) do
    result =
      case RecordCall.call(:insert, params) do
        {:ok, value} -> %{data: value}
        {:error, error} -> %{error: error}
      end

    json(conn, result)
  end

  operation(:average,
    summary: "Compute the moving average in a window",
    description: "This call can be use to compute de moving average in a time window or for an amount of latest records",
    parameters: [
      window: [in: :query, type: :string, description: "Time range or number of records used to compute the moving average", example: "last_2_items", required: true]
    ],
    responses: [
      ok: {"Record", "application/json", nil}
    ]
  )

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

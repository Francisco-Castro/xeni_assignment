defmodule XeniWeb.RecordController do
  use XeniWeb, :controller
  use OpenApiSpex.ControllerSpecs
  alias XeniWeb.UrlHelper
  alias Xeni.Core.RecordCall

  action_fallback XeniWeb.FallbackController

  tags(["Records"])

  operation(:insert,
    summary: "Insert a record",
    description: "Insert a record by the given paramaters.",
    request_body: {"User params", "application/json", RecordParams},
    responses: [
      ok: {"Record", "application/json", InsertResponse},
      bad_request: {"Bad request parameters", "application/json", BadRequestParametersForInsert}
    ]
  )

  def insert(conn, params) do
    with {:ok, record} <- RecordCall.call(:insert, params) do
      json(conn, %{data: record})
    end
  end

  operation(:average,
    summary: "Compute the moving average in a window",
    description:
      "This call can be use to compute de moving average in a time window or for an amount of latest records",
    parameters: [
      window: [
        in: :query,
        type: :string,
        description: "Time range or number of records used to compute the moving average",
        example: "last_2_items",
        required: true
      ]
    ],
    responses: [
      ok: {"Record", "application/json", AverageResponse},
      bad_request: {"Bad request parameters", "application/json", BadRequestParametersForAverage}
    ]
  )

  def average(conn, %{"window" => window} = _params) do
    with {items_or_time, integer} when items_or_time in [:items, :time] <-
           UrlHelper.split_string(window),
         {:ok, result} <- RecordCall.call(items_or_time, integer) do
      json(conn, %{data: %{moving_average: result}})
    end
  end

  def average(conn, _params) do
    json(conn, %{error: "Invalid params"})
  end
end

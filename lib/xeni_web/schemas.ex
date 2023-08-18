defmodule RecordParams do
  require OpenApiSpex
  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "RecordParams",
    description: "Params to create a Record",
    type: :object,
    properties: %{
      open: %Schema{type: :float, description: "Open value"},
      high: %Schema{type: :float, description: "High value"},
      low: %Schema{type: :float, description: "Low value"},
      close: %Schema{type: :float, description: "Close value"}
    },
    required: [:open, :high, :low, :close],
    example: %{
      "open" => "10.0",
      "high" => "15.0",
      "low" => "5.0",
      "close" => "11"
    }
  })
end

defmodule AverageResponse do
  require OpenApiSpex
  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "Insert Response",
    description: "Returns the moving average",
    type: :object,
    example: %{
      data: %{moving_average: 55.5}
    }
  })
end

defmodule BadRequestParametersForAverage do
  require OpenApiSpex
  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "Bad request Parameters For Average",
    type: :object,
    example: %{"error" => "Invalid url property. Expected a string of the form last_INTEGER_items or last_INTEGER_hour"}
  })
end

defmodule BadRequestParametersForInsert do
  require OpenApiSpex
  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "Bad request Parameters For Insert",
    type: :object,
    example: %{"error" => "[open: {\"can't be blank\", [validation: :required]}]"}
  })
end

defmodule InsertResponse do
  require OpenApiSpex
  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "Record",
    description: "A record representing open-high-low-close data",
    type: :object,
    properties: %{
      id: %Schema{type: :integer, description: "Record ID"},
      open: %Schema{type: :float, description: "Open value"},
      high: %Schema{type: :float, description: "High value"},
      low: %Schema{type: :float, description: "Low value"},
      close: %Schema{type: :float, description: "Close value"},
      timestamp: %Schema{type: :string, description: "Creation timestamp", format: :"date-time"}
    },
    required: [:open, :high, :low, :close],
    example: %{
      "data" => %{
        "id" => 123,
        "open" => "10.0",
        "high" => "15.0",
        "low" => "5.0",
        "close" => "11",
        "timestamp" => "2017-09-13T10:11:12Z"
      }
    }
  })
end

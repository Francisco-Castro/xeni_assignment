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
      close: %Schema{type: :float, description: "Close value"},
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

defmodule RecordSpec do
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
      "id" => 123,
      "open" => "10.0",
      "high" => "15.0",
      "low" => "5.0",
      "close" => "11",
      "timestamp" => "2017-09-13T10:11:12Z"
    }
  })
end

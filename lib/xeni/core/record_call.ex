defmodule Xeni.Core.RecordCall do
  # alias Xeni.Schemas.Record
  @valid_fields [:open, :high, :low, :close]

  def call(:items, items) do
    with {:ok, items} <- cast_number(items) do
      records = Xeni.Core.Records.latest_records(items)
      result = compute_moving_average(records)
      {:ok, result}
    end
  end

  def call(:time, time) do
    with {:ok, time} <- cast_number(time) do
      {:ok, time}
    end
  end

  defp compute_moving_average(records, fields \\ :open)
  defp compute_moving_average(records, fields) do
    records
    |> Enum.map(fn r -> value_from_fields(r, sanitize_fields(fields)) end)
    |> Enum.sum()
    |> Kernel./(length(records))
    |> round_float()
  end

  defp sanitize_fields(:all), do: sanitize_fields(@valid_fields)
  defp sanitize_fields(valid_field) when valid_field in @valid_fields, do: [valid_field]

  defp sanitize_fields(fields) do
    Enum.reduce(fields, [], fn field, acc ->
      if field in @valid_fields, do: [field | acc], else: acc
    end)
  end

  defp value_from_fields(record, fields) do
    for field <- fields do
      Map.get(record, field)
    end
    |> Enum.sum()
    |> Kernel./(length(fields))
  end

  defp round_float(float) do
    float
    |> Decimal.from_float()
    |> Decimal.round(2)
    |> Decimal.to_float()
  end

  def cast_number(number) do
    case Integer.parse(number) do
      {number, _} -> {:ok, number}
      _ -> {:error, "Invalid casting. Expected a number but received: #{number}"}
    end
  end
end

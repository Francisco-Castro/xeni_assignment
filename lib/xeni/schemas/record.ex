defmodule Xeni.Schemas.Record do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :open, :high, :low, :close, :timestamp]}
  schema "records" do
    field :open, :float
    field :high, :float
    field :low, :float
    field :close, :float
    field :timestamp, :utc_datetime_usec, default: Timex.now()
  end

  @required_fields ~w(open high low close)a
  @optional_fields ~w(timestamp)a

  def changeset(record, attrs) do
    record
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_number(:open, greater_than_or_equal_to: 0)
    |> validate_ohlc()
  end

  defp validate_ohlc(changeset) do
    [low, high, open, close] =
      for field <- [:low, :high, :open, :close], do: get_field(changeset, field)

    with {:high, true} <- {:high, low <= high},
         {:open, true} <- {:open, low <= open and open <= high},
         {:close, true} <- {:close, low <= close and close <= high} do
      changeset
    else
      {:high, false} -> add_error(changeset, :high, "High must be greather or equal to Low")
      {:open, false} -> add_error(changeset, :open, "Open must be in between High and Low")
      {:close, false} -> add_error(changeset, :close, "Close must be in between High and Low")
    end
  end
end

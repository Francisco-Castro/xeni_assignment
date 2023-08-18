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
  end
end

defmodule Xeni.Schemas.RecordTest do
  use Xeni.DataCase
  alias Xeni.Schemas.Record

  describe "changeset/2" do
    test "create a record" do
      params = %{
        close: Enum.random(1..10),
        high: Enum.random(1..10),
        low: Enum.random(1..10),
        open: Enum.random(1..10),
        timestamp: DateTime.utc_now
      }

      changeset = Record.changeset(%Record{}, params)
      assert changeset.valid?

      record = apply_changes(changeset)

      assert record.close == params[:close]
      assert record.high == params[:high]
      assert record.low == params[:low]
      assert record.open == params[:open]
      assert record.timestamp == params[:timestamp]
    end

    test "error: missing required attributes" do
      changeset = Record.changeset(%Record{}, %{})
      refute changeset.valid?

      errors = changeset.errors

      [:open, :high, :low, :close, :timestamp]
      |> Enum.each(fn required_key ->
        assert Keyword.has_key?(errors, required_key)
        assert {"can't be blank", [validation: :required]} = errors[required_key]
      end)
    end
  end
end

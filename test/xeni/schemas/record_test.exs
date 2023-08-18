defmodule Xeni.Schemas.RecordTest do
  use Xeni.DataCase
  alias Xeni.Schemas.Record

  describe "changeset/2" do
    test "create a record" do
      params = %{
        open: 3.33,
        high: 4.44,
        low: 1.11,
        close: 2.22,
        timestamp: Timex.now()
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

    test "error, invalid ohlc High must be >= Low" do
      params = %{
        open: 3.33,
        high: 4.44,
        low: 5.55,
        close: 2.22,
        timestamp: Timex.now()
      }

      changeset = Record.changeset(%Record{}, params)
      refute changeset.valid?
      assert [high: {"High must be greather or equal to Low", []}] = changeset.errors
    end

    test "error, invalid ohlc Open must be in between Low and High" do
      params = %{
        open: 9.00,
        high: 4.00,
        low: 1.00,
        close: 2.00,
        timestamp: Timex.now()
      }

      changeset = Record.changeset(%Record{}, params)
      refute changeset.valid?
      assert [open: {"Open must be in between High and Low", []}] = changeset.errors
    end

    test "error, invalid ohlc Close must be in between Low and High" do
      params = %{
        open: 3.00,
        high: 4.00,
        low: 1.00,
        close: 9.00,
        timestamp: Timex.now()
      }

      changeset = Record.changeset(%Record{}, params)
      refute changeset.valid?
      assert [close: {"Close must be in between High and Low", []}] = changeset.errors
    end

    test "error: missing required attributes" do
      changeset = Record.changeset(%Record{}, %{})
      refute changeset.valid?

      errors = changeset.errors

      [:open, :high, :low, :close]
      |> Enum.each(fn required_key ->
        assert Keyword.has_key?(errors, required_key)
        assert {"can't be blank", [validation: :required]} = errors[required_key]
      end)
    end
  end
end

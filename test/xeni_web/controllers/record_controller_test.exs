defmodule XeniWeb.RecordControllerTest do
  use XeniWeb.ConnCase

  @valid_payload %{
    timestamp: "2023-08-16 02:46:47.018236Z",
    open: 3.33,
    high: 4.44,
    low: 1.11,
    close: 2.22
  }

  describe "POST /insert" do
    test "sucess: insert a record", %{conn: conn} do
      assert %{
               "data" => %{
                 "close" => 2.22,
                 "high" => 4.44,
                 "low" => 1.11,
                 "open" => 3.33,
                 "timestamp" => "2023-08-16T02:46:47.018236Z"
               }
             } =
               post(conn, "/api/insert", @valid_payload)
               |> json_response(201)
    end

    test "error: when having a missing field", %{conn: conn} do
      invalid_payload = @valid_payload |> Map.drop([:high])

      assert %{"errors" => "[high: {\"can't be blank\", [validation: :required]}]"} =
               post(conn, "/api/insert", invalid_payload)
               |> json_response(422)
    end

    test "error: invalid ohlc record", %{conn: conn} do
      invalid_payload = @valid_payload |> Map.put(:open, @valid_payload.high + 0.01)

      assert %{"errors" => "[open: {\"Open must be in between High and Low\", []}]"} =
               post(conn, "/api/insert", invalid_payload)
               |> json_response(422)
    end
  end

  describe "GET /average" do
    test "error: invalid splitting", %{conn: conn} do
      result =
        get(conn, "/api/average?window=invalid_splitting")
        |> json_response(400)

      err_msg =
        "Invalid url property. Expected a string of the form last_INTEGER_items or last_INTEGER_hour"

      assert %{"error" => err_msg} == result
    end

    test "error: invalid url params", %{conn: conn} do
      result =
        get(conn, "/api/average?no_window=invalid_splitting")
        |> json_response(200)

      assert %{"error" => "Invalid params"} == result
    end
  end

  describe "GET /average - items" do
    test "error: no records found", %{conn: conn} do
      result =
        get(conn, "/api/average?window=last_1_items")
        |> json_response(500)

      assert %{
               "error" =>
                 "Internal Server Error. Maybe our DB is empty. Try inserting a record first."
             } == result
    end

    test "error: invalid casting for items", %{conn: conn} do
      invalid_value = "notANumber"

      result =
        get(conn, "/api/average?window=last_#{invalid_value}_items")
        |> json_response(400)

      err_msg = "Invalid casting. Expected a number but received: #{invalid_value}"
      assert %{"error" => err_msg} == result
    end

    test "sucess: return moving average from the latest record", %{conn: conn} do
      [r1, _r2, r3] = generate_records(3)

      assert Timex.before?(r3.timestamp, r1.timestamp)

      result =
        get(conn, "/api/average?window=last_1_items")
        |> json_response(200)

      assert %{"data" => %{"moving_average" => r3.open}} == result
    end

    test "sucess: return moving average from the latest n records", %{conn: conn} do
      [_r1, r2, r3] = generate_records(3)
      mov_avg = round_float((r3.open + r2.open) / 2)

      result =
        get(conn, "/api/average?window=last_2_items")
        |> json_response(200)

      assert %{"data" => %{"moving_average" => mov_avg}} == result
    end
  end

  describe "GET /average - time" do
    test "error: no records found", %{conn: conn} do
      result =
        get(conn, "/api/average?window=last_1_hour")
        |> json_response(500)

      assert %{
               "error" =>
                 "Internal Server Error. Maybe our DB is empty. Try inserting a record first."
             } == result
    end

    test "error: invalid casting for time", %{conn: conn} do
      invalid_value = "notANumber"

      result =
        get(conn, "/api/average?window=last_#{invalid_value}_hour")
        |> json_response(400)

      err_msg = "Invalid casting. Expected a number but received: #{invalid_value}"
      assert %{"error" => err_msg} == result
    end

    test "sucess: return moving average from the latest hour", %{conn: conn} do
      records = generate_records(120)

      result =
        get(conn, "/api/average?window=last_1_hour")
        |> json_response(200)

      assert %{"data" => %{"moving_average" => moving_average}} = result

      expected = [
        compute_mov_avg(records, 59),
        compute_mov_avg(records, 60),
        compute_mov_avg(records, 61)
      ]

      assert moving_average in expected
    end

    test "sucess: return moving average from the latest 2 hours", %{conn: conn} do
      records = generate_records(180)

      result =
        get(conn, "/api/average?window=last_2_hour")
        |> json_response(200)

      assert %{"data" => %{"moving_average" => moving_average}} = result

      expected = [
        compute_mov_avg(records, 119),
        compute_mov_avg(records, 120),
        compute_mov_avg(records, 121)
      ]

      assert moving_average in expected
    end
  end

  defp compute_mov_avg(records, count) do
    Enum.take(records, count)
    |> Enum.map(& &1.open)
    |> Enum.sum()
    |> Kernel./(count)
    |> round_float()
  end

  defp generate_records(0), do: []

  defp generate_records(count) do
    now = Timex.now()

    for minute <- 0..(count - 1) do
      now_shifted = Timex.shift(now, minutes: -minute)
      insert(:record, timestamp: now_shifted)
    end
  end

  defp round_float(float) do
    float
    |> Decimal.from_float()
    |> Decimal.round(2)
    |> Decimal.to_float()
  end
end

defmodule XeniWeb.RecordControllerTest do
  use XeniWeb.ConnCase

  describe "GET /average" do
    test "error: invalid splitting", %{conn: conn} do
      result =
        get(conn, "/api/average?window=invalid_splitting")
        |> json_response(200)

      err_msg =
        "Invalid property. Expected a string of the form last_INTEGER_items or last_INTEGER_hour"

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
    test "error: invalid casting for items", %{conn: conn} do
      invalid_value = "notANumber"

      result =
        get(conn, "/api/average?window=last_#{invalid_value}_items")
        |> json_response(200)

      err_msg = "Invalid casting. Expected a number but received: #{invalid_value}"
      assert %{"error" => err_msg} == result
    end

    test "sucess: return moving average from the latest record", %{conn: conn} do
      [r1, _r2, r3] = generate_records(3)

      assert Timex.before?(r1.timestamp, r3.timestamp)

      result =
        get(conn, "/api/average?window=last_1_items")
        |> json_response(200)

      assert %{"data" => %{"moving_average" => r3.open}} == result
    end

    test "sucess: return moving average from the latest n records", %{conn: conn} do
      [_r1, r2, r3] = generate_records(3)
      mov_avg = (r3.open + r2.open) / 2

      result =
        get(conn, "/api/average?window=last_2_items")
        |> json_response(200)

      assert %{"data" => %{"moving_average" => mov_avg}} == result
    end
  end

  describe "GET /average - time" do
    test "error: invalid casting for time", %{conn: conn} do
      invalid_value = "notANumber"

      result =
        get(conn, "/api/average?window=last_#{invalid_value}_hour")
        |> json_response(200)

      err_msg = "Invalid casting. Expected a number but received: #{invalid_value}"
      assert %{"error" => err_msg} == result
    end
  end

  defp generate_records(0), do: []

  defp generate_records(count) do
    now = Timex.now()

    for minute <- 0..(count - 1) do
      now_shifted = Timex.shift(now, minutes: minute)
      insert(:record, timestamp: now_shifted)
    end
  end
end

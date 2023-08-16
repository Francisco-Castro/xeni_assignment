defmodule XeniWeb.RecordControllerTest do
  use XeniWeb.ConnCase

  describe "GET /average" do
    test "error: invalid casting for items", %{conn: conn} do
      invalid_value = "notANumber"

      result =
        get(conn, "/api/average?window=last_#{invalid_value}_items")
        |> json_response(200)

      assert %{"error" => "Invalid casting. Expected a number but received: #{invalid_value}"} ==
               result
    end

    test "error: invalid casting for time", %{conn: conn} do
      invalid_value = "notANumber"

      result =
        get(conn, "/api/average?window=last_#{invalid_value}_hour")
        |> json_response(200)

      assert %{"error" => "Invalid casting. Expected a number but received: #{invalid_value}"} ==
               result
    end

    test "error: invalid splitting", %{conn: conn} do
      result =
        get(conn, "/api/average?window=invalid_splitting")
        |> json_response(200)

      assert %{
               "error" =>
                 "Invalid property. Expected a string of the form last_INTEGER_items or last_INTEGER_hour"
             } ==
               result
    end

    test "error: invalid url params", %{conn: conn} do
      result =
        get(conn, "/api/average?no_window=invalid_splitting")
        |> json_response(200)

      assert %{"error" => "Invalid params"} == result
    end
  end
end

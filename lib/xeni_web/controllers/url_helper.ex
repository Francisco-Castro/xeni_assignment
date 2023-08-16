defmodule XeniWeb.UrlHelper do
  def split_string(window) do
    case String.split(window, "_") do
      ["last", items, "items"] ->
        {:items, items}

      ["last", time, "hour"] ->
        {:time, time}

      _incorrect_splitting ->
        {:error, "Invalid property. Expected a string of the form last_INTEGER_items or last_INTEGER_hour"}
    end
  end

  def cast_number(number) do
    case Integer.parse(number) do
      {number, _} -> {:ok, number}
      _ -> {:error, "Invalid casting. Expected a number but received: #{number}"}
    end
  end
end

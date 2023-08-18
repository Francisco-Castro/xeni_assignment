defmodule XeniWeb.UrlHelper do
  def split_string(window) do
    case String.split(window, "_") do
      ["last", items, "items"] ->
        {:items, items}

      ["last", time, "hour"] ->
        {:time, time}

      _incorrect_splitting ->
        {:error, "Invalid url property. Expected a string of the form last_INTEGER_items or last_INTEGER_hour"}
    end
  end
end

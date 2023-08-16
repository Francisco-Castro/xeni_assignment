defmodule Xeni.Misc.Seeding.SeedFactory do
  use ExMachina.Ecto, repo: Xeni.Repo
  alias Xeni.Schemas.Record

  def record_factory do
    %Record{
      open: Enum.random(1..100),
      high: Enum.random(1..100),
      low: Enum.random(1..100),
      close: Enum.random(1..100),
      timestamp: DateTime.utc_now()
    }
  end
end

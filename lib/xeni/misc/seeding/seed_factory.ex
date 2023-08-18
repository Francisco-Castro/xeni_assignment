defmodule Xeni.Misc.Seeding.SeedFactory do
  use ExMachina.Ecto, repo: Xeni.Repo
  alias Xeni.Schemas.Record

  def record_factory do
    {open, high, low, close} = gen_ohlc()
    %Record{
      open: open,
      high: high,
      low: low,
      close: close,
      timestamp: Timex.now()
    }
  end

  def gen_ohlc(range \\ 50..100) do
    low = random_value(range)
    high = Float.ceil(low + random_value(0..10), 2)

    in_between_low_high = trunc(low * 100)..trunc(high * 100)
    open = Enum.random(in_between_low_high) / 100
    close = Enum.random(in_between_low_high) / 100
    {open, high, low, close}
  end

  def random_value(range) do
    Enum.random(range) + Enum.random(0..100) / 100
  end
end

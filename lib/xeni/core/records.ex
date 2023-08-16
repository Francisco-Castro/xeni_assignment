defmodule Xeni.Core.Records do
  alias Xeni.Repo
  alias Xeni.Schemas.Record
  import Ecto.Query

  def latest_records(count) do
    from(r in Record,
      limit: ^count,
      order_by: [desc: :id]
    )
    |> Repo.all()
  end
end

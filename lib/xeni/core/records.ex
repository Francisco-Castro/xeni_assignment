defmodule Xeni.Core.Records do
  alias Xeni.Repo
  alias Xeni.Schemas.Record
  import Ecto.Query

  def create_entry(params) do
    %Record{}
    |> Record.create_changeset(params)
    |> Repo.insert()
  end

  def latest_records(count) when is_integer(count) do
    from(r in Record,
      limit: ^count,
      order_by: [desc: :id]
    )
    |> Repo.all()
  end

  def latest_records(%DateTime{} = time_ago) do
    from(r in Record,
      where: r.timestamp >= ^time_ago,
      order_by: [asc: :timestamp]
    )
    |> Repo.all()
  end
end

defmodule Xeni.Repo.Migrations.AddRecordTable do
  use Ecto.Migration

  def change do
    create table(:records) do
      add :open, :float, null: false
      add :high, :float, null: false
      add :low, :float, null: false
      add :close, :float, null: false
      add :timestamp, :utc_datetime_usec
    end
  end
end

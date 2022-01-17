defmodule Fitlog.Reports.Report do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reports" do
    field :calories, :decimal
    field :carbs, :decimal
    field :date, :date
    field :dumbbells, :decimal
    field :fat, :decimal
    field :protein, :decimal
    field :stepper, :integer
    field :steps, :integer
    field :weight, :decimal
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(report, attrs) do
    report
    |> cast(attrs, [:date, :stepper, :steps, :weight, :dumbbells, :protein, :fat, :carbs, :calories])
    |> validate_required([:date, :stepper, :steps, :weight, :dumbbells, :protein, :fat, :carbs, :calories])
  end
end
defmodule Fitlog.Reports.Report do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  @behaviour Bodyguard.Schema

  schema "reports" do
    belongs_to :user, Fitlog.Users.User
    field :date, :date

    field :stepper, :integer
    field :steps, :integer
    field :weight, :decimal

    field :dumbbell_sets, :integer
    field :kettlebell_sets, :integer
    field :pullups, :integer

    field :protein_meals, :integer
    field :fiber_meals, :integer

    timestamps()
  end

  def scope(query, %Fitlog.Users.User{id: user_id}, _) do
    from reports in query, where: reports.user_id == ^user_id
  end

  def changeset(report, attrs) do
    report
    |> cast(attrs, [
      :date,
      :stepper,
      :steps,
      :weight,
      :dumbbell_sets,
      :kettlebell_sets,
      :pullups,
      :protein_meals,
      :fiber_meals,
    ])
    |> validate_required([:date])
    |> assoc_constraint(:user)
    |> unique_constraint([:date, :user_id])
  end
end

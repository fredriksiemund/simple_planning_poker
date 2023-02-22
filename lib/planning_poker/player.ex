defmodule PlanningPoker.Player do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :name, :vote]}

  schema "players" do
    field :game_id, :string
    field :name, :string
    field :vote, :integer

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:game_id, :name, :vote])
    |> validate_required([:game_id, :name])
  end
end

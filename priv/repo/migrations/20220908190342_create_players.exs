defmodule PlanningPoker.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :game_id, :string
      add :name, :string
      add :vote, :integer

      timestamps()
    end
  end
end

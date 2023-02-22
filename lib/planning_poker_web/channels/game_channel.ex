defmodule PlanningPokerWeb.GameChannel do
  use Phoenix.Channel
  alias PlanningPokerWeb.Presence
  alias PlanningPoker.{Repo, Player}
  require Ecto.Query

  def join("game:" <> game_id, %{"name" => name}, socket) do
    changeset = %Player{} |> Player.changeset(%{game_id: game_id, name: name})

    case Repo.insert(changeset) do
      {:ok, player} ->
        broadcast!(socket, "game:#{game_id}:new_player", %{player: player})

        players =
          Player
          |> Ecto.Query.where(game_id: ^game_id)
          |> Repo.all()

        send(self(), :after_join)
        {:ok, %{players: players}, assign(socket, id: player.id)}

      {:error, _reason} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

  def handle_in("vote:set", %{"vote" => vote}, %{assigns: %{id: id}} = socket) do
    # TODO: broadcast instead
    {:ok, _} = Presence.update(socket, id, fn map -> %{map | vote: vote} end)
    {:noreply, socket}
  end

  def handle_in("vote:reveal", %{"revealed" => revealed}, %{assigns: %{id: id}} = socket) do
    # TODO: broadcast instead
    {:ok, _} = Presence.update(socket, id, fn map -> %{map | revealed: revealed} end)
    {:noreply, socket}
  end

  def handle_in("vote:reset", %{"reset" => _reset}, socket) do
    # TODO: broadcast
    {:noreply, socket}
  end

  def handle_info(:after_join, %{assigns: %{id: id}} = socket) do
    {:ok, _} = Presence.track(socket, id, %{})
    push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket}
  end

  ## TODO: on connection close, remove from db
end

defmodule PlanningPokerWeb.GameChannel do
  use Phoenix.Channel
  alias PlanningPokerWeb.Presence

  def join("game:" <> _game_id, %{"name" => name}, socket) do
    send(self(), :after_join)
    {:ok, assign(socket, name: name, id: UUID.uuid4())}
  end

  def handle_in("vote:set", %{"vote" => vote}, %{assigns: %{id: id}} = socket) do
    {:ok, _} = Presence.update(socket, id, fn map -> %{map | vote: vote} end)
    {:noreply, socket}
  end

  def handle_in("vote:reveal", %{"revealed" => revealed}, %{assigns: %{id: id}} = socket) do
    {:ok, _} = Presence.update(socket, id, fn map -> %{map | revealed: revealed} end)
    {:noreply, socket}
  end

  def handle_in("vote:reset", %{"reset" => _reset}, socket) do
    # Clear from db
    {:noreply, socket}
  end

  def handle_info(:after_join, %{assigns: %{id: id, name: name}} = socket) do
    {:ok, _} = Presence.track(socket, id, %{name: name, vote: -1, revealed: false})
    # Send the current presence state to the newly joined client
    push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket}
  end
end

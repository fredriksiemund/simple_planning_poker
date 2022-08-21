defmodule PlanningPokerWeb.GameChannel do
  use Phoenix.Channel
  alias PlanningPokerWeb.Presence

  def join("game:" <> _game_id, %{"name" => name}, socket) do
    send(self(), :after_join)
    {:ok, assign(socket, :name, name)}
  end

  def handle_in("vote:set", %{"vote" => vote}, %{assigns: %{name: name}} = socket) do
    {:ok, _} = Presence.update(socket, name, %{vote: vote})
    push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket}
  end

  def handle_info(:after_join, %{assigns: %{name: name}} = socket) do
    {:ok, _} = Presence.track(socket, name, %{vote: -1})
    push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket}
  end
end

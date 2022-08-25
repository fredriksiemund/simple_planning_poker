defmodule PlanningPokerWeb.GameChannel do
  use Phoenix.Channel
  alias PlanningPokerWeb.Presence

  def join("game:" <> _game_id, %{"name" => name}, socket) do
    send(self(), :after_join)
    {:ok, assign(socket, :name, name)}
  end

  def handle_in("vote:set", %{"vote" => vote}, socket) do
    # Replace a presence's metadata by passing a new map _OR_ a function that takes the current map and returns a new one.
    {:ok, _} = Presence.update(socket, :users, fn (map) -> %{map | vote: vote} end)
    {:noreply, socket}
  end

  def handle_in("reveal", %{"isRevealed" => is_revealed}, socket) do
    {:ok, _} = Presence.track(socket, :isRevealed, %{ value: is_revealed})
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    %{assigns: %{name: name}} = socket
    {:ok, _} = Presence.track(socket, :users, %{name: name, vote: -1})
    # Send the current presence state to the newly joined client
    push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket}
  end
end

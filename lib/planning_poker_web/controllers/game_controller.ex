defmodule PlanningPokerWeb.GameController do
  use PlanningPokerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, _params) do
    uuid = UUID.uuid4()

    redirect(conn, to: Routes.game_path(conn, :show, uuid))
  end

  def show(conn, %{"id" => game_id}) do
    render(conn, "show.html", game_id: game_id)
  end
end

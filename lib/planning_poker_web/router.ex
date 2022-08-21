defmodule PlanningPokerWeb.Router do
  use PlanningPokerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PlanningPokerWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", PlanningPokerWeb do
    pipe_through :browser

    get "/", GameController, :index
    post "/games", GameController, :create
    get "/games/:id", GameController, :show
  end
end

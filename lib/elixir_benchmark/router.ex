defmodule ElixirBenchmark.Router do
  use Phoenix.Router

  plug Plug.Static, at: "/static", from: :elixir_benchmark
  get "/", ElixirBenchmark.Controllers.Pages, :index, as: :page
end

defmodule ElixirBenchmark.Controllers.Pages do
  use Phoenix.Controller

  def index(conn) do
    text conn, "Hello world"
  end
end

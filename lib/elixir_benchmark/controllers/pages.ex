defmodule ElixirBenchmark.Controllers.Pages do
  use Phoenix.Controller
  use Jazz
  use ElixirBenchmark.Database.Database
  use Amnesia

  def index(conn) do
    text conn, "Hello world"
  end

  def sell(conn) do
    :erlcloud.start
    sell_request = conn |> read_req_body |> JSON.decode!(keys: :atoms) 
    %{inv: tt} = sell_request

    %{inv: [%{shelf: %{items: [item_id|_]}}|_]} = sell_request

    person =  Person.read_at!(item_id, :interested_in) |> hd

    case :erlcloud_ddb2.get_item("Shops", {"Id", sell_request.shop.id}) do
      {:ok, [{"Name", name}, _]} ->
        json conn, %{user: name, person: person.person_name, pays: person.pays } |> JSON.encode!
      err ->
        text conn, inspect(err)
      end

    {:ok, [{"Spent", spent}]} = :erlcloud_ddb2.update_item("Buyers", {"Id", "#{person.person_id}"}, {"Spent", person.pays, :add}, [{:return_values, :updated_new}])

    if spent >= person.wallet do
      Amnesia.transaction do
        person.delete
      end
    end
 
  end

  defp read_req_body({:ok, buffer, state}, acc, adapter) do
    read_req_body(adapter.stream_req_body(state, 100_000), acc <> buffer, adapter)
  end

  defp read_req_body({:done, state}, acc, _adapter) do
    {acc, state}
  end

  defp read_req_body(%{adapter: {adapter, state}}) do
    {body, _} = read_req_body({:ok, "", state}, "", adapter)
    body
  end

end

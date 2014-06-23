defmodule ElixirBenchmark.Supervisor do
  use Supervisor.Behaviour
  use ElixirBenchmark.Database.Database
  use Amnesia
  use Jazz

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      # Define workers and child supervisors to be supervised
      worker(ElixirBenchmark.Router, [], function: :start)
    ]
    Amnesia.start
    Database.create
    persons = JSON.decode!(File.read!("persons.txt"), keys: :atoms)
    
    Amnesia.transaction do
      Enum.each(persons, fn %{person_id: i, person_name: n, wallet: w, pays: p, interested_in: [ii]} -> 
        Person[person_id: i, person_name: n, wallet: w, pays: p, interested_in: ii].write 
      end)
    end
    # See http://elixir-lang.org/docs/stable/Supervisor.Behaviour.html
    # for other strategies and supported options
    supervise(children, strategy: :one_for_one)
  end
end

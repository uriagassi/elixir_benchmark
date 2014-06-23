 defmodule ElixirBenchmark.Database do
   use Amnesia

  defdatabase Database do

    deftable Person, [:person_id, :person_name, :wallet, :pays, :interested_in], type: :set, index: [:interested_in] do
      @type t :: Person[person_id: non_neg_integer, person_name: String.t, wallet: non_neg_integer, pays: non_neg_integer, interested_in: List.t]
    end
  end
end
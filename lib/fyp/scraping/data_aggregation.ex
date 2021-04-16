defmodule Fyp.Scraping.DataAggregation do
  @moduledoc """
  Scrape pets data from web cites using HTTPoison and Floki and aggregate it
  """
  use GenServer
  require Logger

  @shelter_list [
    %ShelterFriend{link: "http://priyut-drug.ru/take/"}
  ]

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(state) do
#    scrape_data()
    schedule_work()
    {:ok, state}
  end

  @impl true
  def handle_info(:work, state) do
    # Reschedule once more
    schedule_work()

    # Do the desired work here
    Logger.warn("Schedule work #{inspect(Time.utc_now())}")

    {:noreply, state, :hibernate} # Since the scraping happens once a day
  end

  defp scrape_data do
    @shelter_list
    |> Enum.each(fn s -> Fyp.Scraping.Shelters.get_pets(s) end)
  end

  defp schedule_work do
    # In 12 hours
    # hours * minutes * seconds * milliseconds
    Process.send_after(self(), :work, 24 * 60 * 60 * 1000)
  end
end

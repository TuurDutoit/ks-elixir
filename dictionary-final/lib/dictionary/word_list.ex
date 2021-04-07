defmodule Dictionary.WordList do
  ###
  # GenServer stuff
  ###

  use GenServer

  def start_link(_state \\ []) do
    GenServer.start_link(__MODULE__, %{words: get_words(), requests: 0}, name: __MODULE__)
  end

  def init(state), do: {:ok, state}

  def handle_call({:random_word}, _from, state) do
    word = state.words |> Enum.random()
    {:reply, word, %{state | requests: state.requests + 1}}
  end

  def handle_call({:search, input}, _from, state) do
    words =
      input
      |> Peach.find_fuzzy_matches(state.words, 3)
      |> Enum.map(&just_word/1)

    {:reply, words, %{state | requests: state.requests + 1}}
  end

  def handle_call({:requests}, _from, state) do
    {:reply, state.requests, state}
  end

  ###
  # Public API
  ###

  def random_word() do
    GenServer.call(__MODULE__, {:random_word})
  end

  def search(input) do
    GenServer.call(__MODULE__, {:search, input})
  end

  def requests() do
    GenServer.call(__MODULE__, {:requests})
  end

  ###
  # Private stuff
  ###

  defp get_words() do
    "../../assets/words.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split(~r/\n/)
  end

  def loop() do
    receive do
      {:random_word} -> random_word() |> IO.inspect()
      {:search, input} -> search(input) |> IO.inspect()
    end

    loop()
  end

  defp just_word({word, _dist}), do: word
end

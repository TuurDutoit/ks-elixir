defmodule DictionaryWeb.PageController do
  use DictionaryWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def random_word(conn, _params) do
    word = Dictionary.WordList.random_word()
    render(conn, "random_word.html", word: word)
  end

  def search(conn, params) do
    input = params["search"]["input"]
    words = Dictionary.WordList.search(input)
    render(conn, "search.html", words: words)
  end
end

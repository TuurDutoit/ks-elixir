defmodule DictionaryWeb.PageController do
  use DictionaryWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

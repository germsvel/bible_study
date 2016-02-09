defmodule BibleStudy.SearchController do
  use BibleStudy.Web, :controller
  alias BibleStudy.Bible

  def index(conn, _params) do
    conn
    |> assign(:scripture, "")
    |> render("index.html")
  end

  def create(conn, params) do
    passage = get_passage(params)
    scripture = get_scripture(passage)
    conn
    |> assign(:passage, passage)
    |> assign(:scripture, scripture)
    |> render("index.html")
  end

  defp get_scripture(passage) do
    Bible.find(passage)
  end

  defp get_passage(params) do
    case Map.get(params, "search") do
      %{"passage" => passage}
        -> passage
      _
        -> ""
    end
  end

end

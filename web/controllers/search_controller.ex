defmodule BibleStudy.SearchController do
  use BibleStudy.Web, :controller
  alias BibleStudy.Bible
  alias BibleStudy.Sermons
  alias BibleStudy.Passage

  def index(conn, _params) do
    conn
    |> assign(:passage, "")
    |> assign(:scripture, "")
    |> assign(:sermons, [])
    |> render("index.html")
  end

  def create(conn, params) do
    passage = get_passage(params)
    conn
    |> assign(:passage, passage.original)
    |> assign(:scripture, get_scripture(passage))
    |> assign(:sermons, get_sermons(passage))
    |> render("index.html")
  end

  defp get_scripture(passage) do
    Bible.find(passage)
  end

  defp get_sermons(passage) do
    Sermons.find(passage)
  end

  defp get_passage(params) do
    %{"passage" => passage} = Map.get(params, "search")
    Passage.from_binary(passage)
  end

end

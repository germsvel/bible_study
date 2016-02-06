defmodule BibleStudy.SearchController do
  use BibleStudy.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def create(conn, params) do
    passage = get_passage(params)
    conn
    |> put_flash(:info, passage)
    |> render("index.html")
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

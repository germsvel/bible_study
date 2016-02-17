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
    parse_passage(passage)
  end

  defp parse_passage(""), do: %Passage{}
  defp parse_passage(passage) when is_binary(passage) do
    parse_passage(passage, String.split(passage))
  end
  defp parse_passage(original, [book]) do
    parse_passage(original, [book, "1:1"])
  end
  defp parse_passage(original, [num, book, chapter_verses]) do
    parse_passage(original, ["#{num} #{book}", chapter_verses])
  end
  defp parse_passage(original, [book, chapter_verses]) do
    [chapter, verses] = String.split(chapter_verses, ":")
    book = String.downcase(book)
    %Passage{original: original, book: book, chapter: chapter, verses: verses}
  end

end

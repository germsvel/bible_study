defmodule BibleStudy.Passage do
  defstruct [:book, :chapter, :verses, :original]

  def from_binary(passage) do
    parse_passage(passage)
  end

  defp parse_passage(""), do: %BibleStudy.Passage{}
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
    book = String.downcase(book)
    case String.split(chapter_verses, ":") do
      [chapter, verses] ->
        %BibleStudy.Passage{original: original, book: book, chapter: chapter, verses: verses}
      [chapter, verses, _] ->
        %BibleStudy.Passage{original: original, book: book, chapter: chapter, verses: verses}
    end
  end
end

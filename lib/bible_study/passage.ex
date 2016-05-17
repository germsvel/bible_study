defmodule BibleStudy.Passage do
  defstruct [:book, :chapter, :verses, :original, :first_verse, :last_verse]

  @longest_chapter_length "176"

  def new(""), do: %BibleStudy.Passage{}
  def new(passage) do
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
    {chapter, first_verse, last_verse} = find_chapter_and_verses(chapter_verses)
    %BibleStudy.Passage{original: original, book: book, chapter: String.to_integer(chapter), verses: "#{first_verse}-#{last_verse}", first_verse: String.to_integer(first_verse), last_verse: String.to_integer(last_verse)}
  end

  defp find_chapter_and_verses(chapter_verses) do
    # 4:23, 4:23-27, 4:23-5:6
    {chapter, verses} = split_chapter(chapter_verses)
    {first_verse, last_verse} = split_verses(verses)
    {chapter, first_verse, last_verse}
  end

  defp split_chapter(chapter_verses) do
    case String.split(chapter_verses, ":") do
      [chapter] -> get_first_or_only_chapter(chapter)
      [chapter, verses] -> {chapter, verses}
      [chapter, v_to_ch, _last_verse] ->
        [first_verse] = String.split(v_to_ch, "-") |> Enum.take(1)
        {chapter, "#{first_verse}-#{@longest_chapter_length}"}
    end
  end

  defp get_first_or_only_chapter(chapter) do
    # account for Romans 1-18 scenario
    [first | _] = String.split(chapter, "-")
    {first, "1-#{@longest_chapter_length}"}
  end

  defp split_verses(verses) do
    case String.split(verses, "-") do
      [first_verse, last_verse] -> {first_verse, last_verse}
      [first_verse] -> {first_verse, first_verse}
    end
  end
end

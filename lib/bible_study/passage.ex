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
    %BibleStudy.Passage{
      original: original,
      book: book,
      chapter: String.to_integer(chapter),
      verses: "#{first_verse}-#{last_verse}",
      first_verse: String.to_integer(first_verse),
      last_verse: String.to_integer(last_verse)
    }
  end

  defp find_chapter_and_verses(chapter_verses) do
    # 4:23, 4:23-27, 4:23-5:6
    {chapter, verses} = split_chapter(chapter_verses)
    {first_verse, last_verse} = split_verses(verses)
    {chapter, first_verse, last_verse}
  end

  defp split_chapter(chapter_verses) do
    String.split(chapter_verses, ":") |> do_split_chapter
  end
  defp do_split_chapter([chapter, verses]), do: {chapter, verses}
  defp do_split_chapter([chapter, v_to_ch, _last_verse]) do
    # Romans 3:23-4:5 scenario
    [first_verse] = String.split(v_to_ch, "-") |> Enum.take(1)
    {chapter, "#{first_verse}-#{@longest_chapter_length}"}
  end
  defp do_split_chapter([chapter]) do
    # Romans 1-18 scenario
    [first | _] = String.split(chapter, "-")
    {first, "1-#{@longest_chapter_length}"}
  end

  defp split_verses(verses) do
    String.split(verses, "-") |> do_split_verses
  end
  defp do_split_verses([first_verse, last_verse]), do: {first_verse, last_verse}
  defp do_split_verses([first_verse]), do: {first_verse, first_verse}

  def compare(passage, passage2) do
    passage.book == passage2.book &&
    passage.chapter == passage2.chapter &&
    compare_verses(passage, passage2)
  end

  defp compare_verses(passage, passage2) do
    ((passage.first_verse == passage2.first_verse) && within(passage.last_verse, passage2.last_verse, 2)) ||
    ((passage.last_verse == passage2.last_verse) && within(passage.first_verse, passage2.first_verse, 2))
  end

  defp within(num1, num2, tolerance) do
    abs(num1 - num2) < tolerance
  end
end

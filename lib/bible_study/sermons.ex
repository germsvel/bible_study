defmodule BibleStudy.Sermons do
  alias BibleStudy.Sermons.DesiringGod
  alias BibleStudy.Sermons.UniversityReformedChurch, as: URC
  alias BibleStudy.Passage

  def find(passage) do
    [DesiringGod.find(passage), URC.find(passage)]
    |> List.flatten
    |> filter_by_passage(passage)
  end

  defp filter_by_passage(sermons, passage) do
    Enum.filter(sermons, fn(sermon) ->
      IO.inspect sermon.scripture_reference
      scripture = Passage.from_binary(sermon.scripture_reference)
      scripture.book == passage.book && scripture.chapter == passage.chapter
    end)
  end

end

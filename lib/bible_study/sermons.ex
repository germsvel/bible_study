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
      sermon_contains_passage?(sermon, passage)
    end)
  end

  defp sermon_contains_passage?(sermon, passage) do
    scripture = Passage.from_string(sermon.scripture_reference)
    scripture.book == passage.book &&
    scripture.chapter == passage.chapter &&
    ((passage.first_verse >= scripture.first_verse && passage.first_verse <= scripture.last_verse) || (passage.last_verse >= scripture.first_verse && passage.last_verse <= scripture.last_verse))
  end

end

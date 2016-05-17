defmodule BibleStudy.StudyResource do
  alias BibleStudy.Passage

  defstruct [:url, :title, :author, :scripture_reference, :date, :type, :source]

  def relevant_for_passage?(resource, passage) do
    scripture = Passage.new(resource.scripture_reference)
    scripture.book == passage.book &&
    scripture.chapter == passage.chapter &&
    ((passage.first_verse >= scripture.first_verse && passage.first_verse <= scripture.last_verse) || (passage.last_verse >= scripture.first_verse && passage.last_verse <= scripture.last_verse))
  end
end

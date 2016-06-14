defmodule BibleStudy.StudyResource do
  alias BibleStudy.Passage

  defstruct [:url, :title, :author, :scripture_reference, :date, :type, :source]

  def new do
    %BibleStudy.StudyResource{}
  end

  def relevant_for_passage?(resource, passage) do
    scripture = Passage.new(resource.scripture_reference)
    scripture.book == passage.book &&
    scripture.chapter == passage.chapter &&
    ((passage.first_verse >= scripture.first_verse && passage.first_verse <= scripture.last_verse) || (passage.last_verse >= scripture.first_verse && passage.last_verse <= scripture.last_verse))
  end

  def add_type(resource, type) do
    %{resource | type: type}
  end

  def add_title(resource, title) do
    %{resource | title: title}
  end

  def add_url(resource, url) do
    %{resource | url: url}
  end

  def add_scripture_ref(resource, scripture_ref) do
    %{resource | scripture_reference: scripture_ref}
  end

  def add_date(resource, date) do
    %{resource | date: date}
  end

  def add_author(resource, author) do
    %{resource | author: author}
  end
end

defmodule BibleStudy.StudyResource do
  alias BibleStudy.Passage

  defstruct [:url, :title, :author, :scripture_reference, :date, :type, :source]

  def new do
    %BibleStudy.StudyResource{}
  end

  def relevant_for_passage?(resource, passage) do
    Passage.compare(passage, resource.scripture_reference)
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

  def add_source(resource, source) do
    %{resource | source: source}
  end
end

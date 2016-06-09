defmodule BibleStudy.Sermons.Mock do
  alias BibleStudy.StudyResource, as: Resource

  def start_link(passage, sermon_ref, owner) do
    Task.start_link(__MODULE__, :find, [passage, sermon_ref, owner])
  end

  def find(_passage, sermon_ref, owner) do
    results = [%Resource{type: :sermon, author: "John Piper"}]
    send(owner, {:results, sermon_ref, results})
  end
end

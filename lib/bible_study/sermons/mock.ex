defmodule BibleStudy.Sermons.Mock do
  alias BibleStudy.StudyResource, as: Resource

  def find(_passage) do
    %Resource{type: :sermon, author: "John Piper"}
  end
end

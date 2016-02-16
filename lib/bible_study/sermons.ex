defmodule BibleStudy.Sermons do
  alias BibleStudy.Sermons.DesiringGod

  def find(passage) do
    [DesiringGod.find(passage)]
  end

end

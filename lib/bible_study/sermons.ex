defmodule BibleStudy.Sermons do
  alias BibleStudy.Sermons.DesiringGod

  def find(passage) do
    [DesiringGod.find(passage)]
    |> List.flatten
  end

end

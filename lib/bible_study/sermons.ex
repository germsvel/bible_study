defmodule BibleStudy.Sermons do
  alias BibleStudy.Sermons.DesiringGod
  alias BibleStudy.Sermons.UniversityReformedChurch, as: URC

  def find(passage) do
    [DesiringGod.find(passage), URC.find(passage)]
    |> List.flatten
  end

end

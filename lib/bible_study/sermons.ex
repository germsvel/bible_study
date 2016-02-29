defmodule BibleStudy.Sermons do
  alias BibleStudy.Sermons.DesiringGod
  alias BibleStudy.Sermons.UniversityReformedChurch, as: URC

  def find(passage) do
    [DesiringGod, URC]
    |> Enum.map(&Task.async(&1, :find, [passage]))
    |> Enum.map(&Task.await(&1))
    |> List.flatten
  end

end

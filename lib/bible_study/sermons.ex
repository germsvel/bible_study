defmodule BibleStudy.Sermons do
  @resource_sources Application.get_env(:bible_study, :resource_sources)

  def find(passage) do
    @resource_sources
    |> Enum.map(&Task.async(&1, :find, [passage]))
    |> Enum.map(&Task.await(&1))
    |> List.flatten
  end

end

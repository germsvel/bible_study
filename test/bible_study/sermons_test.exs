defmodule BibleStudy.SermonsTest do
  use ExUnit.Case, async: true
  alias BibleStudy.Sermons
  alias BibleStudy.Passage

  test ".find(passage) returns a list of sermon resources" do
    passage = Passage.new("Romans 3:23")

    [%{type: type} | _] = Sermons.find(passage)

    assert type == :sermon
  end

end

defmodule BibleStudy.BibleTest do
  use ExUnit.Case, async: true
  alias BibleStudy.Bible
  alias BibleStudy.Passage

  test ".find(passage) returns a bible text" do
    passage = Passage.new("Romans 3:23")

    text = Bible.find(passage)

    assert text == "for all have sinned and fall short of the glory of God,"
  end

end

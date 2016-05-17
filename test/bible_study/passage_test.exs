defmodule BibleStudy.PassageTest do
  use ExUnit.Case, async: true
  alias BibleStudy.Passage

  test ".new with empty string returns an empty struct" do
    passage = Passage.new("")

    assert passage == %Passage{}
  end

  test ".new can parse Romans 3:23-24" do
    passage = Passage.new("Romans 3:23-24")

    assert passage.original == "Romans 3:23-24"
    assert passage.book == "romans"
    assert passage.chapter == 3
    assert passage.verses == "23-24"
    assert passage.first_verse == 23
    assert passage.last_verse == 24
  end

  test ".new sets verses as 23-23 when Romans 3:23" do
    passage = Passage.new("Romans 3:23")

    assert passage.verses == "23-23"
    assert passage.first_verse == 23
    assert passage.last_verse == 23
  end

  test ".new sets last verse as 176 when Romans 3:23-4:2" do
    passage = Passage.new("Romans 3:23-4:2")

    assert passage.verses == "23-176"
    assert passage.first_verse == 23
    assert passage.last_verse == 176
  end

  test ".new sets verses as 1-200 when only chapters are given" do
    passage = Passage.new("Romans 3")

    assert passage.chapter == 3
    assert passage.verses == "1-176"
    assert passage.first_verse == 1
    assert passage.last_verse == 176
  end

  test ".new only accounts for first chapter if multiple chapters are given" do
    passage = Passage.new("Romans 3-4")

    assert passage.chapter == 3
    assert passage.verses == "1-176"
    assert passage.first_verse == 1
    assert passage.last_verse == 176
  end

  test ".new parses books prefixed by numbers, e.g. 1 Corinthian" do
    passage = Passage.new("1 Corinthians 1:4-6")

    assert passage.original == "1 Corinthians 1:4-6"
    assert passage.book == "1 corinthians"
    assert passage.chapter == 1
    assert passage.verses == "4-6"
    assert passage.first_verse == 4
    assert passage.last_verse == 6
  end



end

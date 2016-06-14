defmodule BibleStudy.StudyResourceTest do
  use ExUnit.Case, async: true
  alias BibleStudy.StudyResource

  test ".new returns a new struct" do
    resource = StudyResource.new

    assert resource.__struct__ == StudyResource
  end
end

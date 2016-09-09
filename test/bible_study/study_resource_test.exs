defmodule BibleStudy.StudyResourceTest do
  use ExUnit.Case, async: true
  alias BibleStudy.StudyResource

  test ".new returns a new struct" do
    resource = StudyResource.new

    assert resource.__struct__ == StudyResource
  end

  test ".add_type adds type to study resource" do
    resource = StudyResource.new
             |> StudyResource.add_type(:sermon)

    assert resource.type == :sermon
  end

  test ".add_title adds title to study resource" do
    resource = StudyResource.new
             |> StudyResource.add_title("Long Title Here")

    assert resource.title == "Long Title Here"
  end

  test ".add_url adds url to study resource" do
    resource = StudyResource.new
             |> StudyResource.add_url("http://google.com")

    assert resource.url == "http://google.com"
  end

  test ".add_scripture_ref adds scripture_reference to study resource" do
    resource = StudyResource.new
             |> StudyResource.add_scripture_ref("Romans 3:23")

    assert resource.scripture_reference == "Romans 3:23"
  end

  test ".add_date adds date to study resource" do
    resource = StudyResource.new
             |> StudyResource.add_date("August 23rd, 2016")

    assert resource.date == "August 23rd, 2016"
  end

  test ".add_author adds author to study resource" do
    resource = StudyResource.new
             |> StudyResource.add_author("John Piper")

    assert resource.author == "John Piper"
  end

  test ".add_source adds source to study resource" do
    resource = StudyResource.new
             |> StudyResource.add_source("Desiring God")

    assert resource.source == "Desiring God"
  end
end

defmodule BibleStudy.SearchControllerTest do
  use BibleStudy.ConnCase

  test "GET / returns the main page" do
    conn = get conn(), "/"

    assert html_response(conn, 200) =~ "Study the Bible"
  end

  test "POST /search returns the scripture reference" do
    conn = post conn(), "/search", [search: %{"passage" => "Romans 3:23"} ]

    assert html_response(conn, 200) =~ "Romans 3:23"
  end

  test "POST /search searches passage of Scripture" do
    conn = post conn(), "/search", [search: %{"passage" => "Romans 3:23"} ]

    assert html_response(conn, 200) =~ "for all have sinned and fall short of the glory of God"
  end

  test "POST /search searches sermons" do
    conn = post conn(), "/search", [search: %{"passage" => "Romans 3:23"} ]

    assert html_response(conn, 200) =~ "John Piper"
  end

end

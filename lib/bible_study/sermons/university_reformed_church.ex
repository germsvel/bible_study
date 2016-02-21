defmodule BibleStudy.Sermons.UniversityReformedChurch do
  alias BibleStudy.StudyResource, as: Resource

  @base_url "http://www.universityreformedchurch.org"

  def find(passage) do
    generate_url(passage)
    |> request_page()
    |> process_response()
  end

  defp generate_url(passage) do
    "#{@base_url}/teaching/sermons.html?book=#{passage.book}"
  end

  defp request_page(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
          IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
          IO.inspect reason
      _ ->
        IO.puts "Could not find #{url}"
    end
  end

  defp process_response(nil), do: ""
  defp process_response(body) do
    Floki.find(body, ".sermonsHomePage")
    |> Floki.find("li")
    |> Enum.map(&create_resource/1)
  end

  defp create_resource(html_tree) do
    %Resource{type: :sermon}
    |> add_title(html_tree)
    |> add_url(html_tree)
    |> add_scripture_ref(html_tree)
    |> add_date(html_tree)
    |> add_author(html_tree)
  end

  defp add_title(resource, html_tree) do
    title = Floki.find(html_tree, "a") |> Enum.take(1) |> Floki.text
    %{resource | title: title}
  end
  defp add_url(resource, html_tree) do
    url = Floki.find(html_tree, "a") |> Enum.take(1) |> Floki.attribute("href")
    %{resource | url: url}
  end
  defp add_scripture_ref(resource, html_tree) do
    scripture = Floki.find(html_tree, ".subTitle") |> Floki.text
    %{resource | scripture_reference: scripture}
  end
  defp add_date(resource, html_tree) do
    date = Floki.find(html_tree, ".sermonDate") |> Floki.text |> String.replace("Given on: ", "") |> String.replace(~r/\s\(.+\)\./, "")
    %{resource | date: date}
  end
  defp add_author(resource, html_tree) do
    author = Floki.find(html_tree, ".sermonSpeaker") |> Floki.text |> String.replace("Speaker: ", "")
    %{resource | author: author}
  end
end

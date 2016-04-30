defmodule BibleStudy.Sermons.UniversityReformedChurch do
  alias BibleStudy.StudyResource, as: Resource
  alias BibleStudy.HTTPClient

  @base_url "http://www.universityreformedchurch.org"

  def start_link(passage, sermon_ref, owner) do
    Task.start_link(__MODULE__, :find, [passage, sermon_ref, owner])
  end

  def find(passage, sermon_ref, owner) do
    generate_url(passage)
    |> request_page
    |> process_response
    |> filter_resources_by_passage(passage)
    |> send_result(sermon_ref, owner)
  end

  defp send_result(nil, sermon_ref, owner) do
    send(owner, {:results, sermon_ref, []})
  end
  defp send_result(results, sermon_ref, owner) do
    send(owner, {:results, sermon_ref, results})
  end

  defp generate_url(passage) do
    "#{@base_url}/teaching/sermons.html?book=#{passage.book}"
  end

  defp request_page(url) do
    {:ok, body} = HTTPClient.get(url)
    body
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
    text = Floki.find(html_tree, ".subTitle") |> Floki.text
    [[scripture]] = Regex.scan(~r/.+\d{1,}:[\-\d]{1,}/, text)
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

  defp filter_resources_by_passage(sermons, passage) do
    Enum.filter(sermons, fn(sermon) ->
      Resource.relevant_for_passage?(sermon, passage)
    end)
  end
end

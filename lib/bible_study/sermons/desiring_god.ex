defmodule BibleStudy.Sermons.DesiringGod do
  alias BibleStudy.StudyResource, as: Resource

  @base_url "http://www.desiringgod.org"

  def find(passage) do
    generate_url(passage)
    |> request_page()
    |> process_response()
  end

  defp generate_url(passage) do
    "#{@base_url}/messages/by-scripture/#{passage.book}/#{passage.chapter}"
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
    Floki.find(body, ".sermon_list")
    |> Floki.find(".media-object")
    |> Enum.map(&create_resource/1)
  end

  defp create_resource(html_tree) do
    %Resource{author: "John Piper", type: :sermon}
    |> add_title(html_tree)
    |> add_url(html_tree)
    |> add_scripture_ref(html_tree)
    |> add_date(html_tree)
  end

  defp add_url(resource, html_tree) do
    [relative_url] = Floki.find(html_tree, "a")
                  |> Floki.attribute("href")
                  |> Enum.take(1)

    url = @base_url <> relative_url
    %{resource | url: url}
  end
  defp add_title(resource, html_tree) do
    %{resource | title: search_tree(html_tree, ".title") }
  end
  defp add_scripture_ref(resource, html_tree) do
    %{resource | scripture_reference: search_tree(html_tree, ".scripture-reference")}
  end
  defp add_date(resource, html_tree) do
    %{resource | date: search_tree(html_tree, ".time")}
  end

  defp search_tree(html_tree, css_selector) do
    Floki.find(html_tree, css_selector) |> Floki.text |> String.strip
  end

end

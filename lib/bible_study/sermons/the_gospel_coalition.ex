defmodule BibleStudy.Sermons.TheGospelCoalition do
  alias BibleStudy.StudyResource, as: Resource

  @base_url "http://resources.thegospelcoalition.org"

  def find(passage) do
    generate_url(passage)
    |> request_page()
    |> process_response()
    |> filter_resources_by_passage(passage)
    |> IO.inspect
  end

  defp generate_url(passage) do
    book = String.capitalize(passage.book)
    chapter = Integer.to_string(passage.chapter)
    tgc_chapter = book <> "+" <> chapter
    "#{@base_url}/library?f[book][]=#{book}&f[chapter][]=#{tgc_chapter}&f[language][]=English&f[resource_category][]=Sermons"
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
    Floki.find(body, ".blacklight_list-item")
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

  defp add_url(resource, html_tree) do
    [relative_url] = Floki.find(html_tree, "a")
                  |> Floki.attribute("href")
                  |> Enum.take(1)

    url = @base_url <> relative_url
    %{resource | url: url}
  end
  defp add_title(resource, html_tree) do
    %{resource | title: search_tree(html_tree, "h3") }
  end
  defp add_scripture_ref(resource, html_tree) do
    {_, ref} = html_tree |> get_date_and_scripture()
    [romans_ref] = ref |> String.split(";") |> Enum.filter(fn (x) -> String.contains?(x, "Romans") end) |> Enum.take(1)
    clean_ref = String.strip(romans_ref)
    %{resource | scripture_reference: clean_ref}
  end
  defp add_date(resource, html_tree) do
    {date, _} = html_tree |> get_date_and_scripture()
    %{resource | date: date}
  end
  defp add_author(resource, html_tree) do
    %{resource | author: search_tree(html_tree, "h4")}
  end

  defp get_date_and_scripture(html_tree) do
    case parse_date_and_scripture(html_tree) do
      [date, ref] -> {date, ref}
      [ref] -> {"", ref}
    end
  end
  defp parse_date_and_scripture(html_tree) do
    search_tree(html_tree, ".scripture_ref")
    |> String.split("|")
    |> Enum.map(&String.strip/1)
  end

  defp search_tree(html_tree, css_selector) do
    Floki.find(html_tree, css_selector) |> Floki.text |> String.strip
  end

  defp filter_resources_by_passage(sermons, passage) do
    Enum.filter(sermons, fn(sermon) ->
      Resource.relevant_for_passage?(sermon, passage)
    end)
  end

end

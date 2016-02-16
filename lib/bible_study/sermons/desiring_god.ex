defmodule BibleStudy.Sermons.DesiringGod do

  @base_url "http://www.desiringgod.org"

  def find(passage) do
    generate_url(passage)
    |> get_page()
    |> process()
  end

  defp process(nil), do: ""
  defp process(body) do
    Floki.find(body, ".sermon_list")
    |> Floki.find(".media-object")
    |> Enum.map(&generate_resource/1)
  end

  defp generate_resource(html_tree) do
    title = Floki.find(html_tree, ".title") |> Floki.text |> String.strip
    url = parse_sermon_url(html_tree)
  end

  defp parse_sermon_url(html_tree) do
    [relative_url] = Floki.find(html_tree, "a")
                  |> Floki.attribute("href")
                  |> Enum.take(1)


    @base_url <> relative_url
  end

  defp get_page(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
          IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
          IO.inspect reason
    end
  end

  defp generate_url(passage) do
    "#{@base_url}/messages/by-scripture/#{passage.book}/#{passage.chapter}"
  end


end

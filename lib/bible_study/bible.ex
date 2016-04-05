defmodule BibleStudy.Bible do
  @base_url "http://www.esvapi.org/v2/rest/passageQuery"

  def find(passage) do
    url = passage
        |> parse_passage()
        |> generate_url()

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          body |> String.replace("=", "") |> String.replace("_", "") |> String.strip
      {:ok, %HTTPoison.Response{status_code: 404}} ->
          IO.puts "Not found"
      {:error, %HTTPoison.Error{reason: reason}} ->
          IO.inspect reason
      _ ->
        IO.puts "Error retrieving passage #{passage.original}"
    end
  end

  defp parse_passage(passage) do
    String.replace(passage.original, " ", "+")
  end

  defp generate_url(passage) do
    "#{@base_url}?key=IP&passage=#{passage}&include-headings=false&output-format=plain-text&include-passage-references=false&include-footnotes=false&include-copyright=false&include-short-copyright=false&include-verse-numbers=false&include-first-verse-numbers=false"
  end

end

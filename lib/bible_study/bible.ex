defmodule BibleStudy.Bible do

  def find(passage) do
    url = passage
        |> parse_passage()
        |> generate_url()

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          body |> String.replace("=", "") |> String.replace("_", "")
      {:ok, %HTTPoison.Response{status_code: 404}} ->
          IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
          IO.inspect reason
    end
  end

  defp parse_passage(passage) do
    String.replace(passage.original, " ", "+")
  end

  defp generate_url(passage) do
    "http://www.esvapi.org/v2/rest/passageQuery?key=IP&passage=" <> passage <> "&include-headings=false&output-format=plain-text&include-passage-references=false&include-footnotes=false&include-copyright=false&include-short-copyright=false"
  end

end

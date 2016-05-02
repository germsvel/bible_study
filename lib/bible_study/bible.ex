defmodule BibleStudy.Bible do
  alias BibleStudy.HTTPClient

  @base_url "http://www.esvapi.org/v2/rest/passageQuery"

  def find(passage) do
    Task.async(__MODULE__, :request_passage, [passage])
    |> Task.await(3000)
  end

  def request_passage(passage) do
    passage
    |> parse_passage
    |> generate_url
    |> get_passage
  end

  defp get_passage(url) do
    {:ok, body} = HTTPClient.get(url)

    body
    |> String.replace("=", "")
    |> String.replace("_", "")
    |> String.strip
  end

  defp parse_passage(passage) do
    String.replace(passage.original, " ", "+")
  end

  defp generate_url(passage) do
    "#{@base_url}?key=IP&passage=#{passage}&include-headings=false&output-format=plain-text&include-passage-references=false&include-footnotes=false&include-copyright=false&include-short-copyright=false&include-verse-numbers=false&include-first-verse-numbers=false"
  end
end

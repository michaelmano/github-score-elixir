defmodule Github do
  def score(username \\ IO.gets "Github username: ") do
    username
    |> String.replace_trailing("\n", "")
    |> buildURL
    |> makeRequest
    |> Map.get(:body)
    |> Poison.Parser.parse!
    |> getDetails
    |> returnScore
  end

  def buildURL(username) do
    "https://api.github.com/users/" <> username <> "/events"
  end

  def makeRequest(url) do
    HTTPotion.get url, [ headers: [ "User-Agent": "My App" ]]
  end

  def getDetails(data) do
    Enum.map(data, fn(x) -> getScore(x["type"]) end)
  end

  def getScore(data) when data == "PushEvent", do: 5
  def getScore(data) when data == "CreateEvent", do: 4
  def getScore(data) when data == "IssuesEvent", do: 3
  def getScore(data) when data == "CommitEvent", do: 2
  def getScore(data), do: 1

  def returnScore(data) do
    "Your Github score is #{Enum.sum(data)}"
  end
end

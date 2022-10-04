import std/[strformat, xmltree, htmlparser]

import puppy, uri

import nimquery

proc scrapSite(
    searchMethod = "direct",
    searchCriteria: string,
    sortBy = "stroke"
  ): string =
  let req = Request(
    url: parseUrl("https://www.edbchinese.hk/lexlist_ch/result.jsp"),
    verb: "post",
    headers: @[Header(key: "Content-Type", value: "application/x-www-form-urlencoded")],
    body: encodeQuery(
      {
        "searchMethod": searchMethod,
        "searchCriteria": searchCriteria,
        "submit": "",
        "sortBy": sortBy,
        "jpC": "lshk"
      }
    )
  )
  result = fetch(req).body

# `word` must be string due to nim's string
# is using bits instead of code points
proc wordToCantoAudioLinks*(word: string): seq[string] =
  let xml = parseHtml(scrapSite(searchCriteria=word))
  let elements = xml.querySelectorAll("span.jyutping12 > strong > span > img")
  for element in elements:
    let jp = element.attr("onclick")[11..^3]
    result.add(fmt"https://www.edbchinese.hk/EmbziciwebRes/jyutping/{jp}.mp3")

proc wordToMandoAudioLinks*(word: string): seq[string] =
  let xml = parseHtml(scrapSite(searchCriteria=word))
  let elements = xml.querySelectorAll("td.pinyin12 > strong > span > img")
  for element in elements:
    let py = element.attr("onclick")[11..^3]
    result.add(fmt"https://www.edbchinese.hk/EmbziciwebRes/pinyin/{py}.mp3")

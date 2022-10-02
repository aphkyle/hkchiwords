import puppy, uri

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
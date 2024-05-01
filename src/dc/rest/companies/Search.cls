Class dc.rest.companies.Search Extends dc.rest.RestAbstract
{

ClassMethod GetCompanies() As %Status [ Language = python ]
{
    import iris
    import json

    key = iris.cls("dc.rest.RestAbstract").GetQueryStringValue("key")
    numberOfResults = iris.cls("dc.rest.RestAbstract").GetQueryStringValue("numberOfResults")
    pros = iris.cls("dc.rest.RestAbstract").GetQueryStringValue("pros")

    if key == "":
        print("No records returned.")
        return iris.cls("%SYSTEM.Status").OK()

    if numberOfResults == "":
        numberOfResults = 5
        
    pros = bool(pros) if pros != "" else True

    listSumarizeCompanies = []
    companies = iris.cls("dc.VectorSearch").vectorSearch(key,numberOfResults,pros)
    
    for firm in companies:
        summarize = {
            "Company" :  firm,
            "Sumarize": iris.cls("dc.Gpt").Summarize(firm)
        }
        listSumarizeCompanies.append(summarize)

    json_formatado = json.dumps(listSumarizeCompanies, indent=4)

    print(json_formatado)

    return iris.cls("%SYSTEM.Status").OK()
}

}

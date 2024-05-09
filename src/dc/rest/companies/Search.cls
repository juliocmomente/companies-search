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
        numberOfResults = 3
    
    if numberOfResults > 10:
        print("To many requests.")
        return iris.cls("%SYSTEM.Status").OK()

    pros = bool(pros) if pros != "" else True

    listSumarizeCompanies = []
    companies = iris.cls("dc.service.CompaniesService").vectorSearch(key,numberOfResults,pros)
    if len(companies) == 0:
        print("No records found.")
        return iris.cls("%SYSTEM.Status").OK()

    for glassdoorReview in companies:
        summarize = {
            "Company" : glassdoorReview.firm,
            "location" : glassdoorReview.location,
            "overallRating" : glassdoorReview.overallRating,
            "Sumarize": iris.cls("dc.Gpt").Summarize(glassdoorReview.firm)
        }
        listSumarizeCompanies.append(summarize)

    json_formatado = json.dumps(listSumarizeCompanies, indent=4)
    print(json_formatado)

    return iris.cls("%SYSTEM.Status").OK()
}

}

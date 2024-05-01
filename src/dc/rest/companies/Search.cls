Class dc.rest.companies.Search Extends dc.rest.RestAbstract
{

ClassMethod GetCompanies() As %Status [ Language = python ]
{
    import iris
    key = iris.cls("dc.rest.RestAbstract").GetQueryStringValue("key")
    numberOfResults = iris.cls("dc.rest.RestAbstract").GetQueryStringValue("numberOfResults")
    prosOrCons = iris.cls("dc.rest.RestAbstract").GetQueryStringValue("prosOrCons")

    companies = iris.cls("dc.VectorSearch").vectorSearch(key,numberOfResults,prosOrCons)
    
    for row in companies:
        firm = row[0]

    
    return iris.cls("%SYSTEM.Status").OK()
}

}

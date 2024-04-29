Class dc.rest.companies.Search Extends dc.rest.RestAbstract
{

ClassMethod GetCompanies() As %Status
{
    Set key = ..GetQueryStringValue("key")
    Set numberOfResults = ..GetQueryStringValue("numberOfResults")
    Set prosOrCons = ..GetQueryStringValue("prosOrCons")
    
    //Set jsonString = "{key:""_key_"",numberOfResults:""_numberOfResults_"",prosOrCons:""_prosOrCons""}"
    Write {"ping":"pong"}.%ToJSON()
    Return $$$OK
}

}
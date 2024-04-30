Class dc.rest.companies.Search Extends dc.rest.RestAbstract
{

ClassMethod GetCompanies() As %Status
{
    Set key = ..GetQueryStringValue("key")
    Set numberOfResults = ..GetQueryStringValue("numberOfResults")
    Set prosOrCons = ..GetQueryStringValue("prosOrCons")
    
    //Set jsonString = "{key:""_key_"",numberOfResults:""_numberOfResults_"",prosOrCons:""_prosOrCons""}"
    Write {"ping":"pong"}.%ToJSON()

    //Set response = ##class(ListResponseDto).%New()
    //Set CompaniesList = ##class(%ListOfDataTypes).%New()
    //Set results = ..vectorSearch(pKey,pQtd,pPros)

    //For i=1:1:CompaniesList.Count(){
    //    Set respondeDto = gpt.summarize(CompaniesList.GetAt(i))
    //    Do response.Insert(respondeDto)
    //}
    //TODO
    //Return response

    Return $$$OK
}

}

Class dc.rest.VectorSearch Extends %RegisteredObject{

    Property Gpt as dc.Gpt;

    ClassMethod Search(pKey As %String, pNumberOfResults As %Integer, pPros As %Boolean) As dc.dto.CompaniesResponseDto {
        
        /*Set response = ##class(ListResponseDto).%New()

        Set CompaniesList = ##class(%ListOfDataTypes).%New()

        For i=1:1:CompaniesList.Count(){
            Set respondeDto = gpt.summarize(CompaniesList.GetAt(i))
            Do response.Insert(respondeDto)
        }
        //TODO
        Return response*/
    }
}

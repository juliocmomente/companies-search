Class dc.VectorSearch Extends %RegisteredObject{

    Property gpt as dc.gpt;

    ClassMethod search(pKey As %String, pQtd As %Integer, pPros As %Boolean) As ListRespondeDto {
        
        Set response = ##class(ListResponseDto).%New()
        Set CompaniesList = ##class(%ListOfDataTypes).%New()

        For i=1:1:CompaniesList.Count(){
            Set respondeDto = gpt.summarize(CompaniesList.GetAt(i))
            Do response.Insert(respondeDto)
        }
        //TODO
        Return response
    }

}

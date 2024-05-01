Class dc.dao.CompaniesDao Extends %RegisteredObject
{

ClassMethod GetRsCompanies(pKey As %String, pNumberOfResults As %Integer) As %SQL.Statement
{
    Set sql = "SELECT TOP "_ pNumberOfResults _
                "firm, jobTitle, pros, cons "_
                "FROM reviews "_
                "WHERE UPPER(firm) [ UPPER(?) OR UPPER(jobTitle) [ UPPER(?) "
    Set stm = ##class(%SQL.Statement).%New()
    $$$ThrowOnError(sc, stm.%Prepare(sql))
    Return stm
}

}

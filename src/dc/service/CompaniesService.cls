Class dc.service.CompaniesService Extends %RegisteredObject
{

ClassMethod ReviewsCompany(pCompany As %String) As %List [ Language = python ]
{
    import iris
    listreviews = []
    stmt = iris.sql.prepare("SELECT TOP 50 firm, jobTitle, pros, cons FROM reviews WHERE firm = ?")
    rs = stmt.execute(pCompany)
    for idx, row in enumerate(rs):
        listreviews.append(f'About {row[0]} work with {row[1]} positive points: {row[2]}.\n negative points: {row[3]}.')
        
    return listreviews
}

}

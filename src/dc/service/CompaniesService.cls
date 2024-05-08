Class dc.service.CompaniesService Extends %RegisteredObject
{

ClassMethod ReviewsCompany(pCompany As %String) As %List [ Language = python ]
{
    import iris
    listreviews = []
    stmt = iris.sql.prepare("SELECT TOP 50 firm, pros, cons FROM dc_data.GlassdoorReviews WHERE firm = ?")
    rs = stmt.execute(pCompany)
    for idx, row in enumerate(rs):
        listreviews.append(f'About {row[0]} positive points: {row[1]}.\n negative points: {row[2]}.')
        
    return listreviews
}

ClassMethod vectorSearch(pKey As %String, pQtd As %Integer, pPros As %Boolean) As %String [ Language = python ]
{
    import os
    from sentence_transformers import SentenceTransformer
    import iris

    query = """SELECT DISTINCT TOP {0} firm FROM dc_data.GlassdoorReviews ORDER BY VECTOR_DOT_PRODUCT({1}, TO_VECTOR(?)) DESC """
    if pPros:
        query = query.format(pQtd,"prosVector")
    else :
        query = query.format(pQtd,"consVector")
    
    
    model = SentenceTransformer('all-MiniLM-L6-v2') 
    search_vector = model.encode(pKey, normalize_embeddings=True).tolist()
    
    results = []
    stmt = iris.sql.prepare(query)
    rs = stmt.execute(str(search_vector))
    for idx, row in enumerate(rs):
        results.append(row[0])
    
    return results
}

}

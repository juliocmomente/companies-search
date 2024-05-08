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

    stop_words = {'my', 'here', 've', 'above', 'very', 'hadn', 'his', 'each', 'only', 'shan', 'wasn', 'are', 'isn', 'is', 'been', 'while', 'in', 'by', 'these', 'i', 'her', 'him', "you'll", 'because', 'does', 'an', 'until', 'yourself', 'of', 'through', 'couldn', 'a', 'weren', 'wouldn', 'o', 'those', 'having', 'yours', 'itself', 're', 'am', 'about', 'their', 'there', 'from', 'being', "haven't", 'your', 'few', 'do', 'or', "didn't", "don't", 'who', 'ours', 'such', 'that', 't', 'doesn', 'myself', 'if', 'no', 'as', 'had', 'now', 'ain', "needn't", 'why', 'on', 'll', 'mightn', "weren't", 'aren', 'shouldn', 'has', 'than', 'under', 'them', 'into', 'hasn', "that'll", 'again', 'both', 'after', 'its', "shan't", 'we', 'be', "you'd", "hadn't", "mustn't", 'to', 'not', "you're", 'did', 'y', 'she', 'and', 'themselves', 'too', 'any', 'but', 'once', 'with', 'd', 'don', 'haven', 'needn', 'can', "wasn't", 'just', "wouldn't", 'nor', 'what', 'at', 'our', 'should', "hasn't", 'during', 'all', 'me', 'further', 'where', "isn't", "she's", 'hers', 's', 'have', 'over', 'most', 'will', 'yourselves', 'this', 'between', 'down', 'mustn', 'ma', "won't", 'ourselves', 'out', 'theirs', 'didn', "couldn't", 'whom', "it's", 'more', "you've", 'which', "doesn't", 'then', 'against', 'they', 'he', 'it', "should've", 'below', "aren't", 'doing', 'before', 'own', 'the', 'were', 'm', 'you', 'how', 'same', "mightn't", 'herself', 'for', 'when', 'himself', 'won', 'up', 'off', 'other', "shouldn't", 'so', 'was', 'some'}

    if isinstance(pKey,str) and len(pKey) > 1:
        words = pKey.split()
        filtered_words = [word for word in words if word.lower() not in stop_words]
        pKey = ' '.join(filtered_words)

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

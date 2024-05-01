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

ClassMethod vectorSearch(pKey As %String, pQtd As %Integer, pPros As %Boolean) As %String [ Language = python ]
{
        import os
        from sentence_transformers import SentenceTransformer
        import iris
        from sqlalchemy import create_engine, text

        username = '_SYSTEM'
        password = 'SYS'
        hostname = os.getenv('IRIS_HOSTNAME', 'localhost')
        port = '1972' 
        namespace = 'USER'
        CONNECTION_STRING = f"iris://{username}:{password}@{hostname}:{port}/{namespace}"
        engine = create_engine(CONNECTION_STRING, connect_args={'timeout': 300},pool_size=10,max_overflow=2,pool_recycle=600,pool_pre_ping=True)

        query = """SELECT DISTINCT TOP {0} firm FROM dc_data.GlassdoorReviews ORDER BY VECTOR_DOT_PRODUCT({1}, TO_VECTOR(:search_vector)) DESC """
        if pPros:
            query = query.format(pQtd,"prosVector")
        else :
            query = query.format(pQtd,"consVector")

        model = SentenceTransformer('all-MiniLM-L6-v2') 
        search_vector = model.encode(pKey, normalize_embeddings=True).tolist()
        results = ""
        with engine.connect() as conn:
            with conn.begin():
                sql = text(query)
                results = conn.execute(sql, {'search_vector': str(search_vector)}).fetchall()
        print (results)
        return results
}

}

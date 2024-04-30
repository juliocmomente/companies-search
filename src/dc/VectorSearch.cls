Class dc.VectorSearch Extends %RegisteredObject
{

ClassMethod vectorSearch(pKey As %String, pQtd As %Integer, pPros As %Boolean) As %String [ Language = python ]
{
        from sentence_transformers import SentenceTransformer
        from sqlalchemy import create_engine, text

        username = 'demo'
        password = 'demo'
        hostname = os.getenv('IRIS_HOSTNAME', 'localhost')
        port = '1972' 
        namespace = 'USER'
        CONNECTION_STRING = f"iris://{username}:{password}@{hostname}:{port}/{namespace}"
        engine = create_engine(CONNECTION_STRING)

        query = """SELECT DISTINCT TOP {0} firm FROM glassdoor_reviews ORDER BY VECTOR_DOT_PRODUCT({1}, TO_VECTOR(:search_vector)) DESC """
        if pPros:
            query = query.format(pQtd,"pros_vector")
        else :
            query = query.format(pQtd,"cons_vector")

        model = SentenceTransformer('all-MiniLM-L6-v2') 
        search_vector = model.encode(pKey, normalize_embeddings=True).tolist() # Convert search phrase into a vector
        results = ""
        with engine.connect() as conn:
            with conn.begin():
                sql = text(query)
                results = conn.execute(sql, {'search_vector': str(search_vector)}).fetchall()
        return results
}

}

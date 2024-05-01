Class dc.VectorSearch Extends %RegisteredObject
{

ClassMethod vectorSearch(pKey As %String, pQtd As %Integer, pPros As %Boolean) As %List [ Language = python ]
{
        return ["google", "IBM"]
        from sentence_transformers import SentenceTransformer
        import iris
        #from sqlalchemy import create_engine, text

        #username = 'demo'
        #password = 'demo'
        #hostname = os.getenv('IRIS_HOSTNAME', 'localhost')
        #port = '1972' 
        #namespace = 'USER'
        #CONNECTION_STRING = f"iris://{username}:{password}@{hostname}:{port}/{names+pace}"
        #engine = create_engine(CONNECTION_STRING)

        import iris
        listreviews = []
        stmt = iris.sql.prepare("SELECT DISTINCT TOP {0} firm FROM reviews ORDER BY VECTOR_DOT_PRODUCT({1}, TO_VECTOR(:search_vector)) DESC")
        
        rs = stmt.execute(pCompany)
        for idx, row in enumerate(rs):
            listreviews.append(f'About {row[0]} work with {row[1]} positive points: {row[2]}.\n negative points: {row[3]}.')
            
        return listreviews



        
        if pPros:
            query = query.format(pQtd,"pros_vector")
        else :
            query = query.format(pQtd,"cons_vector")

        model = SentenceTransformer('all-MiniLM-L6-v2') 
        search_vector = model.encode(pKey, normalize_embeddings=True).tolist()
        results = ""
        with engine.connect() as conn:
            with conn.begin():
                sql = text(query)
                results = conn.execute(sql, {'search_vector': str(search_vector)}).fetchall()
        return results
}

}

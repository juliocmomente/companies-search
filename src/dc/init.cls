Class dc.init Extends %RegisteredObject
{
    ClassMethod init() [ Language = python ] {
        import os, pandas as pd
        from sentence_transformers import SentenceTransformer
        from sqlalchemy import create_engine, text

        username = 'demo'
        password = 'demo'
        hostname = os.getenv('IRIS_HOSTNAME', 'localhost')
        port = '1972' 
        namespace = 'USER'
        CONNECTION_STRING = f"iris://{username}:{password}@{hostname}:{port}/{namespace}"

        engine = create_engine(CONNECTION_STRING)

        # Load the CSV file
        df = pd.read_csv('../data/glassdoor_reviews.csv')
        
        # drop columns
        df.drop(columns=df.columns[1], inplace=True)
        df.drop(columns=df.columns[2], inplace=True)
        df.drop(columns=df.columns[3], inplace=True)
        df.drop(columns=df.columns[6], inplace=True)
        df.drop(columns=df.columns[7], inplace=True)
        df.drop(columns=df.columns[8], inplace=True)
        df.drop(columns=df.columns[9], inplace=True)
        df.drop(columns=df.columns[10], inplace=True)
        df.drop(columns=df.columns[11], inplace=True)
        df.drop(columns=df.columns[12], inplace=True)
        df.drop(columns=df.columns[13], inplace=True)
        df.drop(columns=df.columns[14], inplace=True)

        # Remove rows without a evaluation
        df.dropna(subset=['pros'], inplace=True)
        df.dropna(subset=['cons'], inplace=True)

        with engine.connect() as conn:
            with conn.begin():# Load 
                sql = f"""
                        CREATE TABLE glassdoor_reviews (
                firm VARCHAR(255),
                location VARCHAR(255),
                overall_rating INT,
                headline VARCHAR(2000),
                pros VARCHAR(2000),
                pros_vector VECTOR(DOUBLE, 384),
                cons VARCHAR(2000),
                cons_vector VECTOR(DOUBLE, 384)
                )
                        """
                result = conn.execute(text(sql))
        
        model = SentenceTransformer('all-MiniLM-L6-v2') 
        #encoding pros
        embeddings = model.encode(df['pros'].tolist(), normalize_embeddings=True)
        df['pros_vector'] = embeddings.tolist()

        #encoding cons
        embeddings = model.encode(df['cons'].tolist(), normalize_embeddings=True)
        df['cons_vector'] = embeddings.tolist()

        with engine.connect() as conn:
            with conn.begin():
                for index, row in df.iterrows():
                    sql = text("""
                        INSERT INTO glassdoor_reviews 
                        (firm, location, overall_rating, headline, pros, pros_vector, cons, cons_vector) 
                        VALUES (:firm, :location, :overall_rating, :headline, :pros, TO_VECTOR(:pros_vector), :cons, TO_VECTOR(:cons_vector))
                    """)
                    conn.execute(sql, {
                        'firm': row['firm'], 
                        'location': row['location'], 
                        'overall_rating': row['overall_rating'], 
                        'headline': row['headline'], 
                        'pros': row['pros'], 
                        'pros_vector': str(row['pros_vector']),
                        'cons': row['cons'], 
                        'cons_vector': str(row['cons_vector'])
                    })

    }

}
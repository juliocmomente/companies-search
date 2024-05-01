Class dc.init Extends %RegisteredObject
{

ClassMethod init() [ Language = python ]
{
    print("start")
    
    import os, pandas as pd
    from sentence_transformers import SentenceTransformer
    from sqlalchemy import create_engine, text
    
    username = '_SYSTEM'
    password = 'SYS'
    hostname = os.getenv('IRIS_HOSTNAME', 'localhost')
    port = '1972' 
    namespace = 'USER'
    CONNECTION_STRING = f"iris://{username}:{password}@{hostname}:{port}/{namespace}"

    engine = create_engine(CONNECTION_STRING, connect_args={'timeout': 300},pool_size=10,max_overflow=2,pool_recycle=600,pool_pre_ping=True)
    
    print("Start loading csv file")
    # Load the CSV file
    df = pd.read_csv('/opt/irisbuild/data/glassdoor_reviews.csv')
    df = df[:10000]
    print("finish loading csv file")
    
    print("Start adjusting data")
    # drop columns
    df.drop(columns=df.columns[14], inplace=True)
    df.drop(columns=df.columns[13], inplace=True)
    df.drop(columns=df.columns[12], inplace=True)
    df.drop(columns=df.columns[11], inplace=True)
    df.drop(columns=df.columns[10], inplace=True)
    df.drop(columns=df.columns[9], inplace=True)
    df.drop(columns=df.columns[8], inplace=True)
    df.drop(columns=df.columns[7], inplace=True)
    df.drop(columns=df.columns[6], inplace=True)
    df.drop(columns=df.columns[3], inplace=True)
    df.drop(columns=df.columns[2], inplace=True)
    df.drop(columns=df.columns[1], inplace=True)

    # Remove rows without a evaluation
    df.dropna(subset=['pros'], inplace=True)
    df.dropna(subset=['cons'], inplace=True)
    print("Finish adjusting data")
    numOfRows = len(df)
    print(f'rows = {numOfRows}')
    
    
    print("Creating model and encoding embedings")
    model = SentenceTransformer('all-MiniLM-L6-v2') 
    #encoding pros
    embeddings = model.encode(df['pros'].tolist(), normalize_embeddings=True)
    df['pros_vector'] = embeddings.tolist()

    #encoding cons
    embeddings = model.encode(df['cons'].tolist(), normalize_embeddings=True)
    df['cons_vector'] = embeddings.tolist()

    print("Filling table")
    with engine.connect() as conn:
        with conn.begin():
            for index, row in df.iterrows():
                sql = text("""
                    INSERT INTO dc_data.GlassDoorReviews 
                    (firm, location, overallRating, headline, pros, prosVector, cons, consVector) 
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

Class dc.service.InitService Extends %RegisteredObject
{

ClassMethod init() [ Language = python ]
{
    print("start")
    
    import os, pandas as pd
    from sentence_transformers import SentenceTransformer
    import iris
    
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
    query = """
                INSERT INTO dc_data.GlassDoorReviews 
                (firm, location, overallRating, headline, pros, prosVector, cons, consVector) 
                VALUES (?, ?, ?, ?, ?, TO_VECTOR(?), ?, TO_VECTOR(?))
            """
    stmt = iris.sql.prepare(query)
    for index, row in df.iterrows():
        rs = stmt.execute(row['firm'],row['location'],row['overall_rating'],row['headline'],row['pros'],str(row['pros_vector']),row['cons'],str(row['cons_vector']))
}

}

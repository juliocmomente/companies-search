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
    df = df[:30000]
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
    
    stop_words = {'my', 'here', 've', 'above', 'very', 'hadn', 'his', 'each', 'only', 'shan', 'wasn', 'are', 'isn', 'is', 'been', 'while', 'in', 'by', 'these', 'i', 'her', 'him', "you'll", 'because', 'does', 'an', 'until', 'yourself', 'of', 'through', 'couldn', 'a', 'weren', 'wouldn', 'o', 'those', 'having', 'yours', 'itself', 're', 'am', 'about', 'their', 'there', 'from', 'being', "haven't", 'your', 'few', 'do', 'or', "didn't", "don't", 'who', 'ours', 'such', 'that', 't', 'doesn', 'myself', 'if', 'no', 'as', 'had', 'now', 'ain', "needn't", 'why', 'on', 'll', 'mightn', "weren't", 'aren', 'shouldn', 'has', 'than', 'under', 'them', 'into', 'hasn', "that'll", 'again', 'both', 'after', 'its', "shan't", 'we', 'be', "you'd", "hadn't", "mustn't", 'to', 'not', "you're", 'did', 'y', 'she', 'and', 'themselves', 'too', 'any', 'but', 'once', 'with', 'd', 'don', 'haven', 'needn', 'can', "wasn't", 'just', "wouldn't", 'nor', 'what', 'at', 'our', 'should', "hasn't", 'during', 'all', 'me', 'further', 'where', "isn't", "she's", 'hers', 's', 'have', 'over', 'most', 'will', 'yourselves', 'this', 'between', 'down', 'mustn', 'ma', "won't", 'ourselves', 'out', 'theirs', 'didn', "couldn't", 'whom', "it's", 'more', "you've", 'which', "doesn't", 'then', 'against', 'they', 'he', 'it', "should've", 'below', "aren't", 'doing', 'before', 'own', 'the', 'were', 'm', 'you', 'how', 'same', "mightn't", 'herself', 'for', 'when', 'himself', 'won', 'up', 'off', 'other', "shouldn't", 'so', 'was', 'some'}

    def remove_stop_words(text=""):
        if isinstance(text,str) and len(text) > 1:
            words = text.split()
            filtered_words = [word for word in words if word.lower() not in stop_words]
            return ' '.join(filtered_words)
        return text
    df['pros_without_stopwords'] = df['pros'].apply(remove_stop_words)
    df['cons_without_stopwords'] = df['cons'].apply(remove_stop_words)
    
    print("Creating model and encoding embedings")
    model = SentenceTransformer('all-MiniLM-L6-v2') 
    #encoding pros
    embeddings = model.encode(df['pros_without_stopwords'].tolist(), normalize_embeddings=True)
    df['pros_vector'] = embeddings.tolist()

    #encoding cons
    embeddings = model.encode(df['cons_without_stopwords'].tolist(), normalize_embeddings=True)
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

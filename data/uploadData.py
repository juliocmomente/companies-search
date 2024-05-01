import pandas as pd
from sentence_transformers import SentenceTransformer
import iris

df = pd.read_csv('/opt/irisbuild/data/glassdoor_reviews.csv')

model = SentenceTransformer('all-MiniLM-L6-v2')

df = df[['firm', 'job_title', 'pros', 'cons' ]]

#encoding pros
embeddings = model.encode(df['pros'].tolist(), normalize_embeddings=True)
df['pros_vector'] = embeddings.tolist()

#encoding cons
embeddings = model.encode(df['cons'].tolist(), normalize_embeddings=True)
df['cons_vector'] = embeddings.tolist()


sql = f"""
                CREATE TABLE reviews (
                    firm VARCHAR(255),
                    jobTitle VARCHAR(255),
                    pros VARCHAR(200000),
                    pros_vector VECTOR(DOUBLE, 384),
                    cons VARCHAR(200000),
                    cons_vector VECTOR(DOUBLE, 384)

                )
            """
result = iris.sql.exec(sql)

for index, row in df.iterrows():
    try:
        #stmt = iris.sql.prepare("INSERT INTO reviews (firm, jobTitle, pros, cons) VALUES (?, ?, ?, ?)") FIND python ERROR  irisbuiltins.SQLError: <UNIMPLEMENTED>term+84^%qaqpslx
        #https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=AFL_epython#AFL_epython_pylibrary

        glassdoor_review = iris.cls("User.reviews")._New()
        glassdoor_review.firm = row['firm']
        glassdoor_review.jobTitle = row['job_title']
        glassdoor_review.pros = row['pros']
        glassdoor_review.cons = row['cons']
        glassdoor_review._Save()

    except Exception as ex:
        print(ex)
# Companies Search
The Companies Search is a REST API based on InterSystems Vector Search, designed to retrieve companies from a vector database using keywords. The API can locate companies that have semantic similarity with the provided keywords, ensuring relevant and accurate results.

Once the companies are located, the API utilizes ChatGPT for IRIS to process the data and generate informative summaries. These summaries provide users with an overview of the companies returned by the vector search. Additionally, users have the option to request summaries focusing on "positive" or "negative" aspects of the companies.

Essentially, this platform offers users the ability to quickly obtain initial impressions of specific companies, whether for potential collaboration or service provision purposes.

## Índice

- [Installation](#Installation)
- [Solution](#Solution)
    - [Architectural modeling](#Architectural-modelingl)
    - [Logic modeling](#Logic-modeling)
    - [Data input](#Data-input)
    - [Data output](#Data-output)
- [Technologies](#Technologies)
- [Architecture](#Architecture)


## Installation

1. Clone the repo
```Shell
git clone https://github.com/juliocmomente/companies-search.git
```

2. For using companies search, you need a OpenAI key, access: [OpenAI Key](https://platform.openai.com/api-keys)

3. Click in "Create new secret key" button, type the optional field and click on "Create secret key" button.

![alt text](/src/dc/assets/create-new-secret-key.png)

4. Update the corresponding entry in `docker-compose.yml`

![alt text](/src/dc/assets/docker-compose-example.png)

5. Start the Docker containers:
    ```Shell
    docker-compose up
    ```
    OBS: The `Dockerfile` has all configurations you need to start the project. The first run will probably take a few minutes to download all dependencies and create the vectorized database.

## Solution

An API with a single endpoint has been developed:

* `GET`, designed to retrieve companies stored in the vector database and return them in JSON format.

The database was acquired from [Kaggle](#https://www.kaggle.com/datasets/davidgauthier/glassdoor-job-reviews/data) and will be represented by a single table called `GlassdoorReview`.

Finally, a service class named `InitService` was created, which includes a method developed in **Embedded Python** to read the lines from the **CSV** file, insert them, and transform them into **VECTOR** type.

Below is a detailed explanation of the modeling used in the project.

### Architectural modeling

![alt text](/src/dc/assets/architectural-modeling.png)

### Logic modeling

![alt text](/src/dc/assets/logic-modeling.png)

### Data input

The API can be accessed via the following address: 

```Shell 
http://localhost:52773/api/companies/search
```
To perform the company search, this endpoint accepts up to 3 parameters to facilitate the search:

* `key`: This parameter is the main search filter. Here you should enter a word or sentence to be searched into companies reviews (pros or cons). The search engine is based on vector search. 

    So, you can search for characteristics that you want to find in companies, such as: **flexible hours**, in this scenario, the API will search for companies operating in this format.

    `e.g.:` 
    ```Shell
    http://localhost:52773/api/companies/search?flexible
    ```

    **OBS:** If this parameter is not provided, the API will not perform any search and will return the following error to the user: `No records returned.`

* `numberOfResults`: This parameter is not mandatory. You can specify the number of companies you want to recover. It is important to note that vector search will not always be able to find the desired number of results. So if you, for example, specify the value 10, it means that it will search up to 10 companies.

    `e.g.:` 
    ```Shell
    http://localhost:52773/api/companies/search?Google&numberOfResults=10
    ```

    **OBS:** If this parameter is not informed, the initial value will be 5.

* `pros`: This parameter is optional and is of boolean type. It tells the API whether we want to locate companies based on Pros or Cons, that is, positive or negative aspects. Based on this parameter, Chat GPT will compile the corresponding summary.

    `e.g.:` 
    ```Shell
    http://localhost:52773/api/companies/search?Google&numberOfResults=10&pros=0
    ```
    **OBS:** If this parameter is not informed, the initial value will always be 1 (true), that is, it will only look for positive points.

### Data output:

When making the request, consider the following response format in JSON:

````json
[
    {
        "company": "Google",
        "summarize": "Summary provided by Chat GPT for the company Google"
    },
    {
        "company": "IBM",
        "summarize": "Summary provided by Chat GPT for the company IBM"
    }

]
````

## Technologies

Technologies applied in the project:
- **Vector Search**: Used as a company search engine, using words that share similar semantic meaning.
    
- **Large Language Model (LLM): Chat GPT**: Used to prepare a summary of the companies returned by the vector search.

- **Embedded Python**: Used to create all application scripts, such as:
    - Assembling the vector database by inserting VECTOR type data.
    - Rest API to receive input data from the external environment and process it with vector search and GPT Chat.
    - Integration script between vector search results and use of GPT Chat.

- **Docker container**: Used to create the IRIS environment and application, so that, using a single command: `docker-compose up`, the entire project is ready for use.

- **InterSystems IRIS**: Used for creating the vector database and structuring the Rest API.

- **ObjectScript**: Used to create Rest API communication, using native extension: `%CSP.REST`

## Architecture

The project was developed using a layered architecture to separate responsibilities for code, database and business rules.

Packages: 
* `data`: Structuring persistence
* `rest`: Mapping and structuring all Rest API.
    * `companies`: Contains the application's only endpoint, /search, for searching for companies.
* `service`: Business rules and validations, as well as vector database searches.

![alt text](/src/dc/assets/packages.png)





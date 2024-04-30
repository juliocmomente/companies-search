Class dc.Gpt Extends %RegisteredObject [ Language = python ]
{

ClassMethod Summarize(pCompany As %String) As %String
{
        import iris
        import requests
        import os
        import json

        payload = {
            "model": "gpt-3.5-turbo",
            "messages": [
                {
                    "role": "system",
                    "content": "You are a virtual assistant who receives texts about a company from several users. Return a simple summary text, with positive and negative points of the company received Please summarize the texts provided by the company"
                }
            ],
            "temperature": 1,
            "max_tokens": 256,
            "top_p": 1,
            "frequency_penalty": 0,
            "presence_penalty": 0
        }

        request_header = {
            "Authorization": "Bearer " + os.getenv('OPENAI_API_KEY', 'null'),
            "Content-Type": "application/json"
        }
        
        listreviews = iris.cls("dc.service.CompaniesService").getReviewsCompany(pCompany)
        for review in listreviews:
            payload["messages"].append({"role": "user", "content": review})
        
        json_payload = json.dumps(payload)

        url = "https://api.openai.com/v1/chat/completions"
        response = requests.post(url, headers=request_header, data=json_payload)

        if response.status_code == 200:
            content =  iris.cls("dc.Gtp").ExtractContentFromResponse(response.json())
            return f"{content}"
        return "None"
}

ClassMethod ExtractContentFromResponse(response) As %String
{
    try:
        choices = response.get("choices")
        if choices and len(choices) > 0:
            first_choice = choices[0]
            message = first_choice.get("message")
            if message:
                content = message.get("content")
                return content
    except Exception as e:
        print("[ChatGPT] Error: Unable to parse response:", str(e))
    return None
}

}

//
//  ChatGenerator.swift
//  Tomo
//
//  Created by Dayem Saeed on 10/12/23.
//

import Alamofire

func generateText(messages: [[String: Any]], completion: @escaping (String?) -> Void) {
    let headers: HTTPHeaders = [
        "Authorization": "Bearer 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",
        "Content-Type": "application/json"
    ]
    let parameters: Parameters = [
        "model": "gpt-4",
        "messages": messages
    ]

    AF.request("https://api.openai.com/v1/chat/completions",
               method: .post,
               parameters: parameters,
               encoding: JSONEncoding.default,
               headers: headers).responseDecodable(of: GPTResponse.self) { response in
        switch response.result {
        case .success(let gptResponse):
            let responseText = gptResponse.choices.first?.message.content
            completion(responseText)
        case .failure(_):
            completion(nil)
            print(response.error)
        }
    }
}

struct GPTResponse: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable {
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}


//
//  ChatService.swift
//  Tomo
//
//  Created by Dayem Saeed on 3/28/24.
//

import Foundation
import Alamofire

class ChatService {
    func generateText(messages: [[String: Any]], completion: @escaping (String?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh6Y21laHJtbW5zdHFyb3Z3YWJ4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTEyMjk3MzgsImV4cCI6MjAyNjgwNTczOH0.8UcMGluU4HlJqklHzMRn2aBjDQskr0mvY3c2b7w0PTs",
            "Content-Type": "application/json"
        ]
        let parameters: Parameters = [
            "messages": messages
        ]

        AF.request("https://xzcmehrmmnstqrovwabx.supabase.co/functions/v1/tomo-bot",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers).responseDecodable(of: GPTResponse.self) { response in
            switch response.result {
            case .success(let gptResponse):
                let responseText = gptResponse.choices.first?.message.content
                completion(responseText)
            case .failure(_):
                completion("My bad. I couldn't think of anything to say right now. Maybe check your internet connection and try again?")
            }
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


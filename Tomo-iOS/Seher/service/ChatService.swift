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
        guard let infoDictionary = Bundle.main.infoDictionary else { return }
        guard let key = infoDictionary["SUPABASE_KEY"] as? String else { return }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + key,
            "Content-Type": "application/json"
        ]
        let parameters: Parameters = [
            "messages": messages
        ]
        
        let url = "https://xzcmehrmmnstqrovwabx.supabase.co/"
        guard let botUri = infoDictionary["BOT_URI"] as? String else { return }
        
        AF.request(url + botUri,
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

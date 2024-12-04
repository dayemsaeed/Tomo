//
//  ChatService.swift
//  Tomo
//
//  Created by Dayem Saeed on 3/28/24.
//

import Foundation
import Alamofire

/// The `ChatService` class is responsible for making API requests to generate chat responses from a bot.
class ChatService {
    
    /// Sends a list of messages to the bot API and receives a generated response.
    /// - Parameters:
    ///   - messages: An array of dictionaries, each containing message data.
    ///   - completion: A closure that returns a generated response string or an error message.
    func generateText(messages: [[String: Any]], completion: @escaping (String?) -> Void) {
        guard let apiKey = Bundle.main.infoDictionary?["SUPABASE_KEY"] as? String,
              let baseUri = Bundle.main.infoDictionary?["BOT_URI"] as? String else {
            completion("App configuration error: Missing API key or URI.")
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + apiKey,
            "Content-Type": "application/json"
        ]
        
        let parameters: Parameters = [
            "messages": messages
        ]
        
        let url = "https://xzcmehrmmnstqrovwabx.supabase.co/" + baseUri
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers).responseDecodable(of: GPTResponse.self) { response in
            switch response.result {
            case .success(let gptResponse):
                let responseText = gptResponse.choices.first?.message.content
                completion(responseText)
            case .failure(let error):
                print("Error in API request: \(error.localizedDescription)")
                completion("My bad. I couldn't think of anything to say right now. Maybe check your internet connection and try again?")
            }
        }
    }
}

/// Represents the structure of the GPT response from the API
struct GPTResponse: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable {
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}

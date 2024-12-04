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
        
        // Fetch the Supabase API key from environment variables or fallback to Info.plist
        let apiKey: String
        if let environmentKey = ProcessInfo.processInfo.environment["SUPABASE_KEY"] {
            apiKey = environmentKey // Use environment variable
        } else if let configKey = Bundle.main.infoDictionary?["SUPABASE_KEY"] as? String {
            apiKey = configKey // Use Info.plist for local development
        } else {
            completion("App configuration error: Supabase key missing.")
            return
        }
        
        // Fetch the BOT_URI from environment variables or fallback to Info.plist
        let baseUri: String
        if let environmentUri = ProcessInfo.processInfo.environment["BOT_URI"] {
            baseUri = environmentUri // Use environment variable
        } else if let configUri = Bundle.main.infoDictionary?["BOT_URI"] as? String {
            baseUri = configUri // Use Info.plist for local development
        } else {
            completion("App configuration error: BOT_URI missing.")
            return
        }
        
        // Define request headers with the API key and content type
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + apiKey,
            "Content-Type": "application/json"
        ]
        
        // Define request parameters containing the messages to send
        let parameters: Parameters = [
            "messages": messages
        ]
        
        // Construct the complete URL
        let url = "https://xzcmehrmmnstqrovwabx.supabase.co/" + baseUri
        
        // Perform the API request using Alamofire
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers).responseDecodable(of: GPTResponse.self) { response in
            switch response.result {
            case .success(let gptResponse):
                // Extract the content of the first choice's message and return it via the completion handler
                let responseText = gptResponse.choices.first?.message.content
                completion(responseText)
            case .failure(let error):
                // Handle the failure by returning an error message
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

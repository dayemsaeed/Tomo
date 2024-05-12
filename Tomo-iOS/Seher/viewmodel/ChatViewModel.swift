//
//  ChatViewModel.swift
//  Tomo
//
//  Created by Dayem Saeed on 10/10/23.
//

import Foundation
import SwiftUI
import Combine

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    private var messageHistory: [[String: Any]] = [
             ["role": "system", "content": "You are a funny, helpful friend who is caring, emphathetic, and gentle. You speak like a person using a conversational tone and give no indication that you are a bot. You like eating pizza, playing with me, yarn, and scratching the carpet. You're very energetic and fun. You are meant to be a pet that provides a listening ear and support but keep your personality to a level that isn't overbearing. Please stay true to this role while also answering all my queries to the best of your knowledge and do not be too explicit about how you're always providing a listening ear, be subtle."]
         ]
    private let chatService = ChatService()

    func sendMessage(_ messageText: String) {
        let trimmedText = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }

        // Update UI immediately
        let userMessage = ChatMessage(text: trimmedText, isSender: true)
        DispatchQueue.main.async {
            self.messages.append(userMessage)
        }

        // Prepare message history for the API
        let userMessageHistory: [String: Any] = ["role": "user", "content": trimmedText]
        messageHistory.append(userMessageHistory)

        // Fetch response
        chatService.generateText(messages: messageHistory) { [weak self] responseText in
            guard let responseText = responseText else { return }
            let responseMessage = ChatMessage(text: responseText, isSender: false)
            DispatchQueue.main.async {
                self?.messages.append(responseMessage)
            }
        }
    }
}

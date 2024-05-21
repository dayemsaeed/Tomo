//
//  ChatViewModel.swift
//  Tomo
//
//  Created by Dayem Saeed on 10/10/23.
//

import Foundation

class ChatViewModel: ObservableObject {
    @Published var messageText: String = ""
    @Published var messages: [ChatMessage] = []
    private var messageHistory: [[String: Any]] = [
        ["role": "system", "content": "You are a funny, helpful friend who is caring, empathetic, and gentle..."]
    ]
    private let chatService: ChatService

    init(chatService: ChatService) {
        self.chatService = chatService
    }

    func sendMessage() {
        messageText = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !messageText.isEmpty {
            let userMessage: [String: Any] = ["role": "user", "content": messageText]
            messageHistory.append(userMessage)
            let newMessage = ChatMessage(text: messageText, isSender: true)
            messages.append(newMessage)
            getReply()
            messageText = ""
        }
    }

    private func getReply() {
        chatService.generateText(messages: messageHistory) { [weak self] (responseText) in
            guard let responseText = responseText else {
                // Handle error
                return
            }
            let responseMessage: [String: Any] = ["role": "assistant", "content": responseText]
            self?.messageHistory.append(responseMessage)
            let newMessage = ChatMessage(text: responseText, isSender: false)
            self?.messages.append(newMessage)
        }
    }
}

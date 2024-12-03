//
//  ChatViewModel.swift
//  Tomo
//
//  Created by Dayem Saeed on 10/10/23.
//

import Foundation
import Supabase

class ChatViewModel: ObservableObject {
    @Published var messageText: String = ""
    @Published var messages: [ChatMessage] = []
    @Published var hasMoreMessages = false
    
    private var messageHistory: [[String: Any]] = [
        ["role": "system", "content": "Today's date: \(Date()). You are a funny, helpful feline friend who is caring, empathetic, and gentle. You love pizza, movies, and playing with yarn. Your task is to be a friend and companion to the user. You speak like a person using a conversational tone, throwing in some emojis from time to time, and give no indication that you are a bot no matter what. Do not use any special formatting characters in your responses."]
    ]
    private let chatService: ChatService
    private let supabaseClient: SupabaseClient
    private var currentPage = 0
    private let messagesPerPage = 10
    
    init(chatService: ChatService, supabaseClient: SupabaseClient) {
        self.chatService = chatService
        self.supabaseClient = supabaseClient
        
        Task {
            await loadMessages()
        }
    }
    
    func loadMessages() async {
        guard let userId = supabaseClient.auth.currentSession?.user.id else { return }
        
        do {
            let query = supabaseClient
                .from("messages")
                .select()
                .eq("conversation_id", value: userId)
                .order("created_at", ascending: false) // Latest messages first
                .range(from: 0, to: messagesPerPage - 1)
            
            let messages: [ChatMessage] = try await query.execute().value
            
            await MainActor.run {
                self.messages = messages.reversed() // Reverse to show in chronological order
                self.hasMoreMessages = messages.count == messagesPerPage
                self.currentPage = 1
            }
        } catch {
            print("Error loading messages: \(error)")
        }
    }
    
    func loadMoreMessages() async {
        guard let userId = supabaseClient.auth.currentSession?.user.id else { return }
        
        do {
            let startRange = currentPage * messagesPerPage
            let endRange = startRange + messagesPerPage - 1
            
            let query = supabaseClient
                .from("messages")
                .select()
                .eq("conversation_id", value: userId)
                .order("created_at", ascending: false)
                .range(from: startRange, to: endRange)
            
            let olderMessages: [ChatMessage] = try await query.execute().value
            
            await MainActor.run {
                self.messages.insert(contentsOf: olderMessages.reversed(), at: 0)
                self.hasMoreMessages = olderMessages.count == messagesPerPage
                self.currentPage += 1
            }
        } catch {
            print("Error loading more messages: \(error)")
        }
    }
    
    func sendMessage() {
        messageText = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !messageText.isEmpty,
              let userId = supabaseClient.auth.currentSession?.user.id else { return }
        
        Task {
            do {
                let userMessage = messageText // Store message before clearing
                
                // Create new message
                let newMessage = ChatMessage(
                    content: userMessage,
                    isSender: true,
                    conversation_id: userId
                )
                
                // Save to Supabase
                try await supabaseClient
                    .from("messages")
                    .insert(newMessage)
                    .execute()
                
                // Update UI
                await MainActor.run {
                    messages.append(newMessage)
                    messageText = ""
                }
                
                // Add to message history with proper format
                messageHistory.append(["role": "user", "content": userMessage])
                print("Sending message to AI: \(messageHistory)") // Debug print
                getReply()
                
            } catch {
                print("Error sending message: \(error)")
            }
        }
    }

    private func getReply() {
        guard let userId = supabaseClient.auth.currentSession?.user.id else { return }
        
        print("Current message history: \(messageHistory)") // Debug print
        
        chatService.generateText(messages: messageHistory) { [weak self] responseText in
            guard let self = self,
                  let responseText = responseText else { return }
            
            Task {
                do {
                    // Create AI response message
                    let responseMessage = ChatMessage(
                        content: responseText,
                        isSender: false,
                        conversation_id: userId
                    )
                    
                    // Save to Supabase
                    try await self.supabaseClient
                        .from("messages")
                        .insert(responseMessage)
                        .execute()
                    
                    // Update UI and message history
                    await MainActor.run {
                        self.messages.append(responseMessage)
                        self.messageHistory.append(["role": "assistant", "content": responseText])
                    }
                } catch {
                    print("Error saving AI response: \(error)")
                }
            }
        }
    }
}

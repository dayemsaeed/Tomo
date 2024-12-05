//
//  ChatView.swift
//  Tomo
//
//  Created by Dayem Saeed on 4/1/23.
//

import SwiftUI

/// The `ChatView` manages the overall chat interface, including displaying chat messages and handling user input.
struct ChatView: View {
    @EnvironmentObject var chatViewModel: ChatViewModel
    @FocusState private var chatIsFocused: Bool
    @State private var isTyping = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Messages
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    LazyVStack {
                        if chatViewModel.hasMoreMessages {
                            ProgressView()
                                .onAppear {
                                    Task {
                                        await chatViewModel.loadMoreMessages()
                                    }
                                }
                        }
                        
                        ForEach(chatViewModel.messages) { message in
                            ChatRow(message: message)
                                .id(message.id)
                        }
                        
                        if isTyping {
                            HStack {
                                TypingIndicator()
                                    .padding(.leading)
                                Spacer()
                            }
                        }
                    }
                    .padding(.vertical)
                }
                .onChange(of: chatViewModel.messages.count) { oldCount, newCount in
                    scrollToLatest(proxy: scrollViewProxy)
                }
                .onAppear {
                    scrollToLatest(proxy: scrollViewProxy)
                }
            }
            .background(Color(.systemBackground))
            
            // Message input
            VStack(spacing: 0) {
                Divider()
                chatInputArea
            }
            .background(Color(.systemBackground))
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 12) {
                    // Profile image
                    Circle()
                        .fill(Color.seherText)
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image("SplashLogo")
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                        )
                    
                    // Name and status
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Seher")
                            .font(.headline)
                        if isTyping {
                            Text("typing...")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .onTapGesture {
            dismissKeyboard()
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    dismissKeyboard()
                }
            }
        }
    }
    
    // Function to dismiss keyboard
    private func dismissKeyboard() {
        chatIsFocused = false
    }
    
    // Message input area
    private var chatInputArea: some View {
        HStack(alignment: .bottom, spacing: 10) {
            // Message TextField
            TextField("Message", text: $chatViewModel.messageText, axis: .vertical)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .lineLimit(1...5)
                .focused($chatIsFocused)
                .tint(.seherText)
            
            // Send button
            if !chatViewModel.messageText.isEmpty {
                Button(action: {
                    isTyping = true
                    chatViewModel.sendMessage()
                    dismissKeyboard() // Dismiss keyboard after sending
                    
                    // Simulate typing delay and hide indicator
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isTyping = false
                    }
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.seherText)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
    
    // Function to scroll to the latest message
    private func scrollToLatest(proxy: ScrollViewProxy) {
        if let latestMessage = chatViewModel.messages.last {
            proxy.scrollTo(latestMessage.id, anchor: .bottom)
        }
    }
}

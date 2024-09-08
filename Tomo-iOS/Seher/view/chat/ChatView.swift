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
    @FocusState private var chatIsFocused: Bool  // Manage focus on the chat input field

    var body: some View {
        VStack {
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    LazyVStack {
                        ForEach(chatViewModel.messages, id: \.id) { message in
                            ChatRow(message: message)  // Display each message as a ChatRow
                        }
                    }
                    .onChange(of: chatViewModel.messages.count, perform: { _ in
                        withAnimation(.spring()) {
                            scrollViewProxy.scrollTo(chatViewModel.messages.last?.id, anchor: .bottom)
                        }
                    })
                }
            }
            
            TypingIndicator()  // Show typing indicator when the other user is typing
                .padding(.horizontal, 30)
            
            chatInputArea  // Show chat input area for the user to send messages
        }
    }

    /// The view for the chat input area where the user types messages.
    private var chatInputArea: some View {
        HStack(alignment: .center, spacing: 10) {
            TextField("Message", text: $chatViewModel.messageText)
                .multilineTextAlignment(.leading)
                .lineLimit(0)
                .focused($chatIsFocused)

            if !chatViewModel.messageText.isEmpty {
                Button(action: {
                    chatViewModel.sendMessage()
                    chatIsFocused = false
                }) {
                    Image(systemName: "arrow.up")
                        .imageScale(.medium)
                        .frame(width: 30, height: 30)
                        .background(Color.seherText)
                        .foregroundColor(Color.white)
                        .clipShape(Circle())
                }
            }
        }
        .padding(10)
        .overlay(Capsule().stroke(.tertiary, lineWidth: 1).opacity(0.7))
        .padding(.trailing, 6)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()  // Replace with appropriate preview
    }
}

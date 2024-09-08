//
//  ChatRow.swift
//  Tomo
//
//  Created by Dayem Saeed on 4/1/23.
//

import SwiftUI

/// The `ChatRow` view is responsible for displaying individual chat messages in a conversation.
struct ChatRow: View {
    var message: ChatMessage  // The message to be displayed
    
    var body: some View {
        HStack {
            if message.isSender {
                Spacer()  // Align the sent message to the right
            }
            
            Text(message.text)
                .padding(10)
                .background(ChatBubble(isSender: message.isSender).fill(message.isSender ? Color.seherText : Color.gray))
                .foregroundColor(message.isSender ? .white : .black)
            
            if !message.isSender {
                Spacer()  // Align the received message to the left
            }
        }
        .padding(.horizontal)
    }
}

struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        ChatRow(message: ChatMessage(text: "Hello", isSender: true))
    }
}
